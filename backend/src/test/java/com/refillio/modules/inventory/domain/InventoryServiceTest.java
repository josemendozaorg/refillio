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
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(MockitoExtension.class)
class InventoryServiceTest {

    @Mock
    private InventoryRepository inventoryRepository;

    @Mock
    private ConsumptionLogRepository consumptionLogRepository;

    @Mock
    private ProcurementService procurementService;

    @InjectMocks
    private InventoryService inventoryService;

    private UUID userId;
    private UUID productId;
    private UUID inventoryItemId;

    @BeforeEach
    void setUp() {
        userId = UUID.randomUUID();
        productId = UUID.randomUUID();
        inventoryItemId = UUID.randomUUID();
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

    @Test
    void logConsumption_Opened_ShouldDecrementAndLog() {
        InventoryItem item = new InventoryItem(inventoryItemId, userId, productId, new BigDecimal("5.0"), new BigDecimal("1.0"), false, null);

        when(inventoryRepository.findById(inventoryItemId)).thenReturn(Optional.of(item));

        inventoryService.logConsumption(inventoryItemId, new BigDecimal("1.0"), "opened");

        assertEquals(new BigDecimal("4.0"), item.getCurrentQty());
        verify(consumptionLogRepository).save(any(ConsumptionLog.class));
        verify(inventoryRepository).save(item);
        // Should NOT trigger reorder (4.0 > 1.0)
        verify(procurementService, never()).createOrUpdateDraftOrder(any(), any(), anyInt());
    }

    @Test
    void logConsumption_Exhausted_ShouldSetZeroAndTriggerReorder() {
        InventoryItem item = new InventoryItem(inventoryItemId, userId, productId, new BigDecimal("2.5"), new BigDecimal("2.0"), true, null);

        when(inventoryRepository.findById(inventoryItemId)).thenReturn(Optional.of(item));

        inventoryService.logConsumption(inventoryItemId, BigDecimal.ZERO, "exhausted"); // Qty is ignored if exhausted, sets to 0

        assertEquals(BigDecimal.ZERO, item.getCurrentQty());
        verify(consumptionLogRepository).save(any(ConsumptionLog.class));
        verify(inventoryRepository).save(item);
        // Should trigger reorder (0.0 <= 2.0)
        verify(procurementService).createOrUpdateDraftOrder(eq(userId), eq(productId), anyInt());
    }

    @Test
    void logConsumption_BelowPar_ShouldTriggerReorder() {
        InventoryItem item = new InventoryItem(inventoryItemId, userId, productId, new BigDecimal("2.0"), new BigDecimal("2.0"), true, null);

        when(inventoryRepository.findById(inventoryItemId)).thenReturn(Optional.of(item));

        // Consume 1 -> 1.0. Par is 2.0. So 1.0 <= 2.0 -> Reorder.
        inventoryService.logConsumption(inventoryItemId, new BigDecimal("1.0"), "opened");

        assertEquals(new BigDecimal("1.0"), item.getCurrentQty());
        verify(procurementService).createOrUpdateDraftOrder(eq(userId), eq(productId), anyInt());
    }
}
