package com.refillio.modules.inventory.adapter.out;

import com.refillio.modules.inventory.domain.ConsumptionLog;
import com.refillio.modules.inventory.domain.ConsumptionLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class JpaConsumptionLogRepositoryAdapter implements ConsumptionLogRepository {

    private final SpringDataConsumptionLogRepository repository;

    @Override
    public ConsumptionLog save(ConsumptionLog log) {
        return toDomain(repository.save(toEntity(log)));
    }

    @Override
    public List<ConsumptionLog> findByInventoryItemId(UUID inventoryItemId) {
        return repository.findByInventoryItemId(inventoryItemId).stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    private ConsumptionLog toDomain(JpaConsumptionLog entity) {
        return new ConsumptionLog(
            entity.getId(),
            entity.getInventoryItemId(),
            entity.getQtyConsumed(),
            entity.getEventType(),
            entity.getOccurredAt()
        );
    }

    private JpaConsumptionLog toEntity(ConsumptionLog domain) {
        JpaConsumptionLog entity = new JpaConsumptionLog();
        if (domain.getId() != null) {
            entity.setId(domain.getId());
        }
        entity.setInventoryItemId(domain.getInventoryItemId());
        entity.setQtyConsumed(domain.getQtyConsumed());
        entity.setEventType(domain.getEventType());
        entity.setOccurredAt(domain.getOccurredAt());
        return entity;
    }
}
