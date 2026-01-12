//package com.refillio.modules.inventory.adapter.in;
//
//import com.fasterxml.jackson.databind.ObjectMapper;
//import com.refillio.modules.catalog.domain.CanonicalProduct;
//import com.refillio.modules.catalog.domain.CatalogService;
//import com.refillio.modules.inventory.adapter.in.dto.AddToPantryRequest;
//import com.refillio.modules.inventory.adapter.in.dto.InventoryItemResponse;
//import com.refillio.modules.inventory.domain.InventoryItem;
//import com.refillio.modules.inventory.domain.InventoryService;
//import org.junit.jupiter.api.Test;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
//import org.springframework.boot.test.mock.mockito.MockBean;
//import org.springframework.http.MediaType;
//import org.springframework.test.web.servlet.MockMvc;
//
//import java.math.BigDecimal;
//import java.util.List;
//import java.util.Optional;
//import java.util.UUID;
//
//import static org.mockito.ArgumentMatchers.any;
//import static org.mockito.ArgumentMatchers.eq;
//import static org.mockito.Mockito.when;
//import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
//import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
//import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
//
//@WebMvcTest(InventoryController.class)
//class InventoryControllerIntegrationTest {
//
//    @Autowired
//    private MockMvc mockMvc;
//
//    @MockBean
//    private InventoryService inventoryService;
//
//    @MockBean
//    private CatalogService catalogService;
//
//    @Autowired
//    private ObjectMapper objectMapper;
//
//    @Test
//    void getPantry_ShouldReturnList() throws Exception {
//        UUID userId = UUID.randomUUID();
//        when(inventoryService.getUserPantry(userId)).thenReturn(List.of());
//
//        mockMvc.perform(get("/api/v1/inventory")
//                        .param("userId", userId.toString()))
//                .andExpect(status().isOk())
//                .andExpect(content().json("[]"));
//    }
//
//    @Test
//    void addToPantry_ShouldReturnItem() throws Exception {
//        UUID userId = UUID.randomUUID();
//        UUID productId = UUID.randomUUID();
//        AddToPantryRequest request = new AddToPantryRequest(productId, new BigDecimal("2.0"), BigDecimal.ONE);
//
//        InventoryItem item = new InventoryItem(UUID.randomUUID(), userId, productId, new BigDecimal("2.0"), BigDecimal.ONE, false, null);
//        
//        when(inventoryService.addItemToPantry(eq(userId), eq(productId), any(), any())).thenReturn(item);
//        
//        // Mock Catalog Service for DTO enhancement
//        when(catalogService.getProductById(productId)).thenReturn(Optional.empty());
//
//        mockMvc.perform(post("/api/v1/inventory")
//                        .param("userId", userId.toString())
//                        .contentType(MediaType.APPLICATION_JSON)
//                        .content(objectMapper.writeValueAsString(request)))
//                .andExpect(status().isOk())
//                .andExpect(jsonPath("$.id").exists())
//                .andExpect(jsonPath("$.currentQty").value(2.0));
//    }
//}
