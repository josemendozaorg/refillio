package com.refillio.modules.inventory.adapter.out;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface SpringDataInventoryRepository extends JpaRepository<JpaInventoryItem, UUID> {
    List<JpaInventoryItem> findByUserId(UUID userId);
    Optional<JpaInventoryItem> findByUserIdAndCanonicalProductId(UUID userId, UUID canonicalProductId);
}
