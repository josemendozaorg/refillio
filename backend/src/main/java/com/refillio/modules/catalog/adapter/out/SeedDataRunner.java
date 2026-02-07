package com.refillio.modules.catalog.adapter.out;

import org.springframework.stereotype.Component;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import com.refillio.modules.catalog.adapter.out.JpaCategory;
import com.refillio.modules.catalog.adapter.out.JpaMeasurementUnit;

@Component
public class SeedDataRunner {
    @Autowired
    private SpringDataCategoryRepository categoryRepo;
    @Autowired
    private SpringDataMeasurementUnitRepository unitRepo;

    @PostConstruct
    public void init() {
        if (categoryRepo.count() == 0) {
            JpaCategory home = new JpaCategory();
            home.setName("Home");
            home.setSlug("home");
            categoryRepo.save(home);

            JpaCategory kitchen = new JpaCategory();
            kitchen.setName("Kitchen");
            kitchen.setSlug("kitchen");
            categoryRepo.save(kitchen);

            JpaCategory hygiene = new JpaCategory();
            hygiene.setName("Hygiene");
            hygiene.setSlug("hygiene");
            categoryRepo.save(hygiene);
        }
        if (unitRepo.count() == 0) {
            JpaMeasurementUnit roll = new JpaMeasurementUnit();
            roll.setSymbol("roll");
            roll.setType("count");
            unitRepo.save(roll);

            JpaMeasurementUnit ml = new JpaMeasurementUnit();
            ml.setSymbol("ml");
            ml.setType("volume");
            unitRepo.save(ml);

            JpaMeasurementUnit kg = new JpaMeasurementUnit();
            kg.setSymbol("kg");
            kg.setType("mass");
            unitRepo.save(kg);

            JpaMeasurementUnit pcs = new JpaMeasurementUnit();
            pcs.setSymbol("pcs");
            pcs.setType("count");
            unitRepo.save(pcs);
        }
    }
}
