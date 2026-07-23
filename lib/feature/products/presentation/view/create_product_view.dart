import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../state/product_provider.dart';

class CreateProductView extends ConsumerStatefulWidget {
  const CreateProductView({super.key});

  @override
  ConsumerState<CreateProductView> createState() => _CreateProductViewState();
}

class _CreateProductViewState extends ConsumerState<CreateProductView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _colorsController = TextEditingController();
  final _sizesController = TextEditingController();
  final _imagePicker = ImagePicker();

  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  bool _isUploadingImage = false;

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
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _colorsController.dispose();
    _sizesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1800,
    );

    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    if (!mounted) return;

    setState(() {
      _selectedImageBytes = bytes;
      _selectedImageName = picked.name;
    });
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

    var finalImageUrl = _imageUrlController.text.trim();
    if (_selectedImageBytes != null && _selectedImageName != null) {
      setState(() => _isUploadingImage = true);
      try {
        finalImageUrl = await ref
            .read(productsProvider.notifier)
            .uploadProductImage(
              bytes: _selectedImageBytes!,
              fileName: _selectedImageName!,
            );
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo subir la imagen a Firebase Storage.'),
          ),
        );
        setState(() => _isUploadingImage = false);
        return;
      }

      if (!mounted) return;
      setState(() => _isUploadingImage = false);
    }

    await ref
        .read(productsProvider.notifier)
        .addProduct(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          price: price,
          imageUrl: finalImageUrl,
          colors: colors,
          sizes: sizes,
        );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto creado en Firebase.')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(productsProvider).isLoading;
    final isBusy = isLoading || _isUploadingImage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear producto'),
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
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: isBusy ? null : _pickImage,
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  label: const Text('Seleccionar imagen desde galeria'),
                ),
              ),
              if (_selectedImageName != null) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Archivo: $_selectedImageName',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _imageUrlController,
                builder: (context, value, _) {
                  final imageUrl = value.text.trim();
                  final hasNetworkImage = imageUrl.startsWith('http');
                  final hasSelectedImage = _selectedImageBytes != null;

                  if (!hasNetworkImage && !hasSelectedImage) {
                    return const SizedBox.shrink();
                  }

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: double.infinity,
                      height: 180,
                      child: hasSelectedImage
                          ? Image.memory(
                              _selectedImageBytes!,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Text(
                                    'No se pudo cargar la imagen URL',
                                  ),
                                );
                              },
                            ),
                    ),
                  );
                },
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
                  onPressed: isBusy ? null : _submit,
                  child: isBusy
                      ? const CircularProgressIndicator()
                      : const Text('Guardar producto'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
