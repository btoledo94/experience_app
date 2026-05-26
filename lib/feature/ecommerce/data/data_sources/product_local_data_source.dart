import '../model/product_model.dart';

class ProductLocalDataSource {
  List<ProductModel> getDefaultProducts() {
    return const [
      ProductModel(
        id: '1',
        name: 'Amazing T-Shirt',
        description:
            'The perfect t-shirt for when you want to feel comfortable but still stylish.',
        price: 12.0,
        imageUrl: '',
        colors: ['Black', 'Grey', 'Light Grey', 'White'],
        sizes: ['XS', 'S', 'M', 'L', 'XL'],
      ),
      ProductModel(
        id: '2',
        name: 'Fabulous Pants',
        description: 'Stylish pants for every occasion.',
        price: 15.0,
        imageUrl: '',
        colors: ['Blue', 'Black'],
        sizes: ['42', '44', '46'],
      ),
      ProductModel(
        id: '3',
        name: 'Jeans Pants',
        description: 'Stylish Jeans for every occasion.',
        price: 75.0,
        imageUrl: '',
        colors: ['Blue', 'White', 'Grey'],
        sizes: ['36', '42', '44', '46'],
      ),
      ProductModel(
        id: '4',
        name: 'T-Shirt',
        description: 'Stylish T-Shirt for every occasion.',
        price: 75.0,
        imageUrl: '',
        colors: ['Blue', 'White', 'Grey'],
        sizes: ['S', 'M', 'L', 'XL'],
      ),
      ProductModel(
        id: '5',
        name: 'T-Shirt V',
        description: 'Stylish T-Shirt for every occasion.',
        price: 75.0,
        imageUrl: '',
        colors: ['Blue', 'White', 'Grey'],
        sizes: ['S', 'M', 'L', 'XL'],
      ),
      ProductModel(
        id: '6',
        name: 'T-Shirt VI',
        description: 'Stylish T-Shirt for every occasion.',
        price: 75.0,
        imageUrl: '',
        colors: ['Blue', 'White', 'Grey'],
        sizes: ['S', 'M', 'L', 'XL'],
      ),
    ];
  }
}
