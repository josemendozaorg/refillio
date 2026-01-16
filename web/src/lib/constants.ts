import type { InventoryItem } from '../types';

export const demoUserId = "3fa85f64-5717-4562-b3fc-2c963f66afa6";

export const filterPantryItems = (items: InventoryItem[], filter: string): InventoryItem[] => {
  if (filter === 'All') return items;
  if (filter === 'Low Stock') {
    return items.filter((i) => i.currentQty <= i.reorderPoint);
  }
  return items;
};

export const getLowStockItems = (items: InventoryItem[]): InventoryItem[] => {
  return items.filter((item) => item.currentQty <= item.reorderPoint);
};
