package com.refillio.modules.catalog.adapter.out;

import com.refillio.modules.catalog.domain.CanonicalProduct;
import com.refillio.modules.catalog.domain.CatalogRepository;
import com.refillio.modules.catalog.domain.Category;
import com.refillio.modules.catalog.domain.MeasurementUnit;
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
    public CanonicalProduct saveProduct(CanonicalProduct product) {
        JpaCanonicalProduct entity = toEntity(product);
        // Assuming categories/units exist or are cascaded. For now assuming they exist and we fetch reference?
        // Actually for simplicity, let's just save. If ID is null it inserts.
        JpaCanonicalProduct saved = productRepository.save(entity);
        return toDomain(saved);
    }

    @Override
    public List<Category> findAllCategories() {
        return categoryRepository.findAll().stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<MeasurementUnit> findAllMeasurementUnits() {
        return unitRepository.findAll().stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    // Mappers

    private CanonicalProduct toDomain(JpaCanonicalProduct entity) {
        Category category = entity.getCategory() != null ? toDomain(entity.getCategory()) : null;
        MeasurementUnit unit = entity.getBaseUnit() != null ? toDomain(entity.getBaseUnit()) : null;
        return new CanonicalProduct(entity.getId(), entity.getName(), entity.getDescription(), category, unit);
    }
    
    // Reverse mapper for saving (simplified)
    private JpaCanonicalProduct toEntity(CanonicalProduct domain) {
        JpaCanonicalProduct entity = new JpaCanonicalProduct();
        entity.setId(domain.getId());
        entity.setName(domain.getName());
        entity.setDescription(domain.getDescription());
        
        if (domain.getCategory() != null) {
            // Ideally we should fetch the attached entity or use getReferenceById
            // For MVP assuming passing full object or mapped properly
             JpaCategory cat = new JpaCategory();
             cat.setId(domain.getCategory().getId());
             entity.setCategory(cat);
        }
        
        if (domain.getBaseUnit() != null) {
             JpaMeasurementUnit unit = new JpaMeasurementUnit();
             unit.setId(domain.getBaseUnit().getId());
             entity.setBaseUnit(unit);
        }
        
        return entity;
    }

    private Category toDomain(JpaCategory entity) {
        return new Category(entity.getId(), entity.getName(), entity.getParentId(), entity.getSlug());
    }

    private MeasurementUnit toDomain(JpaMeasurementUnit entity) {
        return new MeasurementUnit(entity.getId(), entity.getSymbol(), entity.getType());
    }
}
