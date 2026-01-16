package com.refillio.modules.inventory.adapter.in;

import com.refillio.modules.catalog.domain.CanonicalProduct;
import com.refillio.modules.catalog.domain.CatalogService;
import com.refillio.modules.inventory.adapter.in.dto.AddToPantryRequest;
import com.refillio.modules.inventory.adapter.in.dto.ConsumptionRequest;
import com.refillio.modules.inventory.adapter.in.dto.InventoryItemResponse;
import com.refillio.modules.inventory.domain.InventoryItem;
import com.refillio.modules.inventory.domain.InventoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/inventory")
@RequiredArgsConstructor
public class InventoryController {

    private final InventoryService inventoryService;
    private final CatalogService catalogService;

    // For MVP, passing User ID directly. In real app -> SecurityContext
    @GetMapping
    public List<InventoryItemResponse> getPantry(@RequestParam UUID userId) {
        List<InventoryItem> items = inventoryService.getUserPantry(userId);
        
        // Optimize: Batch fetch products? For MVP, simplistic fetch.
        // Or fetch all needed products in one go.
        // CatalogService doesn't have batch fetch yet. Loop for now.
        
        return items.stream().map(this::toDto).collect(Collectors.toList());
    }

    @PostMapping
    public InventoryItemResponse addToPantry(@RequestParam UUID userId, @RequestBody AddToPantryRequest request) {
        InventoryItem item = inventoryService.addItemToPantry(
                userId,
                request.getProductIdAsUuid(),
                request.quantity(),
                request.reorderPoint()
        );
        return toDto(item);
    }

    @PostMapping("/{id}/consumption")
    public ResponseEntity<Void> logConsumption(@PathVariable UUID id, @RequestBody ConsumptionRequest request) {
        inventoryService.logConsumption(id, request.amount(), request.eventType());
        return ResponseEntity.ok().build();
    }

    @ExceptionHandler(com.refillio.modules.inventory.domain.InsufficientInventoryException.class)
    public ResponseEntity<String> handleInsufficientInventory(com.refillio.modules.inventory.domain.InsufficientInventoryException ex) {
        return ResponseEntity.badRequest().body(ex.getMessage());
    }
    
    private InventoryItemResponse toDto(InventoryItem item) {
        CanonicalProduct product = catalogService.getProductById(item.getCanonicalProductId())
                .orElse(null);
                
        InventoryItemResponse.ProductSummary productSummary = null;
        if (product != null) {
            String unitSymbol = product.getBaseUnit() != null ? product.getBaseUnit().getSymbol() : "?";
            productSummary = new InventoryItemResponse.ProductSummary(
                product.getId(),
                product.getName(),
                unitSymbol
            );
        }
        
        return new InventoryItemResponse(
                item.getId(),
                item.getUserId(),
                productSummary,
                item.getCurrentQty(),
                item.getReorderPoint()
        );
    }
}
