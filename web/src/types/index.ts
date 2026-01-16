export interface ProductSummary {
  id: string;
  name: string;
  unitSymbol: string;
}

export interface InventoryItem {
  id: string;
  userId: string;
  product?: ProductSummary;
  currentQty: number;
  reorderPoint: number;
}

export interface AddToPantryRequest {
  productId: string;
  quantity: number;
  reorderPoint: number;
}

export interface Category {
  id: number;
  name: string;
  parentId?: number;
  slug?: string;
}

export interface MeasurementUnit {
  id: number;
  symbol: string;
  type: string;
}

export interface CanonicalProduct {
  id: string;
  name: string;
  description?: string;
  category?: Category;
  baseUnit?: MeasurementUnit;
}
