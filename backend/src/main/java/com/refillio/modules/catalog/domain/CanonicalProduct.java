package com.refillio.modules.catalog.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.util.UUID;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class CanonicalProduct {
    private UUID id;
    private String name;
    private String description;
    
    // In pure DDD these might be object references, but for pragmatic relational backing 
    // keeping IDs or the Objects themselves is a choice. 
    // Given the simplicity, let's keep references to the related domain objects if possible, 
    // or IDs if we want to avoid deep nesting issues early on.
    // Let's use IDs for now for loose coupling, or the objects. 
    // The schema says category_id, base_unit_id.
    
    private Category category;
    private MeasurementUnit baseUnit;
}
