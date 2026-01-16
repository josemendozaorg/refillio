package com.refillio.modules.inventory.adapter.out;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.math.BigDecimal;
import java.util.UUID;

@Entity
@Table(name = "procurement_order_items")
@Getter
@Setter
public class JpaProcurementOrderItem {
    @Id
    @GeneratedValue
    private UUID id;

    @Column(name = "order_id")
    private UUID orderId;

    @Column(name = "listing_id")
    private UUID listingId;

    @Column(name = "canonical_product_id")
    private UUID canonicalProductId;

    private Integer quantity;

    @Column(name = "price_at_purchase")
    private BigDecimal priceAtPurchase;

    @Column(name = "reference_market_price")
    private BigDecimal referenceMarketPrice;
}
