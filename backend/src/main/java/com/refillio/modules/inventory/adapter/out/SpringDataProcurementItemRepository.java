package com.refillio.modules.inventory.adapter.out;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.UUID;
import java.util.Optional;
import java.util.List;

public interface SpringDataProcurementItemRepository extends JpaRepository<JpaProcurementOrderItem, UUID> {
    List<JpaProcurementOrderItem> findByOrderId(UUID orderId);
    Optional<JpaProcurementOrderItem> findByOrderIdAndCanonicalProductId(UUID orderId, UUID canonicalProductId);
}
