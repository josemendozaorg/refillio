package com.refillio.modules.catalog.adapter.in;

import com.refillio.modules.catalog.adapter.in.dto.CategoryResponse;
import com.refillio.modules.catalog.adapter.in.dto.MeasurementUnitResponse;
import com.refillio.modules.catalog.adapter.in.dto.ProductResponse;
import com.refillio.modules.catalog.adapter.in.dto.ProductCreateRequest;
import com.refillio.modules.catalog.adapter.in.dto.ProductUpdateRequest;
import com.refillio.modules.catalog.adapter.out.JpaCategory;
import com.refillio.modules.catalog.adapter.out.JpaMeasurementUnit;
import com.refillio.modules.catalog.adapter.out.SpringDataCategoryRepository;
import com.refillio.modules.catalog.adapter.out.SpringDataMeasurementUnitRepository;
import com.refillio.modules.catalog.domain.CanonicalProduct;
import com.refillio.modules.catalog.domain.Category;
import com.refillio.modules.catalog.domain.CatalogService;
import com.refillio.modules.catalog.domain.MeasurementUnit;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/products")
@RequiredArgsConstructor
public class CatalogController {
    private final CatalogService catalogService;
    private final SpringDataCategoryRepository categoryRepository;
    private final SpringDataMeasurementUnitRepository unitRepository;

    @GetMapping("/{id}")
    public ProductResponse getProductById(@PathVariable java.util.UUID id) {
        CanonicalProduct product = catalogService.getProductById(id).orElseThrow(() -> new IllegalArgumentException("Product not found"));
        return toDto(product);
    }
    @GetMapping
    public List<ProductResponse> getAllProducts() {
        return catalogService.getAllProducts().stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }
    @PostMapping("")
    public ProductResponse createProduct(@RequestBody ProductCreateRequest request) {
        JpaCategory cat = request.getCategoryId() != null ? categoryRepository.findById(request.getCategoryId()).orElse(null) : null;
        JpaMeasurementUnit unit = request.getBaseUnitId() != null ? unitRepository.findById(request.getBaseUnitId()).orElse(null) : null;
        CanonicalProduct product = new CanonicalProduct();
        product.setName(request.getName());
        product.setDescription(request.getDescription());
        if (cat != null) {
            product.setCategory(new Category(cat.getId(), cat.getName(), cat.getParentId(), cat.getSlug()));
        }
        if (unit != null) {
            product.setBaseUnit(new MeasurementUnit(unit.getId(), unit.getSymbol(), unit.getType()));
        }
        CanonicalProduct created = catalogService.createProduct(product);
        return toDto(created);
    }

    @PutMapping("/{id}")
    public ProductResponse updateProduct(@PathVariable java.util.UUID id, @RequestBody ProductUpdateRequest request) {
        CanonicalProduct existing = catalogService.getProductById(id).orElseThrow(() -> new IllegalArgumentException("Product not found"));
        if (request.getName() != null) existing.setName(request.getName());
        if (request.getDescription() != null) existing.setDescription(request.getDescription());
        if (request.getCategoryId() != null) {
            JpaCategory cat = categoryRepository.findById(request.getCategoryId()).orElse(null);
            if (cat != null) existing.setCategory(new Category(cat.getId(), cat.getName(), cat.getParentId(), cat.getSlug()));
        }
        if (request.getBaseUnitId() != null) {
            JpaMeasurementUnit unit = unitRepository.findById(request.getBaseUnitId()).orElse(null);
            if (unit != null) existing.setBaseUnit(new MeasurementUnit(unit.getId(), unit.getSymbol(), unit.getType()));
        }
        CanonicalProduct updated = catalogService.updateProduct(existing);
        return toDto(updated);
    }

    @DeleteMapping("/{id}")
    public void deleteProduct(@PathVariable java.util.UUID id) {
        catalogService.deleteProductById(id);
    }

    private ProductResponse toDto(CanonicalProduct domain) {
        return new ProductResponse(
                domain.getId(),
                domain.getName(),
                domain.getDescription(),
                domain.getCategory() != null ? toDto(domain.getCategory()) : null,
                domain.getBaseUnit() != null ? toDto(domain.getBaseUnit()) : null
        );
    }

    private CategoryResponse toDto(Category domain) {
        return new CategoryResponse(
                domain.getId(),
                domain.getName(),
                domain.getParentId(),
                domain.getSlug()
        );
    }

    private MeasurementUnitResponse toDto(MeasurementUnit domain) {
        return new MeasurementUnitResponse(
                domain.getId(),
                domain.getSymbol(),
                domain.getType()
        );
    }
}
