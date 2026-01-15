import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../data/inventory_repository.dart';
import '../domain/inventory_model.dart';

class PantryScreen extends ConsumerStatefulWidget {
  const PantryScreen({super.key});

  @override
  ConsumerState<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends ConsumerState<PantryScreen> {
  final String demoUserId = "3fa85f64-5717-4562-b3fc-2c963f66afa6";
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final pantryAsync = ref.watch(pantryItemsProvider(demoUserId));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('My Pantry', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: pantryAsync.when(
            data: (items) {
              final filteredItems = _filterItems(items);
              
              return Column(
                children: [
                  _buildFilterChips(),
                  Expanded(
                    child: filteredItems.isEmpty
                        ? _buildEmptyState(context)
                        : ListView.builder(
                            itemCount: filteredItems.length,
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              return _PantryItemCard(
                                item: item,
                                index: index,
                                onConsume: () => _consumeItem(item),
                                onExhaust: () => _exhaustItem(item),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/inventory/add'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Item'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ).animate().scale(delay: 500.ms, curve: Curves.backOut),
    );
  }

  List<InventoryItem> _filterItems(List<InventoryItem> items) {
    if (selectedFilter == 'All') return items;
    if (selectedFilter == 'Low Stock') {
      return items.where((i) => i.currentQty <= i.reorderPoint).toList();
    }
    // Add more category filters as needed
    return items;
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: ['All', 'Low Stock', 'Produce', 'Dairy', 'Pantry'].map((filter) {
          final isSelected = selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (val) => setState(() => selectedFilter = filter),
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
              checkmarkColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white60,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              side: BorderSide(
                color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white10,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.white10),
          const SizedBox(height: 20),
          Text(
            'Your pantry is empty',
            style: GoogleFonts.outfit(fontSize: 20, color: Colors.white60),
          ),
        ],
      ),
    );
  }

  Future<void> _consumeItem(InventoryItem item) async {
    try {
      await ref.read(inventoryRepositoryProvider).logConsumption(item.id, 1.0, 'manual_reduction');
      ref.invalidate(pantryItemsProvider(demoUserId));
      if (mounted) {
        ShadToaster.of(context).show(const ShadToast(title: Text('Consumed 1 unit.')));
      }
    } catch (e) {
      if (mounted) {
        ShadToaster.of(context).show(ShadToast.destructive(title: Text('Error: $e')));
      }
    }
  }

  Future<void> _exhaustItem(InventoryItem item) async {
    try {
      await ref.read(inventoryRepositoryProvider).logConsumption(item.id, 0, 'exhausted');
      ref.invalidate(pantryItemsProvider(demoUserId));
      if (mounted) {
        ShadToaster.of(context).show(const ShadToast(title: Text('Item marked as exhausted.')));
      }
    } catch (e) {
      if (mounted) {
        ShadToaster.of(context).show(ShadToast.destructive(title: Text('Error: $e')));
      }
    }
  }
}

class _PantryItemCard extends StatelessWidget {
  final InventoryItem item;
  final int index;
  final VoidCallback onConsume;
  final VoidCallback onExhaust;

  const _PantryItemCard({
    required this.item,
    required this.index,
    required this.onConsume,
    required this.onExhaust,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = (item.currentQty / (item.reorderPoint * 2)).clamp(0, 1);
    final isLow = item.currentQty <= item.reorderPoint;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: (isLow ? Colors.orange : Colors.emerald).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isLow ? Icons.warning_amber_rounded : Icons.inventory_2_outlined,
                    color: isLow ? Colors.orange : Colors.emerald,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product?.name ?? 'Unknown',
                        style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${item.currentQty} ${item.product?.unitSymbol ?? ''} left',
                        style: TextStyle(color: Colors.white60, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline_rounded, color: Colors.white60),
                      onPressed: onConsume,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline_rounded, color: Colors.red.withValues(alpha: 0.6)),
                      onPressed: onExhaust,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: Colors.white.withValues(alpha: 0.05),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isLow ? Colors.orange : Colors.emerald,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fade(delay: (index * 50).ms).slideX(begin: 0.1, end: 0, curve: Curves.easeOut);
  }
}
