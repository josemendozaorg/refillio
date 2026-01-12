package com.refillio.modules.catalog.adapter.in.dto;

import java.util.UUID;

public record CategoryResponse(
    Integer id,
    String name,
    Integer parentId,
    String slug
) {}
