import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widget/ecommerce_app_bar.dart';
import '../widget/product_carousel.dart';
import '../widget/product_section.dart';

class EcommerceView extends ConsumerStatefulWidget {
  const EcommerceView({super.key});

  @override
  ConsumerState<EcommerceView> createState() => _EcommerceViewState();
}

class _EcommerceViewState extends ConsumerState<EcommerceView> {
  int _selectedNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const EcommerceAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Product Carousel
              const ProductCarousel(),
              const SizedBox(height: 24),

              // Perfect for you section
              ProductSection(
                title: 'Perfect for you',
                products: [
                  const ProductData(name: 'Amazing T-Shirt', price: '€ 12.00'),
                  const ProductData(name: 'Fabulous Pants', price: '€ 15.00'),
                ],
              ),
              const SizedBox(height: 24),

              // For this summer section
              ProductSection(
                title: 'For this summer',
                products: [
                  const ProductData(name: 'Summer Shirt', price: '€ 18.00'),
                  const ProductData(name: 'Beach Shorts', price: '€ 20.00'),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) => setState(() => _selectedNavIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Categories',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Stores'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
