import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String description;
  final String imageUrl;
  final List<String> colors;
  final List<String> sizes;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    this.description = '',
    this.imageUrl = '',
    this.colors = const [],
    this.sizes = const [],
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        'productDetail',
        extra: {
          'name': name,
          'price': price,
          'description': description,
          'imageUrl': imageUrl,
          'colors': colors,
          'sizes': sizes,
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image placeholder
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF0FB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _ProductNetworkImage(imageUrl: imageUrl),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Product name
          Text(
            name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A2E),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // Product price
          Text(
            price,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductNetworkImage extends StatelessWidget {
  final String imageUrl;
  static const _imageRequestHeaders = {
    'User-Agent':
        'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0 Mobile Safari/537.36',
    'Referer': 'https://www.somosmamas.com.ar/',
  };

  const _ProductNetworkImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (!_isValidNetworkImageUrl(imageUrl)) {
      return const Center(
        child: Icon(Icons.image_outlined, size: 48, color: Color(0xFFB0BEC5)),
      );
    }

    return Image.network(
      imageUrl,
      headers: _imageRequestHeaders,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: 48,
          color: Color(0xFFB0BEC5),
        ),
      ),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }
}

bool _isValidNetworkImageUrl(String value) {
  final uri = Uri.tryParse(value.trim());
  return uri != null &&
      uri.isAbsolute &&
      (uri.scheme == 'http' || uri.scheme == 'https') &&
      uri.host.isNotEmpty;
}
