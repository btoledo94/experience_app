import 'package:flutter/material.dart';

class ProductDetailCarousel extends StatefulWidget {
  final String imageUrl;

  const ProductDetailCarousel({super.key, this.imageUrl = ''});

  @override
  State<ProductDetailCarousel> createState() => _ProductDetailCarouselState();
}

class _ProductDetailCarouselState extends State<ProductDetailCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  static const _imageRequestHeaders = {
    'User-Agent':
        'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0 Mobile Safari/537.36',
    'Referer': 'https://www.somosmamas.com.ar/',
  };

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = _isValidNetworkImageUrl(widget.imageUrl);
    final itemCount = hasImage ? 1 : 4;

    return Column(
      children: [
        // Carousel
        SizedBox(
          height: 340,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: itemCount,
            itemBuilder: (context, index) => Container(
              color: const Color(0xFFEAF0FB),
              child: hasImage
                  ? Image.network(
                      widget.imageUrl,
                      headers: _imageRequestHeaders,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 100,
                          color: Color(0xFFB0BEC5),
                        ),
                      ),
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 100,
                        color: Color(0xFFB0BEC5),
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(itemCount, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index == _currentPage
                      ? const Color(0xFF2962FF)
                      : const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
      ],
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
