package com.refillio.modules.catalog.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class MeasurementUnit {
    private Integer id;
    private String symbol; // ml, l, roll, pcs
    private String type; // volume, mass, count
}
