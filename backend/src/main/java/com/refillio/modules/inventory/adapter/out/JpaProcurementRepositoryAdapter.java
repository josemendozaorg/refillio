package com.refillio.modules.inventory.adapter.out;

import com.refillio.modules.inventory.domain.ProcurementOrder;
import com.refillio.modules.inventory.domain.ProcurementOrderItem;
import com.refillio.modules.inventory.domain.ProcurementRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class JpaProcurementRepositoryAdapter implements ProcurementRepository {

    private final SpringDataProcurementRepository orderRepository;
    private final SpringDataProcurementItemRepository itemRepository;

    @Override
    public ProcurementOrder saveOrder(ProcurementOrder order) {
        return toDomain(orderRepository.save(toEntity(order)));
    }

    @Override
    public Optional<ProcurementOrder> findDraftOrderByUserId(UUID userId) {
        return orderRepository.findByUserIdAndStatus(userId, "draft")
                .map(this::toDomain);
    }

    @Override
    public ProcurementOrderItem saveOrderItem(ProcurementOrderItem item) {
        return toDomain(itemRepository.save(toEntity(item)));
    }

    @Override
    public List<ProcurementOrderItem> findItemsByOrderId(UUID orderId) {
        return itemRepository.findByOrderId(orderId).stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public Optional<ProcurementOrderItem> findItemByOrderAndProduct(UUID orderId, UUID canonicalProductId) {
        return itemRepository.findByOrderIdAndCanonicalProductId(orderId, canonicalProductId)
                .map(this::toDomain);
    }

    // Mappers (Order)
    private ProcurementOrder toDomain(JpaProcurementOrder entity) {
        return new ProcurementOrder(
            entity.getId(),
            entity.getUserId(),
            entity.getStatus(),
            entity.getTotalAmount(),
            entity.getEstimatedSavings(),
            entity.getCreatedAt()
        );
    }

    private JpaProcurementOrder toEntity(ProcurementOrder domain) {
        JpaProcurementOrder entity = new JpaProcurementOrder();
        entity.setId(domain.getId());
        entity.setUserId(domain.getUserId());
        entity.setStatus(domain.getStatus());
        entity.setTotalAmount(domain.getTotalAmount());
        entity.setEstimatedSavings(domain.getEstimatedSavings());
        entity.setCreatedAt(domain.getCreatedAt());
        return entity;
    }

    // Mappers (Item)
    private ProcurementOrderItem toDomain(JpaProcurementOrderItem entity) {
        return new ProcurementOrderItem(
            entity.getId(),
            entity.getOrderId(),
            entity.getListingId(),
            entity.getCanonicalProductId(),
            entity.getQuantity(),
            entity.getPriceAtPurchase(),
            entity.getReferenceMarketPrice()
        );
    }

    private JpaProcurementOrderItem toEntity(ProcurementOrderItem domain) {
        JpaProcurementOrderItem entity = new JpaProcurementOrderItem();
        entity.setId(domain.getId());
        entity.setOrderId(domain.getOrderId());
        entity.setListingId(domain.getListingId());
        entity.setCanonicalProductId(domain.getCanonicalProductId());
        entity.setQuantity(domain.getQuantity());
        entity.setPriceAtPurchase(domain.getPriceAtPurchase());
        entity.setReferenceMarketPrice(domain.getReferenceMarketPrice());
        return entity;
    }
}
