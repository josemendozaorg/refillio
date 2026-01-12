package com.refillio.modules.inventory.adapter.in.dto;

import java.math.BigDecimal;
import java.util.UUID;

public record InventoryItemResponse(
    UUID id,
    UUID userId,
    ProductSummary product,
    BigDecimal currentQty,
    BigDecimal reorderPoint
) {
    public record ProductSummary(
        UUID id,
        String name,
        String unitSymbol
    ) {}
}
