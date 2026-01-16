import axios from 'axios';
import type { InventoryItem, AddToPantryRequest, CanonicalProduct } from '../types';

// Create axios instance
const api = axios.create({
  baseURL: '/api/v1/', // Matches the Flutter Dio configuration
  timeout: 5000,
});

// Inventory API
export const getPantry = async (userId: string): Promise<InventoryItem[]> => {
  const response = await api.get<InventoryItem[]>('inventory', { params: { userId } });
  return response.data;
};

export const addToPantry = async (userId: string, request: AddToPantryRequest): Promise<InventoryItem> => {
  const response = await api.post<InventoryItem>('inventory', request, { params: { userId } });
  return response.data;
};

export const logConsumption = async (inventoryItemId: string, amount: number, eventType: string): Promise<void> => {
  await api.post(`inventory/${inventoryItemId}/consumption`, {
    amount,
    eventType,
  });
};

// Catalog API
export const getProducts = async (): Promise<CanonicalProduct[]> => {
  const response = await api.get<CanonicalProduct[]>('catalog/products');
  return response.data;
};

export default api;
