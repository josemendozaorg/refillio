package com.refillio.modules.inventory.adapter.out;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.UUID;
import java.util.List;

public interface SpringDataConsumptionLogRepository extends JpaRepository<JpaConsumptionLog, UUID> {
    List<JpaConsumptionLog> findByInventoryItemId(UUID inventoryItemId);
}
