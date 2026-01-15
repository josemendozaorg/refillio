package com.refillio.modules.inventory.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ConsumptionLog {
    private UUID id;
    private UUID inventoryItemId;
    private BigDecimal qtyConsumed;
    private String eventType; // 'manual_log', 'opened', 'exhausted', 'auto_estimated'
    private LocalDateTime occurredAt;

    public static ConsumptionLog create(UUID inventoryItemId, BigDecimal qtyConsumed, String eventType) {
        return new ConsumptionLog(null, inventoryItemId, qtyConsumed, eventType, LocalDateTime.now());
    }
}
