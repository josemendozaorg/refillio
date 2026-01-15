import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../catalog/data/catalog_repository.dart';
import '../data/inventory_repository.dart';
import '../domain/inventory_model.dart';
import '../../catalog/domain/catalog_model.dart';

class AddItemScreen extends ConsumerWidget {
  const AddItemScreen({super.key});

  final String demoUserId = "3fa85f64-5717-4562-b3fc-2c963f66afa6";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(allProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add to Pantry'),
      ),
      body: productsAsync.when(
        data: (products) {
          return ListView.separated(
            itemCount: products.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                subtitle: Text(product.description ?? ''),
                trailing: const Icon(Icons.add_circle, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                onTap: () => _showAddDialog(context, ref, product),
              ).animate().fade().slideX(begin: 0.1, end: 0, delay: (30 * index).ms);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref, CanonicalProduct product) {
    final qtyController = TextEditingController(text: '1');
    final parController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add ${product.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            ShadInput(
              controller: qtyController,
              placeholder: const Text('Current Quantity'),
              keyboardType: TextInputType.number,
              autofocus: true,
            ),
            const SizedBox(height: 16),
            ShadInput(
              controller: parController,
              placeholder: const Text('Reorder Point (Par Level)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          ShadButton.ghost(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ShadButton(
            onPressed: () async {
              try {
                final qty = double.tryParse(qtyController.text) ?? 1.0;
                final par = double.tryParse(parController.text) ?? 1.0;
                
                final req = AddToPantryRequest(
                  productId: product.id,
                  quantity: qty,
                  reorderPoint: par,
                );
                
                await ref.read(inventoryRepositoryProvider).addToPantry(demoUserId, req);
                
                if (context.mounted) {
                  Navigator.pop(context); // Close dialog
                  context.pop(); // Go back to pantry
                  // Invalidate pantry list
                   ref.invalidate(pantryItemsProvider(demoUserId));
                }
              } catch (e) {
                // Show error
              }
            },
            child: const Text('Add Item'),
          ),
        ],
      ),
    );
  }
}
