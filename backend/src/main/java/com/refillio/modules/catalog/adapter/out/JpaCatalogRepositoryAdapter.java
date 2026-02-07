package com.refillio.modules.catalog.adapter.out;

import com.refillio.modules.catalog.domain.*;
import com.refillio.modules.catalog.adapter.out.JpaCanonicalProduct;
import com.refillio.modules.catalog.adapter.out.JpaCategory;
import com.refillio.modules.catalog.adapter.out.JpaMeasurementUnit;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class JpaCatalogRepositoryAdapter implements CatalogRepository {
    private final SpringDataCanonicalProductRepository productRepository;
    private final SpringDataCategoryRepository categoryRepository;
    private final SpringDataMeasurementUnitRepository unitRepository;

    @Override
    public List<CanonicalProduct> findAllProducts() {
        return productRepository.findAll().stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public Optional<CanonicalProduct> findProductById(UUID id) {
        return productRepository.findById(id).map(this::toDomain);
    }

    @Override
    public void deleteProductById(UUID id) {
        productRepository.deleteById(id);
    }

    @Override
    public CanonicalProduct updateProduct(CanonicalProduct product) {
        if (!productRepository.existsById(product.getId())) {
            throw new IllegalArgumentException("Product not found: " + product.getId());
        }
        return saveProduct(product);
    }

    @Override
    public List<Category> findAllCategories() {
        return categoryRepository.findAll().stream()
                .map(this::toDomainCategory)
                .collect(Collectors.toList());
    }

    @Override
    public List<MeasurementUnit> findAllMeasurementUnits() {
        return unitRepository.findAll().stream()
                .map(this::toDomainUnit)
                .collect(Collectors.toList());
    }

    @Override
    public CanonicalProduct saveProduct(CanonicalProduct product) {
        JpaCanonicalProduct entity = toEntity(product);
        JpaCanonicalProduct saved = productRepository.save(entity);
        return toDomain(saved);
    }

    // Mapper from JPA to domain
    private CanonicalProduct toDomain(JpaCanonicalProduct entity) {
        Category category = entity.getCategory() != null ? toDomainCategory(entity.getCategory()) : null;
        MeasurementUnit unit = entity.getBaseUnit() != null ? toDomainUnit(entity.getBaseUnit()) : null;
        return new CanonicalProduct(entity.getId(), entity.getName(), entity.getDescription(), category, unit);
    }

    // Mapper from domain to JPA
    private JpaCanonicalProduct toEntity(CanonicalProduct domain) {
        JpaCanonicalProduct entity = new JpaCanonicalProduct();
        entity.setId(domain.getId());
        entity.setName(domain.getName());
        entity.setDescription(domain.getDescription());
        if (domain.getCategory() != null) {
            JpaCategory cat = categoryRepository.findById(domain.getCategory().getId()).orElseThrow(() -> new IllegalArgumentException("Category not found: " + domain.getCategory().getId()));
            entity.setCategory(cat);
        }
        if (domain.getBaseUnit() != null) {
            JpaMeasurementUnit unit = unitRepository.findById(domain.getBaseUnit().getId()).orElseThrow(() -> new IllegalArgumentException("Unit not found: " + domain.getBaseUnit().getId()));
            entity.setBaseUnit(unit);
        }
        return entity;
    }

    private Category toDomainCategory(JpaCategory entity) {
        return new Category(entity.getId(), entity.getName(), entity.getParentId(), entity.getSlug());
    }

    private MeasurementUnit toDomainUnit(JpaMeasurementUnit entity) {
        return new MeasurementUnit(entity.getId(), entity.getSymbol(), entity.getType());
    }
}
