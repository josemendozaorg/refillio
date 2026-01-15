package com.refillio.modules.inventory.adapter.out;

import com.refillio.modules.inventory.domain.ProcurementOrder;
import com.refillio.modules.inventory.domain.ProcurementOrderItem;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.assertNotNull;

import com.refillio.TestcontainersConfiguration;
import org.springframework.context.annotation.Import;

@SpringBootTest
@Import(TestcontainersConfiguration.class)
class JpaProcurementRepositoryAdapterTest {

    @Autowired
    private JpaProcurementRepositoryAdapter adapter;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Test
    void saveOrder_NewOrder_ShouldPersistSuccessfully() {
        UUID userId = UUID.randomUUID();
        
        // Seed User
        jdbcTemplate.update("INSERT INTO users (id, email) VALUES (?, ?)", userId, "test-procure-" + userId + "@example.com");

        ProcurementOrder order = new ProcurementOrder(
            null, // Should be null for new
            userId,
            "draft",
            BigDecimal.ZERO,
            BigDecimal.ZERO,
            LocalDateTime.now()
        );

        ProcurementOrder saved = adapter.saveOrder(order);
        
        assertNotNull(saved.getId());
    }

    @Test
    void saveOrderItem_NewItem_ShouldPersistSuccessfully() {
        UUID userId = UUID.randomUUID();
        UUID productId = UUID.randomUUID();

        // Seed dependencies
        jdbcTemplate.update("INSERT INTO users (id, email) VALUES (?, ?)", userId, "test-procure-item-" + userId + "@example.com");
        // Use insert on conflict update to ensure we don't fail if ID exists but symbol differs (though 998 should be unique to this test)
        // Actually best to just use ON CONFLICT DO NOTHING for ID, and ensure symbol is unique.
        jdbcTemplate.update("INSERT INTO measurement_units (id, symbol, type) VALUES (998, 'kg-test', 'mass') ON CONFLICT (id) DO NOTHING");
        jdbcTemplate.update("INSERT INTO categories (id, name) VALUES (998, 'Procure Cat Test') ON CONFLICT (id) DO NOTHING");
        jdbcTemplate.update("INSERT INTO canonical_products (id, category_id, base_unit_id, name) VALUES (?, 998, 998, 'Procure Product')", productId);

        // Create Order
        ProcurementOrder order = new ProcurementOrder(
            null, 
            userId,
            "draft",
            BigDecimal.ZERO,
            BigDecimal.ZERO,
            LocalDateTime.now()
        );
        ProcurementOrder savedOrder = adapter.saveOrder(order);

        // Create Item
        ProcurementOrderItem item = new ProcurementOrderItem(
            null, // Should be null for new
            savedOrder.getId(),
            null,
            productId,
            5,
            null,
            null
        );

        ProcurementOrderItem savedItem = adapter.saveOrderItem(item);

        assertNotNull(savedItem.getId());
    }
}
