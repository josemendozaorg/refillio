package com.refillio.modules.inventory.adapter.out;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.UUID;
import java.util.Optional;

public interface SpringDataProcurementRepository extends JpaRepository<JpaProcurementOrder, UUID> {
    Optional<JpaProcurementOrder> findByUserIdAndStatus(UUID userId, String status);
}
