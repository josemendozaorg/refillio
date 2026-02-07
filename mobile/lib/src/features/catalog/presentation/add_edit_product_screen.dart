import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../domain/catalog_model.dart';
import '../../data/product_controller.dart';
import '../domain/product_dto.dart';

class AddEditProductScreen extends ConsumerStatefulWidget {
  final String? productId;
  const AddEditProductScreen({super.key, this.productId});

  @override
  ConsumerState<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends ConsumerState<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  int? _selectedCategoryId;
  int? _selectedUnitId;
  CanonicalProduct? _product;

  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      _loadProduct();
    }
  }

  Future<void> _loadProduct() async {
    final repo = ref.read(productControllerProvider);
    _product = await repo.fetchProducts().then((list) => list.firstWhere((p) => p.id == widget.productId));
    if (_product != null) {
      _nameController.text = _product!.name;
      _descriptionController.text = _product!.description ?? '';
      _selectedCategoryId = _product!.category?.id;
      _selectedUnitId = _product!.baseUnit?.id;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productId == null ? 'Add Product' : 'Edit Product', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v?.isEmpty ?? true ? 'Name required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 20),
              // TODO: add category and unit dropdowns here
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _save,
                child: Text(widget.productId == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = ref.read(productControllerProvider);
    if (widget.productId == null) {
      await repo.createProduct(CreateProductDto(
        name: _nameController.text,
        categoryId: _selectedCategoryId!,
        baseUnitId: _selectedUnitId!,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      ));
    } else {
      await repo.updateProduct(widget.productId!, UpdateProductDto(
        id: widget.productId!,
        name: _nameController.text,
        categoryId: _selectedCategoryId,
        baseUnitId: _selectedUnitId,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      ));
    }
    ShadToaster.of(context).show(const ShadToast(title: Text('Success')));
    context.pop();
  }
}
