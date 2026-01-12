package com.refillio.modules.inventory.domain;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface InventoryRepository {
    List<InventoryItem> findAllByUserId(UUID userId);
    Optional<InventoryItem> findByUserIdAndProductId(UUID userId, UUID productId);
    InventoryItem save(InventoryItem item);
}
