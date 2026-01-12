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
}
