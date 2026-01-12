package com.refillio.modules.catalog.adapter.out;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.UUID;

public interface SpringDataCanonicalProductRepository extends JpaRepository<JpaCanonicalProduct, UUID> {
}
