import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/hero_banner.dart';
import '../widgets/product_card.dart';

class HomeTab extends StatefulWidget {
  final VoidCallback onToCatalog;

  const HomeTab({super.key, required this.onToCatalog});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final ApiService apiService = ApiService();
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = apiService.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeroBanner(),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Новинки", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kTextColor)),
              TextButton(
                onPressed: widget.onToCatalog,
                child: const Text("Переглянути всі →", style: TextStyle(color: kPrimaryColor)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FutureBuilder<List<Product>>(
            future: futureProducts,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final displayProducts = snapshot.data!.take(4).toList();
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: displayProducts[index],
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}