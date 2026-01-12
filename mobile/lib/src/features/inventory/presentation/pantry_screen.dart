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
            return const Center(child: Text('Your pantry is empty.'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.product?.name ?? 'Unknown Product'),
                subtitle: Text('${item.currentQty} ${item.product?.unitSymbol ?? ''} (Par: ${item.reorderPoint})'),
                trailing: IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    // Logic to increment (out of scope for MVP step 1 but could be added)
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/inventory/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
