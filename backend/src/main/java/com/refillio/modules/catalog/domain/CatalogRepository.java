package com.refillio.modules.catalog.domain;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface CatalogRepository {
    List<CanonicalProduct> findAllProducts();
    Optional<CanonicalProduct> findProductById(UUID id);
    CanonicalProduct saveProduct(CanonicalProduct product);
    
    // Auxiliary
    List<Category> findAllCategories();
    List<MeasurementUnit> findAllMeasurementUnits();
}
