package com.refillio.modules.catalog.adapter.in.dto;

import java.util.UUID;

public record ProductResponse(
    UUID id,
    String name,
    String description,
    CategoryResponse category,
    MeasurementUnitResponse baseUnit
) {}
