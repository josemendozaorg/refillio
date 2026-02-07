package com.refillio.modules.catalog.adapter.out;

import com.refillio.modules.catalog.adapter.out.JpaCategory;
import com.refillio.modules.catalog.adapter.out.JpaMeasurementUnit;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Component
public class DataSeeder implements CommandLineRunner {
    private final SpringDataCategoryRepository categoryRepository;
    private final SpringDataMeasurementUnitRepository unitRepository;

    public DataSeeder(SpringDataCategoryRepository categoryRepository,
                      SpringDataMeasurementUnitRepository unitRepository) {
        this.categoryRepository = categoryRepository;
        this.unitRepository = unitRepository;
    }

    @Override
    @Transactional
    public void run(String... args) throws Exception {
        if (categoryRepository.count() == 0) {
            categoryRepository.saveAll(List.of(
                    new JpaCategory(null, "Home", null, "home"),
                    new JpaCategory(null, "Kitchen", null, "kitchen"),
                    new JpaCategory(null, "Hygiene", null, "hygiene")
            ));
        }
        if (unitRepository.count() == 0) {
            unitRepository.saveAll(List.of(
                    new JpaMeasurementUnit(null, "roll", "volume"),
                    new JpaMeasurementUnit(null, "ml", "volume"),
                    new JpaMeasurementUnit(null, "kg", "mass"),
                    new JpaMeasurementUnit(null, "pcs", "count")
            ));
        }
    }
}
