package com.refillio.modules.catalog.adapter.in;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.refillio.modules.catalog.adapter.in.dto.ProductCreateRequest;
import com.refillio.modules.catalog.adapter.in.dto.ProductResponse;
import com.refillio.modules.catalog.adapter.in.dto.ProductUpdateRequest;
import com.refillio.modules.catalog.domain.CanonicalProduct;
import com.refillio.modules.catalog.domain.CatalogService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.util.Collections;
import java.util.UUID;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
class CatalogControllerIntegrationTest {

    private MockMvc mockMvc;

    @Mock
    private CatalogService catalogService;

    @InjectMocks
    private CatalogController catalogController;

    private final ObjectMapper objectMapper = new ObjectMapper();

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(catalogController).build();
    }

    @Test
    void createProduct_ShouldReturnCreatedProduct() throws Exception {
        UUID id = UUID.randomUUID();
        CanonicalProduct created = new CanonicalProduct();
        created.setId(id);
        created.setName("Test Product");
        created.setDescription("Desc");

        when(catalogService.createProduct(any(CanonicalProduct.class))).thenReturn(created);

        ProductCreateRequest request = new ProductCreateRequest("Test Product", "Desc", null, null);

        mockMvc.perform(post("/api/v1/catalog/products")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(id.toString()));
    }

    @Test
    void getAllProducts_ShouldReturnList() throws Exception {
        when(catalogService.getAllProducts()).thenReturn(Collections.emptyList());
        mockMvc.perform(get("/api/v1/catalog/products"))
                .andExpect(status().isOk())
                .andExpect(content().json("[]"));
    }

    @Test
    void updateProduct_ShouldReturnUpdatedProduct() throws Exception {
        UUID id = UUID.randomUUID();
        CanonicalProduct updated = new CanonicalProduct();
        updated.setId(id);
        updated.setName("Updated");
        updated.setDescription("Desc");

        when(catalogService.getProductById(id)).thenReturn(java.util.Optional.of(updated));
        when(catalogService.updateProduct(any(CanonicalProduct.class))).thenReturn(updated);

        ProductUpdateRequest request = new ProductUpdateRequest("Updated", "Desc", null, null);

        mockMvc.perform(put("/api/v1/catalog/products/" + id)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("Updated"));
    }

    @Test
    void deleteProduct_ShouldReturnNoContent() throws Exception {
        UUID id = UUID.randomUUID();
        mockMvc.perform(delete("/api/v1/catalog/products/" + id))
                .andExpect(status().isOk());
    }
}
