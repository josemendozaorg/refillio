package com.refillio.modules.inventory.adapter.out;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "consumption_logs")
@Getter
@Setter
public class JpaConsumptionLog {
    @Id
    @GeneratedValue
    private UUID id;

    @Column(name = "inventory_item_id")
    private UUID inventoryItemId;

    @Column(name = "qty_consumed")
    private BigDecimal qtyConsumed;

    @Column(name = "event_type")
    private String eventType;

    @Column(name = "occurred_at")
    private LocalDateTime occurredAt;
}
