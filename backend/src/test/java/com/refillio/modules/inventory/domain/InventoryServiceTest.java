package com.refillio.modules.inventory.domain;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.Optional;
import java.util.UUID;
import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(MockitoExtension.class)
class InventoryServiceTest {

    @Mock
    private InventoryRepository inventoryRepository;

    @InjectMocks
    private InventoryService inventoryService;

    private UUID userId;
    private UUID productId;

    @BeforeEach
    void setUp() {
        userId = UUID.randomUUID();
        productId = UUID.randomUUID();
    }

    @Test
    void getUserPantry_ShouldReturnList() {
        when(inventoryRepository.findAllByUserId(userId)).thenReturn(List.of());

        var result = inventoryService.getUserPantry(userId);

        assertNotNull(result);
        verify(inventoryRepository).findAllByUserId(userId);
    }

    @Test
    void addItemToPantry_NewItem_ShouldCreateAndSave() {
        when(inventoryRepository.findByUserIdAndProductId(userId, productId)).thenReturn(Optional.empty());
        when(inventoryRepository.save(any(InventoryItem.class))).thenAnswer(invocation -> invocation.getArgument(0));

        var qty = new BigDecimal("2.0");
        var result = inventoryService.addItemToPantry(userId, productId, qty, null);

        assertNotNull(result);
        assertEquals(userId, result.getUserId());
        assertEquals(productId, result.getCanonicalProductId());
        assertEquals(qty, result.getCurrentQty());
        verify(inventoryRepository).save(any(InventoryItem.class));
    }

    @Test
    void addItemToPantry_ExistingItem_ShouldUpdateQuantity() {
        var existing = new InventoryItem(UUID.randomUUID(), userId, productId, new BigDecimal("1.0"), BigDecimal.ONE, false, null);
        
        when(inventoryRepository.findByUserIdAndProductId(userId, productId)).thenReturn(Optional.of(existing));
        when(inventoryRepository.save(any(InventoryItem.class))).thenAnswer(invocation -> invocation.getArgument(0));

        var addQty = new BigDecimal("2.0");
        var result = inventoryService.addItemToPantry(userId, productId, addQty, null);

        assertEquals(new BigDecimal("3.0"), result.getCurrentQty());
        verify(inventoryRepository).save(existing);
    }
}
