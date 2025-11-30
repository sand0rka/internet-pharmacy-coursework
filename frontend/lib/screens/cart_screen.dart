import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/cart_service.dart';
import '../services/auth_service.dart';
import '../widgets/checkout_dialog.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService cartService = CartService();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    double total = cartService.totalAmount;
    double discountPercent = authService.currentDiscountPercent;
    double discountAmount = total * discountPercent;
    double finalPrice = total - discountAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ваш Кошик", style: TextStyle(color: kTextColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: kTextColor),
        actions: [
          if (cartService.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.red),
              onPressed: () {
                setState(() {
                  cartService.clear();
                });
              },
              tooltip: "Очистити кошик",
            )
        ],
      ),
      body: cartService.items.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_basket_outlined, size: 100, color: kPrimaryColor.withOpacity(0.2)),
            const SizedBox(height: 20),
            const Text("Кошик порожній 😔", style: TextStyle(fontSize: 18, color: kTextLightColor)),
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
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: kSecondaryColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.medication_liquid, color: kPrimaryColor),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text("${item.product.price} ₴", style: const TextStyle(color: kTextLightColor)),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 18, color: kTextColor),
                                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  setState(() {
                                    cartService.removeOne(item.product);
                                  });
                                },
                              ),
                              Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.add, size: 18, color: kPrimaryColor),
                                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  setState(() {
                                    cartService.addToCart(item.product);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              cartService.removeItem(item.product);
                            });
                          },
                        ),
                      ],
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
                  if (discountAmount > 0) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Сума:", style: TextStyle(color: kTextLightColor)),
                        Text("${total.toStringAsFixed(2)} ₴", style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Ваша знижка (${(discountPercent * 100).toInt()}%):", style: const TextStyle(color: kPrimaryColor)),
                        Text("-${discountAmount.toStringAsFixed(2)} ₴", style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(height: 20),
                  ],

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("До сплати:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(
                        "${finalPrice.toStringAsFixed(2)} ₴",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: kTextColor),
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
                        showDialog(
                          context: context,
                          builder: (context) => const CheckoutDialog(),
                        ).then((result) {
                          if (result == true) {
                            setState(() {});
                          }
                        });
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
}