import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ShadCard(
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
                        ShadButton.outline(
                          width: 40,
                          height: 40,
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            try {
                              await ref
                                  .read(inventoryRepositoryProvider)
                                  .logConsumption(item.id, 1.0, 'opened');
                              // Refresh list
                              ref.invalidate(pantryItemsProvider(demoUserId));
                              if (context.mounted) {
                                ShadToaster.of(context).show(
                                  const ShadToast(
                                    title: Text('Consumed 1 unit.'),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ShadToaster.of(context).show(
                                   ShadToast.destructive(
                                    title: Text('Error: $e'),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Icon(Icons.remove_circle_outline, size: 18),
                        ),
                        const SizedBox(width: 8),
                         ShadButton.ghost(
                            width: 40,
                            height: 40,
                            padding: EdgeInsets.zero,
                            onPressed: () async {
                              try {
                                await ref
                                    .read(inventoryRepositoryProvider)
                                    .logConsumption(item.id, 0, 'exhausted');
                                ref.invalidate(pantryItemsProvider(demoUserId));
                                if (context.mounted) {
                                  ShadToaster.of(context).show(
                                    const ShadToast(
                                        title: Text(
                                            'Marked as exhausted. Added to shopping list.')),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                   ShadToaster.of(context).show(
                                    ShadToast.destructive(
                                     title: Text('Error: $e'),
                                   ),
                                 );
                                }
                              }
                            },
                            child: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                         ),
                      ],
                    ),
                  ),
                ),
              ).animate().fade().slideY(begin: 0.1, end: 0, duration: 400.ms, delay: (50 * index).ms);
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
