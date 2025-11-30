import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/product_card.dart';

class HomeTab extends StatelessWidget {
  final Function() onToCatalog;

  const HomeTab({super.key, required this.onToCatalog});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: _buildBanner(context),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Новинки",
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                // Збільшили шрифт
                TextButton(
                  onPressed: onToCatalog,
                  child: const Text(
                      "Всі товари", style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
        FutureBuilder<List<Product>>(
          future: ApiService().getProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SliverToBoxAdapter(
                  child: Center(
                      child: CircularProgressIndicator(color: kPrimaryColor)));
            } else if (snapshot.hasError) {
              return SliverToBoxAdapter(
                  child: Center(child: Text("Помилка: ${snapshot.error}")));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const SliverToBoxAdapter(
                  child: Center(child: Text("Товарів не знайдено")));
            }

            final popularProducts = snapshot.data!
                .take(8)
                .toList();

            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                  kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return ProductCard(
                      product: popularProducts[index],
                    );
                  },
                  childCount: popularProducts.length,
                ),
              ),
            );
          },
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 50)),
      ],
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
          color: const Color(0xFFD97706),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [kDefaultShadow],
          image: const DecorationImage(
              image: NetworkImage(
                  "https://www.transparenttextures.com/patterns/cubes.png"),
              fit: BoxFit.cover,
              opacity: 0.1
          )
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Осінь без застуд!",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                const Text(
                    "Вітаміни та засоби для зміцнення імунітету зі знижкою до 30%.",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFD97706),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {},
                  child: const Text("Детальніше", style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Icon(Icons.umbrella, color: Colors.white.withOpacity(0.3), size: 180),
        ],
      ),
    );
  }
}