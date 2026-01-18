import 'package:flutter/material.dart';
import 'package:refillio/src/shared/theme.dart'; // Assuming access to the theme

/// MOCKUP: Product Administration Feature
/// 
/// This file contains the UI widgets for the "Manage Products" flow.
/// It is designed to be integrated into the main app.

class ProductAdminMockupApp extends StatelessWidget {
  const ProductAdminMockupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, // using the existing dark theme
      home: const ProductListScreen(),
    );
  }
}

// -----------------------------------------------------------------------------
// SCREEN 1: Product List
// -----------------------------------------------------------------------------

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Catalog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _mockProducts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final product = _mockProducts[index];
          return ProductListTile(product: product);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const EditProductScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProductListTile extends StatelessWidget {
  final MockProduct product;

  const ProductListTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
             Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => EditProductScreen(product: product)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Icon Placeholder
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  product.icon,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.categoryPath,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              // Trailing Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  product.unit,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SCREEN 2: Add/Edit Product
// -----------------------------------------------------------------------------

class EditProductScreen extends StatefulWidget {
  final MockProduct? product;

  const EditProductScreen({super.key, this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  String? _selectedCategory;
  String? _selectedUnit;

  bool get isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name);
    _descController = TextEditingController(text: "Detailed product specifications would go here."); // Placeholder
    _selectedCategory = widget.product?.categoryPath.split(' > ').last; // Simplification
    _selectedUnit = widget.product?.unit;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'New Product'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Name Input
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                hintText: 'e.g. Toilet Paper 3-ply',
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter a name' : null,
            ),
            const SizedBox(height: 24),

            // Description Input
            TextFormField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Optional details...',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),

            // Category Dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: ['Hygiene', 'Cleaning', 'Power', 'Food']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCategory = val),
            ),
            const SizedBox(height: 24),

             // Unit Dropdown
            DropdownButtonFormField<String>(
              value: _selectedUnit,
              decoration: const InputDecoration(
                labelText: 'Base Unit',
                 prefixIcon: Icon(Icons.straighten_outlined),
              ),
              items: ['roll', 'ml', 'pcs', 'kg']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedUnit = val),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Product'),
              ),
              if (isEditing) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                   child: const Text('Delete Product'),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// DATA MOCKS
// -----------------------------------------------------------------------------

class MockProduct {
  final String id;
  final String name;
  final String categoryPath;
  final String unit;
  final IconData icon;

  const MockProduct({
    required this.id,
    required this.name,
    required this.categoryPath,
    required this.unit,
    required this.icon,
  });
}

final _mockProducts = [
  const MockProduct(
    id: '1',
    name: 'Toilet Paper',
    categoryPath: 'Home > Hygiene',
    unit: 'roll',
    icon: Icons.local_activity_outlined, // Placeholder for TP
  ),
  const MockProduct(
    id: '2',
    name: 'Dish Soap',
    categoryPath: 'Kitchen > Cleaning',
    unit: 'ml',
    icon: Icons.cleaning_services_outlined,
  ),
  const MockProduct(
    id: '3',
    name: 'AA Batteries',
    categoryPath: 'Electronics > Power',
    unit: 'pcs',
    icon: Icons.battery_std,
  ),
];
