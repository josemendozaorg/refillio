package com.refillio.modules.catalog.adapter.out;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.util.UUID;

@Entity
@Table(name = "canonical_products")
@Getter
@Setter
public class JpaCanonicalProduct {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "category_id")
    private JpaCategory category;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "base_unit_id")
    private JpaMeasurementUnit baseUnit;

    @Column(nullable = false)
    private String name;

    @Column(columnDefinition = "TEXT")
    private String description;
}
