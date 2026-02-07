package com.refillio.modules.catalog.adapter.out;

public interface SpringDataCanonicalProductRepository extends JpaRepository<JpaCanonicalProduct, UUID> {
    JpaCanonicalProduct findByName(String name);
}
