package com.refillio.modules.inventory.adapter.out;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "procurement_orders")
@Getter
@Setter
public class JpaProcurementOrder {
    @Id
    @GeneratedValue
    private UUID id;

    @Column(name = "user_id")
    private UUID userId;

    private String status;

    @Column(name = "total_amount")
    private BigDecimal totalAmount;

    @Column(name = "estimated_savings")
    private BigDecimal estimatedSavings;

    @Column(name = "created_at")
    private LocalDateTime createdAt;
}
