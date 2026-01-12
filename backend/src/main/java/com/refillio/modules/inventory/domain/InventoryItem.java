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
public class InventoryItem {
    private UUID id;
    private UUID userId;
    private UUID canonicalProductId;
    
    private BigDecimal currentQty;
    private BigDecimal reorderPoint; // Par Level
    private Boolean autoReorder;
    
    private LocalDateTime updatedAt;
    
    // Auxiliary
    // private CanonicalProduct cachedProduct; // Could store name for display if we fetched it
}
