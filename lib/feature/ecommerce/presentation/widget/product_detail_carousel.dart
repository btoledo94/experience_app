import 'package:flutter/material.dart';

class ProductDetailCarousel extends StatefulWidget {
  const ProductDetailCarousel({super.key});

  @override
  State<ProductDetailCarousel> createState() => _ProductDetailCarouselState();
}

class _ProductDetailCarouselState extends State<ProductDetailCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Carousel
        SizedBox(
          height: 340,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: 4,
            itemBuilder: (context, index) => Container(
              color: const Color(0xFFEAF0FB),
              child: const Center(
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
          children: List.generate(4, (index) {
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
