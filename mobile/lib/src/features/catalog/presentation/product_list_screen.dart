import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../domain/catalog_model.dart';
import '../../data/catalog_repository.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(allProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Products', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: productsAsync.when(
        data: (products) => _buildList(context, products),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/products/add'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Product'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ).animate().scale(delay: 500.ms, curve: Curves.easeOutBack),
    );
  }

  Widget _buildList(BuildContext context, List<CanonicalProduct> products) {
    if (products.isEmpty) return _buildEmptyState(context);
    return ListView.builder(
      itemCount: products.length,
      padding: const EdgeInsets.all(20),
      itemBuilder: (context, index) {
        final product = products[index];
        return _ProductListTile(product: product, onTap: () => context.push('/products/${product.id}'));
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.white10),
          const SizedBox(height: 20),
          Text('No products available', style: GoogleFonts.outfit(fontSize: 20, color: Colors.white60)),
        ],
      ),
    );
  }
}

class _ProductListTile extends StatelessWidget {
  final CanonicalProduct product;
  final VoidCallback onTap;

  const _ProductListTile({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text(product.description ?? ''),
      trailing: Chip(label: Text(product.baseUnit?.symbol ?? '')),
      onTap: onTap,
    );
  }
}
