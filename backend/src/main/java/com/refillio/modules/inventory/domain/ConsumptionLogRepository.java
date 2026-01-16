package com.refillio.modules.inventory.domain;

import java.util.UUID;
import java.util.List;

public interface ConsumptionLogRepository {
    ConsumptionLog save(ConsumptionLog log);
    List<ConsumptionLog> findByInventoryItemId(UUID inventoryItemId);
}
