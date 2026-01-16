import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../catalog/data/catalog_repository.dart';
import '../data/inventory_repository.dart';
import '../domain/inventory_model.dart';
import '../../catalog/domain/catalog_model.dart';

class AddItemScreen extends ConsumerStatefulWidget {
  const AddItemScreen({super.key});

  @override
  ConsumerState<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  final String demoUserId = "3fa85f64-5717-4562-b3fc-2c963f66afa6";
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(allProductsProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Catalog', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
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
              Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.9),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: productsAsync.when(
            data: (products) {
              final filteredProducts = products
                  .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
                  .toList();

              return Column(
                children: [
                  _buildSearchBar(),
                  Expanded(
                    child: filteredProducts.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            itemCount: filteredProducts.length,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];
                              return _ProductCard(
                                product: product,
                                index: index,
                                onTap: () => _showAddDialog(context, product),
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
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: Icon(Icons.search_rounded, color: Colors.white38),
              suffixIcon: _searchQuery.isNotEmpty 
                ? IconButton(
                    icon: Icon(Icons.close_rounded, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Theme.of(context).primaryColor.withValues(alpha: 0.5)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: Colors.white10),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(color: Colors.white38, fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, CanonicalProduct product) {
    final qtyController = TextEditingController(text: '1');
    final parController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: AlertDialog(
          backgroundColor: Color(0xFF1A1D23),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text('Add ${product.name}', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DialogInput(
                  controller: qtyController,
                  label: 'Current Quantity',
                  unit: product.baseUnit?.symbol ?? '',
                ),
                const SizedBox(height: 16),
                _DialogInput(
                  controller: parController,
                  label: 'Reorder Point',
                  unit: product.baseUnit?.symbol ?? '',
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.white38)),
            ),
            ElevatedButton(
              onPressed: () async {
                final qty = double.tryParse(qtyController.text) ?? 1.0;
                final par = double.tryParse(parController.text) ?? 1.0;
                
                final req = AddToPantryRequest(
                  productId: product.id,
                  quantity: qty,
                  reorderPoint: par,
                );
                
                await ref.read(inventoryRepositoryProvider).addToPantry(demoUserId, req);
                
                if (context.mounted) {
                  Navigator.pop(context);
                  context.pop();
                  ref.invalidate(pantryItemsProvider(demoUserId));
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Add to Pantry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final CanonicalProduct product;
  final int index;
  final VoidCallback onTap;

  const _ProductCard({
    required this.product,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.shopping_bag_outlined, color: Colors.white38),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      if (product.description != null)
                        Text(
                          product.description!,
                          style: TextStyle(color: Colors.white38, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                Icon(Icons.add_circle_outline_rounded, color: Theme.of(context).primaryColor, size: 24),
              ],
            ),
          ),
        ),
      ),
    ).animate().fade(delay: (index * 30).ms).slideX(begin: 0.1, end: 0, curve: Curves.easeOut);
  }
}

class _DialogInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String unit;

  const _DialogInput({
    required this.controller,
    required this.label,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            suffixText: unit,
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
