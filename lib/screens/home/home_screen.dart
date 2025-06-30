import 'package:flutter/material.dart';
import 'package:marketplace_rizki/models/product.dart';
import 'package:marketplace_rizki/services/api_service.dart';
import 'package:marketplace_rizki/screens/detail/product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:marketplace_rizki/providers/cart_provider.dart';
import 'package:marketplace_rizki/widgets/cart_dialog.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Product>> _foodProductsFuture;

  @override
  void initState() {
    super.initState();
    _foodProductsFuture = _apiService.getFoodProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        backgroundColor: Color.fromARGB(255, 0, 221, 151),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const CartDialog(), 
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _foodProductsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada produk makanan ditemukan.'));
          } else {
            final List<Product> foodProducts = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.65,
                ),
                itemCount: foodProducts.length,
                itemBuilder: (context, index) {
                  final product = foodProducts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(productId: product.id),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                              child: Image.network(
                                product.thumbnail,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, size: 30, color: Colors.grey)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Rp ${(product.price * 10000).toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 229, 16, 16),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Consumer<CartProvider>(
                                    builder: (context, cartProvider, child) {
                                      return IconButton(
                                        icon: Icon(
                                          cartProvider.isProductInCart(product) ? Icons.check_circle : Icons.add_shopping_cart,
                                          color: cartProvider.isProductInCart(product) ? Colors.green : Colors.orange,
                                          size: 18,
                                        ),
                                        onPressed: () {
                                          if (!cartProvider.isProductInCart(product)) {
                                            cartProvider.addItem(product);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('${product.title} ditambahkan ke keranjang')),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('${product.title} sudah ada di keranjang')),
                                            );
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
