package com.refillio.modules.inventory.domain;

import java.util.UUID;
import java.util.Optional;
import java.util.List;

public interface ProcurementRepository {
    // Orders
    ProcurementOrder saveOrder(ProcurementOrder order);
    Optional<ProcurementOrder> findDraftOrderByUserId(UUID userId);

    // Items
    ProcurementOrderItem saveOrderItem(ProcurementOrderItem item);
    List<ProcurementOrderItem> findItemsByOrderId(UUID orderId);
    Optional<ProcurementOrderItem> findItemByOrderAndProduct(UUID orderId, UUID canonicalProductId);
}
