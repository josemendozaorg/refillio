package com.refillio.modules.inventory.adapter.in.dto;

import java.math.BigDecimal;
import java.util.UUID;

public record AddToPantryRequest(
    String productId,
    BigDecimal quantity,
    BigDecimal reorderPoint
) {
    public UUID getProductIdAsUuid() {
        return UUID.fromString(productId);
    }
}
