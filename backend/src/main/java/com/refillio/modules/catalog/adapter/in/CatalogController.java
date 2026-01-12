package com.refillio.modules.catalog.adapter.in;

import com.refillio.modules.catalog.adapter.in.dto.CategoryResponse;
import com.refillio.modules.catalog.adapter.in.dto.MeasurementUnitResponse;
import com.refillio.modules.catalog.adapter.in.dto.ProductResponse;
import com.refillio.modules.catalog.domain.CanonicalProduct;
import com.refillio.modules.catalog.domain.CatalogService;
import com.refillio.modules.catalog.domain.Category;
import com.refillio.modules.catalog.domain.MeasurementUnit;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/catalog")
@RequiredArgsConstructor
public class CatalogController {
    
    private final CatalogService catalogService;

    @GetMapping("/products")
    public List<ProductResponse> getAllProducts() {
        return catalogService.getAllProducts().stream()
                .map(this::toDto)
                .collect(Collectors.toList());
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
