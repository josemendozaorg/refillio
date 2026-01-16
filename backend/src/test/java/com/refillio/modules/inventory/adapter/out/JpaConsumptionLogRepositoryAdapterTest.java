package com.refillio.modules.inventory.adapter.out;

import com.refillio.modules.inventory.domain.ConsumptionLog;
import com.refillio.modules.inventory.domain.InventoryItem;
import com.refillio.modules.inventory.domain.InventoryRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.assertNotNull;

@SpringBootTest
class JpaConsumptionLogRepositoryAdapterTest {

    @Autowired
    private JpaConsumptionLogRepositoryAdapter adapter;

    @Autowired
    private InventoryRepository inventoryRepository;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Test
    void save_NewLog_ShouldPersistSuccessfully() {
        UUID userId = UUID.randomUUID();
        UUID productId = UUID.randomUUID();

        // Seed dependencies via JDBC to satisfy FKs
        // Note: Using 999 as ID for static tables to avoid collision with serials if any,
        // though in test db it should be empty.
        
        // 1. User
        jdbcTemplate.update("INSERT INTO users (id, email) VALUES (?, ?)", userId, "test-" + userId + "@example.com");
        
        // 2. Units & Categories (using ON CONFLICT in case they exist from migration or other tests)
        jdbcTemplate.update("INSERT INTO measurement_units (id, symbol, type) VALUES (999, 'unit', 'count') ON CONFLICT (id) DO NOTHING");
        jdbcTemplate.update("INSERT INTO categories (id, name) VALUES (999, 'Test Cat') ON CONFLICT (id) DO NOTHING");
        
        // 3. Product
        jdbcTemplate.update("INSERT INTO canonical_products (id, category_id, base_unit_id, name) VALUES (?, 999, 999, 'Test Product')", productId);

        // 4. Create Inventory Item
        InventoryItem item = new InventoryItem(
            null, 
            userId, 
            productId, 
            BigDecimal.TEN, 
            BigDecimal.ONE, 
            false, 
            LocalDateTime.now()
        );
        InventoryItem savedItem = inventoryRepository.save(item);

        // 5. Create Log using valid Inventory Item ID
        ConsumptionLog log = ConsumptionLog.create(savedItem.getId(), BigDecimal.ONE, "test");
        
        ConsumptionLog saved = adapter.save(log);
        
        assertNotNull(saved.getId());
    }
}
