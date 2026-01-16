package com.refillio.modules.inventory.adapter.in.dto;

import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public record ConsumptionRequest(
    @NotNull BigDecimal amount,
    @NotNull String eventType // 'opened', 'exhausted', 'manual_log'
) {}
