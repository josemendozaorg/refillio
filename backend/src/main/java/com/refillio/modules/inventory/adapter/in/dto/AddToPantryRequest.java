package com.refillio.modules.inventory.adapter.in.dto;

import java.math.BigDecimal;
import java.util.UUID;

public record AddToPantryRequest(
    UUID productId,
    BigDecimal quantity,
    BigDecimal reorderPoint
) {}
