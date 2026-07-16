import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:xpiria_app/feature/products/domain/entity/product.dart';
import '../state/product_provider.dart';

class EditProductView extends ConsumerStatefulWidget {
  final Product product;

  const EditProductView({super.key, required this.product});

  @override
  ConsumerState<EditProductView> createState() => _EditProductViewState();
}

class _EditProductViewState extends ConsumerState<EditProductView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _colorsController;
  late final TextEditingController _sizesController;

  String? _validateOptionalImageUrl(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return null;

    final uri = Uri.tryParse(input);
    final isValid =
        uri != null &&
        uri.isAbsolute &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;

    if (!isValid) {
      return 'Ingresa una URL valida (http/https).';
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _descriptionController = TextEditingController(
      text: widget.product.description,
    );
    _priceController = TextEditingController(
      text: widget.product.price.toStringAsFixed(2),
    );
    _imageUrlController = TextEditingController(text: widget.product.imageUrl);
    _colorsController = TextEditingController(
      text: widget.product.colors.join(', '),
    );
    _sizesController = TextEditingController(
      text: widget.product.sizes.join(', '),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _colorsController.dispose();
    _sizesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final price = double.tryParse(
      _priceController.text.trim().replaceAll(',', '.'),
    );
    if (price == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Precio invalido.')));
      return;
    }

    final colors = _colorsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final sizes = _sizesController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    await ref
        .read(productsProvider.notifier)
        .updateProduct(
          id: widget.product.id,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          price: price,
          imageUrl: _imageUrlController.text.trim(),
          colors: colors,
          sizes: sizes,
        );

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Producto actualizado.')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(productsProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar producto'),
        actions: [
          IconButton(
            onPressed: () => context.go('/products'),
            icon: const Icon(Icons.inventory_2_outlined),
            tooltip: 'Volver a productos',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Ingresa el nombre'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Descripcion'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Ingresa la descripcion'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Precio (ej: 12.99)',
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Ingresa el precio'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL (opcional)',
                ),
                validator: _validateOptionalImageUrl,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _colorsController,
                decoration: const InputDecoration(
                  labelText: 'Colores separados por coma (ej: negro, blue)',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _sizesController,
                decoration: const InputDecoration(
                  labelText: 'Tallas separadas por coma (ej: S, M, L)',
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Guardar cambios'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
