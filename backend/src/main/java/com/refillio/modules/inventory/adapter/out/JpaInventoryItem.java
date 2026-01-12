package com.refillio.modules.inventory.adapter.out;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "inventory_items")
@Getter
@Setter
public class JpaInventoryItem {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "user_id", nullable = false)
    private UUID userId;

    @Column(name = "canonical_product_id", nullable = false)
    private UUID canonicalProductId;

    @Column(name = "current_qty", nullable = false)
    private BigDecimal currentQty;

    @Column(name = "reorder_point")
    private BigDecimal reorderPoint;

    @Column(name = "auto_reorder")
    private Boolean autoReorder;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
