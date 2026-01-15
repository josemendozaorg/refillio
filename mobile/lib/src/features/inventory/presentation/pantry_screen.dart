import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/inventory_repository.dart';

class PantryScreen extends ConsumerWidget {
  const PantryScreen({super.key});

  final String demoUserId = "3fa85f64-5717-4562-b3fc-2c963f66afa6"; // Use UUID compatible with backend

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pantryAsync = ref.watch(pantryItemsProvider(demoUserId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pantry'),
      ),
      body: pantryAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text('Your pantry is empty.', style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.only(top: 8, bottom: 80),
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(item.product?.name ?? 'Unknown Product',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                          '${item.currentQty} ${item.product?.unitSymbol ?? ''} • Par: ${item.reorderPoint}'),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          tooltip: 'Consumed 1',
                          onPressed: () async {
                            await ref
                                .read(inventoryRepositoryProvider)
                                .logConsumption(item.id, 1.0, 'opened');
                            // Refresh list
                            ref.invalidate(pantryItemsProvider(demoUserId));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          tooltip: 'I am out!',
                          onPressed: () async {
                            // Confirm dialog? For speed, direct action first or simple snackbar undo (not implemented yet)
                             await ref
                                .read(inventoryRepositoryProvider)
                                .logConsumption(item.id, 0, 'exhausted');
                             ref.invalidate(pantryItemsProvider(demoUserId));
                             if (context.mounted) {
                               ScaffoldMessenger.of(context).showSnackBar(
                                 const SnackBar(content: Text('Marked as exhausted. Added to shopping list.')),
                               );
                             }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/inventory/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
    );
  }
}
