import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widget/product_detail_carousel.dart';
import '../widget/size_selector.dart';
import '../widget/color_selector.dart';
import '../provider/cart_provider.dart';
import '../../domain/entity/cart_item.dart';
import 'package:uuid/uuid.dart';

class ProductDetailView extends ConsumerStatefulWidget {
  final String productName;
  final String productPrice;

  const ProductDetailView({
    super.key,
    required this.productName,
    required this.productPrice,
  });

  @override
  ConsumerState<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends ConsumerState<ProductDetailView> {
  String? _selectedSize;
  String? _selectedColor;
  bool _isFavorite = false;

  final List<String> sizes = ['XS', 'S', 'M', 'L', 'XL'];
  final List<Color> colors = [
    const Color(0xFF1A1A2E),
    const Color(0xFF757575),
    const Color(0xFFE0E0E0),
    const Color(0xFFC9C9C9),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Image area with overlaid buttons
          Stack(
            children: [
              const ProductDetailCarousel(),
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
                        const Text(
                          'The perfect t-shirt for when you want to feel comfortable but still stylish. Amazing for all occasions. Made of 100% cotton fabric in four colours. Its modern style gives a lighter look for the day. Perfect for the warmest days.',
                          style: TextStyle(
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
                                      color.value.toString() == _selectedColor,
                                )
                              : -1,
                          onColorSelected: (index) => setState(
                            () =>
                                _selectedColor = colors[index].value.toString(),
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
                    final colorNames = [
                      'Black',
                      'Grey',
                      'Light Grey',
                      'Light Grey',
                    ];

                    final item = CartItem(
                      id: const Uuid().v4(),
                      name: widget.productName,
                      colorName:
                          colorNames[colors.indexWhere(
                            (c) => c.value.toString() == _selectedColor,
                          )],
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
