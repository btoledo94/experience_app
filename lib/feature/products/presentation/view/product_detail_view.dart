import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:xpiria_app/feature/auth/domain/entity/app_role.dart';
import 'package:xpiria_app/feature/auth/presentation/state/auth_provider.dart';
import '../widget/product_detail_carousel.dart';
import '../widget/size_selector.dart';
import '../widget/color_selector.dart';
import '../utils/product_color_resolver.dart';
import 'package:xpiria_app/feature/cart/presentation/state/cart_provider.dart';
import 'package:xpiria_app/feature/cart/domain/entity/cart_item.dart';
import 'package:uuid/uuid.dart';

class ProductDetailView extends ConsumerStatefulWidget {
  final String productName;
  final String productPrice;
  final String productDescription;
  final String productImageUrl;
  final List<String> productColors;
  final List<String> productSizes;

  const ProductDetailView({
    super.key,
    required this.productName,
    required this.productPrice,
    this.productDescription = '',
    this.productImageUrl = '',
    this.productColors = const [],
    this.productSizes = const [],
  });

  @override
  ConsumerState<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends ConsumerState<ProductDetailView> {
  String? _selectedSize;
  String? _selectedColor;
  bool _isFavorite = false;

  List<String> get sizes => widget.productSizes.isNotEmpty
      ? widget.productSizes
      : ['S', 'M', 'L', 'XL'];

  List<String> get colorNames => widget.productColors.isNotEmpty
      ? widget.productColors
      : ['Black', 'Grey', 'White'];

  List<Color> get colors => productColorsFromNames(colorNames);

  @override
  Widget build(BuildContext context) {
    final canBuy =
        ref.watch(currentUserProfileProvider).valueOrNull?.role.canBuy ??
        false;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Image area with overlaid buttons
          Stack(
            children: [
              ProductDetailCarousel(imageUrl: widget.productImageUrl),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Product info
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product name and favorite
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.productName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                _isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                                size: 24,
                                color: _isFavorite ? Colors.red : Colors.black,
                              ),
                              onPressed: () =>
                                  setState(() => _isFavorite = !_isFavorite),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.productPrice,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Description
                        Text(
                          widget.productDescription.isNotEmpty
                              ? widget.productDescription
                              : 'Sin descripción disponible.',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF9E9E9E),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Size selector
                        const Text(
                          'Size',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizeSelector(
                          sizes: sizes,
                          selectedSize: _selectedSize,
                          onSizeSelected: (size) =>
                              setState(() => _selectedSize = size),
                        ),
                        const SizedBox(height: 20),

                        // Color selector
                        const Text(
                          'Color',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ColorSelector(
                          colors: colors,
                          selectedColorIndex: _selectedColor != null
                              ? colors.indexWhere(
                                  (color) =>
                                      color.toARGB32().toString() == _selectedColor,
                                )
                              : -1,
                          onColorSelected: (index) => setState(
                            () =>
                                _selectedColor = colors[index].toARGB32().toString(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Add to bag button
          if (canBuy)
            SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_selectedSize == null || _selectedColor == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select size and color'),
                        ),
                      );
                      return;
                    }

                    final cartNotifier = ref.read(cartProvider.notifier);
                    final selectedColorIndex = colors.indexWhere(
                      (c) => c.toARGB32().toString() == _selectedColor,
                    );

                    final item = CartItem(
                      id: const Uuid().v4(),
                      name: widget.productName,
                      colorName:
                          selectedColorIndex >= 0 &&
                              selectedColorIndex < colorNames.length
                          ? colorNames[selectedColorIndex]
                          : 'Default',
                      size: _selectedSize!,
                      price: double.parse(
                        widget.productPrice
                            .replaceAll('€ ', '')
                            .replaceAll(',', '.'),
                      ),
                    );

                    cartNotifier.addItem(item);

                    // Navigate to cart after adding
                    context.go('/cart');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add to bag'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2962FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
