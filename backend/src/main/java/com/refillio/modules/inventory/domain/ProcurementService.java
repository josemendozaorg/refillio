package com.refillio.modules.inventory.domain;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ProcurementService {
    private final ProcurementRepository procurementRepository;

    public void createOrUpdateDraftOrder(UUID userId, UUID canonicalProductId, int quantityToAdd) {
        // 1. Find existing draft order for user
        ProcurementOrder order = procurementRepository.findDraftOrderByUserId(userId)
            .orElseGet(() -> {
                ProcurementOrder newOrder = new ProcurementOrder(
                    null,
                    userId,
                    "draft",
                    BigDecimal.ZERO,
                    BigDecimal.ZERO,
                    LocalDateTime.now()
                );
                return procurementRepository.saveOrder(newOrder);
            });

        // 2. Check if item already exists in order
        Optional<ProcurementOrderItem> existingItem = procurementRepository.findItemByOrderAndProduct(order.getId(), canonicalProductId);

        if (existingItem.isPresent()) {
            // Update quantity
            ProcurementOrderItem item = existingItem.get();
            item.setQuantity(item.getQuantity() + quantityToAdd);
            procurementRepository.saveOrderItem(item);
        } else {
            // Create new item
            ProcurementOrderItem newItem = new ProcurementOrderItem(
                null,
                order.getId(),
                null, // listingId
                canonicalProductId,
                quantityToAdd,
                null, // price
                null // ref price
            );
            procurementRepository.saveOrderItem(newItem);
        }
    }
}
