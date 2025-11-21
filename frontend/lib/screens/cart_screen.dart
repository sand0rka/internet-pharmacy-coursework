import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/cart_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService cartService = CartService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ваш Кошик", style: TextStyle(color: kTextColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: kTextColor),
      ),
      body: cartService.items.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_basket_outlined, size: 100, color: kPrimaryColor.withOpacity(0.2)),
            const SizedBox(height: 20),
            const Text("Кошик порожній", style: TextStyle(fontSize: 18, color: kTextLightColor)),
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(kDefaultPadding),
              itemCount: cartService.items.length,
              itemBuilder: (context, index) {
                final item = cartService.items[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [kDefaultShadow],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kSecondaryColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.medication_liquid, color: kPrimaryColor),
                    ),
                    title: Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${item.quantity} шт. x ${item.product.price} ₴"),
                    trailing: Text(
                      "${(double.parse(item.product.price) * item.quantity).toStringAsFixed(2)} ₴",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor, fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(kDefaultPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(offset: const Offset(0, -10), blurRadius: 20, color: Colors.black.withOpacity(0.05)),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Всього:", style: TextStyle(fontSize: 16, color: kTextLightColor)),
                      Text(
                        "${cartService.totalAmount.toStringAsFixed(2)} ₴",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: cartService.items.isEmpty
                          ? null
                          : () {
                        _showCheckoutDialog(context);
                      },
                      child: const Text("Оформити замовлення", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCheckoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Замовлення"),
        content: const Text("Скоро тут буде форма оформлення!"),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("ОК"))],
      ),
    );
  }
}