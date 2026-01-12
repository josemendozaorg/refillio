package com.refillio.modules.catalog.adapter.out;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "measurement_units")
@Getter
@Setter
public class JpaMeasurementUnit {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, unique = true)
    private String symbol;

    @Column(nullable = false)
    private String type;
}
