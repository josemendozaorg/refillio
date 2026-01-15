package com.refillio.modules.inventory.adapter.out;

import com.refillio.modules.inventory.domain.InventoryItem;
import com.refillio.modules.inventory.domain.InventoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class JpaInventoryRepositoryAdapter implements InventoryRepository {
    
    private final SpringDataInventoryRepository repository;

    @Override
    public List<InventoryItem> findAllByUserId(UUID userId) {
        return repository.findByUserId(userId).stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public Optional<InventoryItem> findByUserIdAndProductId(UUID userId, UUID productId) {
        return repository.findByUserIdAndCanonicalProductId(userId, productId)
                .map(this::toDomain);
    }

    @Override
    public Optional<InventoryItem> findById(UUID id) {
        return repository.findById(id)
                .map(this::toDomain);
    }

    @Override
    public InventoryItem save(InventoryItem item) {
        return toDomain(repository.save(toEntity(item)));
    }
    
    private InventoryItem toDomain(JpaInventoryItem entity) {
        return new InventoryItem(
            entity.getId(),
            entity.getUserId(),
            entity.getCanonicalProductId(),
            entity.getCurrentQty(),
            entity.getReorderPoint(),
            entity.getAutoReorder(),
            entity.getUpdatedAt()
        );
    }
    
    private JpaInventoryItem toEntity(InventoryItem domain) {
        JpaInventoryItem entity = new JpaInventoryItem();
        entity.setId(domain.getId());
        entity.setUserId(domain.getUserId());
        entity.setCanonicalProductId(domain.getCanonicalProductId());
        entity.setCurrentQty(domain.getCurrentQty());
        entity.setReorderPoint(domain.getReorderPoint());
        entity.setAutoReorder(domain.getAutoReorder());
        entity.setUpdatedAt(domain.getUpdatedAt());
        return entity;
    }
}
