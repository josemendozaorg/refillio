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
        BigDecimal newQty;

        if ("exhausted".equalsIgnoreCase(eventType)) {
            newQty = BigDecimal.ZERO;
            // The qtyConsumed for the log should represent what was left
            qtyConsumed = previousQty;
        } else {
            newQty = previousQty.subtract(qtyConsumed);
            if (newQty.compareTo(BigDecimal.ZERO) < 0) {
                newQty = BigDecimal.ZERO; // Prevent negative stock
            }
        }

        item.setCurrentQty(newQty);
        item.setUpdatedAt(LocalDateTime.now());
        inventoryRepository.save(item);

        // Save Log
        ConsumptionLog log = ConsumptionLog.create(inventoryItemId, qtyConsumed, eventType);
        consumptionLogRepository.save(log);

        // Check Par Level -> Trigger Reorder
        // Logic: If we dropped from above par to at/below par, or if we are just below par.
        // Simplest: If current <= reorderPoint, ensure it's on the shopping list.
        if (newQty.compareTo(item.getReorderPoint()) <= 0) {
            // How much to order? Simplest: 1 unit or (Par - Current + Buffer).
            // For MVP Phase 1: Just add 1 to the shopping list (or ensure it's there).
            procurementService.createOrUpdateDraftOrder(item.getUserId(), item.getCanonicalProductId(), 1);
        }
    }
}
