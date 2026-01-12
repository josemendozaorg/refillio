package com.refillio.modules.catalog.adapter.out;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "categories")
@Getter
@Setter
public class JpaCategory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false)
    private String name;

    @Column(name = "parent_id")
    private Integer parentId;

    @Column(unique = true)
    private String slug;
}
