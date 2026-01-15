package com.refillio.modules.inventory.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;
import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ProcurementOrder {
    private UUID id;
    private UUID userId;
    private String status; // 'draft', 'suggested', 'ordered', 'completed'
    private BigDecimal totalAmount;
    private BigDecimal estimatedSavings;
    private LocalDateTime createdAt;

    // In a real JPA entity this might be a @OneToMany, but for domain we can keep it simple or not include items directly depending on aggregate design.
    // For now, let's keep it simple.
}
