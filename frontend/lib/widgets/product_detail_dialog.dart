import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/product.dart';
import '../services/cart_service.dart';

class ProductDetailDialog extends StatelessWidget {
  final Product product;

  const ProductDetailDialog({super.key, required this.product});

  void _addToCart(BuildContext context) {
    CartService().addToCart(product);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product.name} додано в кошик!"),
        backgroundColor: kPrimaryColor,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        width: 300,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery
        .of(context)
        .size
        .width > 600;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 800,
          maxHeight: isWideScreen ? 500 : 800,
        ),
        child: isWideScreen
            ? Row(
          children: [
            Expanded(flex: 4, child: _buildImageSection()),
            Expanded(flex: 5, child: _buildInfoSection(context)),
          ],
        )
            : Column(
          children: [
            Expanded(flex: 3, child: _buildImageSection()),
            Expanded(flex: 5, child: _buildInfoSection(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      decoration: BoxDecoration(
        color: kSecondaryColor.withOpacity(0.4),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: Center(
        child: Hero(
          tag: product.id,
          child: Icon(
            Icons.medication_liquid,
            size: 120,
            color: kPrimaryColor.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (product.isPrescription)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, size: 16,
                          color: Colors.red[700]),
                      const SizedBox(width: 5),
                      Text("За рецептом", style: TextStyle(
                          color: Colors.red[700],
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              else
                const SizedBox(),
              IconButton(
                icon: const Icon(Icons.close, color: kTextLightColor),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(product.categoryName ?? "Загальне",
              style: const TextStyle(color: kTextLightColor, fontSize: 12)),
          Text(product.name, style: const TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: kTextColor)),
          if (product.manufacturerName != null)
            Text("Виробник: ${product.manufacturerName}",
                style: const TextStyle(
                    color: kPrimaryColor, fontWeight: FontWeight.w500)),

          const SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              child: Text(
                product.description,
                style: const TextStyle(
                    fontSize: 15, color: kTextColor, height: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 10),

          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Ціна за шт.",
                      style: TextStyle(color: kTextLightColor, fontSize: 12)),
                  Text("${product.price} ₴", style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: kPrimaryColor)),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: product.stockQuantity > 0
                    ? () => _addToCart(context)
                    : null,
                child: Text(
                  product.stockQuantity > 0 ? "У кошик" : "Немає",
                  style: const TextStyle(fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}