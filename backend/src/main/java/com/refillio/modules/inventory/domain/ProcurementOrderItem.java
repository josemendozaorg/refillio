package com.refillio.modules.inventory.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.math.BigDecimal;
import java.util.UUID;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ProcurementOrderItem {
    private UUID id;
    private UUID orderId;
    private UUID listingId; // Nullable
    private UUID canonicalProductId; // Nullable (but one of them should be set)
    private Integer quantity;
    private BigDecimal priceAtPurchase;
    private BigDecimal referenceMarketPrice;
}
