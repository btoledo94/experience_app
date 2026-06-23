import 'package:flutter/material.dart';
import 'product_card.dart';

class ProductData {
  final String name;
  final String price;
  final String description;
  final List<String> colors;
  final List<String> sizes;

  const ProductData({
    required this.name,
    required this.price,
    this.description = '',
    this.colors = const [],
    this.sizes = const [],
  });
}

class ProductSection extends StatelessWidget {
  final String title;
  final List<ProductData> products;

  const ProductSection({
    super.key,
    required this.title,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with title and See more
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'See more',
                  style: TextStyle(
                    color: Color(0xFF2962FF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Horizontal list by section
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) => SizedBox(
              width: 160,
              child: ProductCard(
                name: products[index].name,
                price: products[index].price,
                description: products[index].description,
                colors: products[index].colors,
                sizes: products[index].sizes,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
