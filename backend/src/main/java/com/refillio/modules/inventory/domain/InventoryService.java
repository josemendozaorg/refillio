package com.refillio.modules.inventory.domain;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class InventoryService {
    private final InventoryRepository inventoryRepository;
    private final ConsumptionLogRepository consumptionLogRepository;
    private final ProcurementService procurementService;

    public List<InventoryItem> getUserPantry(UUID userId) {
        return inventoryRepository.findAllByUserId(userId);
    }
    
    @Transactional
    public InventoryItem addItemToPantry(UUID userId, UUID productId, BigDecimal initialQty, BigDecimal reorderPoint) {
        // Check if exists
        return inventoryRepository.findByUserIdAndProductId(userId, productId)
                .map(existing -> {
                    // Update existing
                    existing.setCurrentQty(existing.getCurrentQty().add(initialQty));
                    if(reorderPoint != null) {
                        existing.setReorderPoint(reorderPoint);
                    }
                    existing.setUpdatedAt(LocalDateTime.now());
                    return inventoryRepository.save(existing);
                })
                .orElseGet(() -> {
                    // Create new
                    InventoryItem newItem = new InventoryItem(
                        null, // ID will be generated
                        userId,
                        productId,
                        initialQty != null ? initialQty : BigDecimal.ZERO,
                        reorderPoint != null ? reorderPoint : BigDecimal.ONE,
                        false,
                        LocalDateTime.now()
                    );
                    return inventoryRepository.save(newItem);
                });
    }

    @Transactional
    public void logConsumption(UUID inventoryItemId, BigDecimal qtyConsumed, String eventType) {
        InventoryItem item = inventoryRepository.findById(inventoryItemId)
            .orElseThrow(() -> new IllegalArgumentException("Inventory Item not found: " + inventoryItemId));

        BigDecimal previousQty = item.getCurrentQty();
        
        // 1. Validation: Cannot consume if already empty (unless it's an 'exhausted' event which acts as a reset/correction, but user asked for validation on decrease)
        // Simplest interpretation: If I try to consume '1' and I have '0', that's invalid.
        if (previousQty.compareTo(BigDecimal.ZERO) == 0 && !"exhausted".equalsIgnoreCase(eventType)) {
             throw new InsufficientInventoryException("Cannot consume from empty inventory. Item ID: " + inventoryItemId);
        }

        BigDecimal newQty;

        if ("exhausted".equalsIgnoreCase(eventType)) {
            newQty = BigDecimal.ZERO;
            // The qtyConsumed for the log should represent what was left
            qtyConsumed = previousQty;
        } else {
            // 2. Validation: Check if consuming more than available?
            // "When decreasing an item that has zero availability... it should have sent a validation message"
            // If I have 2 and consume 3, technically that's also "no availability" for the 3rd unit.
            // Let's enforce that we cannot consume more than we have? Or just that we can't start from 0?
            // User said: "decreasing an item that has zero availability... shows in UI like it was effectively reduced... needs validation"
            // This strongly implies: Pre-check if > 0.
            
            newQty = previousQty.subtract(qtyConsumed);
            if (newQty.compareTo(BigDecimal.ZERO) < 0) {
                 // Option A: Allow partial consumption and set to 0?
                 // Option B: Reject?
                 // Given user context "validation message... no availability", Rejecting seems safer for "consuming from zero".
                 // But if I have 0.5 and consume 1 (e.g. strict portions), maybe I just ran out?
                 // Let's stick to the specific request: "decreasing an item that has zero availability".
                 // Logic implemented above handles the "start from zero" case.
                 
                 newQty = BigDecimal.ZERO; // Cap at zero if we over-consume slightly
            }
        }

        // Check Par Level -> Trigger Reorder BEFORE deleting, because we need valid item data
        if (newQty.compareTo(item.getReorderPoint()) <= 0) {
            procurementService.createOrUpdateDraftOrder(item.getUserId(), item.getCanonicalProductId(), 1);
        }

        // Save Log (record what happened accurately)
        ConsumptionLog log = ConsumptionLog.create(inventoryItemId, qtyConsumed, eventType);
        consumptionLogRepository.save(log);

        // 3. Auto-Removal
        if (newQty.compareTo(BigDecimal.ZERO) == 0) {
            inventoryRepository.delete(item);
        } else {
            item.setCurrentQty(newQty);
            item.setUpdatedAt(LocalDateTime.now());
            inventoryRepository.save(item);
        }
    }
}
