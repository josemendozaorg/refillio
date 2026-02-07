package com.refillio.modules.catalog.domain;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class CatalogService {
    private final CatalogRepository catalogRepository;

    public List<CanonicalProduct> getAllProducts() {
        return catalogRepository.findAllProducts();
    }

    public Optional<CanonicalProduct> getProductById(UUID id) {
        return catalogRepository.findProductById(id);
    }

    public CanonicalProduct createProduct(CanonicalProduct product) {
        // Validate unique name
        if (catalogRepository.findAllProducts().stream().anyMatch(p -> p.getName().equalsIgnoreCase(product.getName()))) {
            throw new IllegalArgumentException("Product name already exists: " + product.getName());
        }
        return catalogRepository.saveProduct(product);
    }

    public void deleteProductById(UUID id) {
        catalogRepository.deleteProductById(id);
    }

    public CanonicalProduct updateProduct(CanonicalProduct product) {
        return catalogRepository.updateProduct(product);
    }
}
