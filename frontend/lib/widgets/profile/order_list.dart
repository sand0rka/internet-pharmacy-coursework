import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/order_read.dart';
import '../../services/api_service.dart';
import '../../services/cart_service.dart';

class OrderList extends StatelessWidget {
  final int userId;
  final VoidCallback onRefresh;

  const OrderList({super.key, required this.userId, required this.onRefresh});

  void _repeatOrder(BuildContext context, OrderRead order) {
    for (var item in order.items) {
      if (item.product != null) {
        CartService().addToCart(item.product!);
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Товари додано в кошик!"),
          backgroundColor: kPrimaryColor),
    );
    onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderRead>>(
      future: ApiService().getMyOrders(userId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final orders = snapshot.data!;
          if (orders.isEmpty) return const Center(child: Text(
              "Історія порожня", style: TextStyle(color: kTextLightColor)));

          return ListView.builder(
            padding: const EdgeInsets.all(kDefaultPadding),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              bool hasDiscount = order.finalPrice != null &&
                  double.parse(order.finalPrice!) <
                      double.parse(order.totalAmount);

              return Card(
                elevation: 2,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  shape: Border.all(color: Colors.transparent),
                  leading: CircleAvatar(
                    backgroundColor: kPrimaryColor.withOpacity(0.1),
                    child: const Icon(
                        Icons.inventory_2_outlined, color: kPrimaryColor),
                  ),
                  title: Row(
                    children: [
                      Text("№${order.id}",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      if (hasDiscount) ...[
                        Text("${order.totalAmount} ₴",
                            style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                                fontSize: 12)),
                        const SizedBox(width: 5),
                        Text("${order.finalPrice} ₴",
                            style: const TextStyle(color: Colors.green,
                                fontWeight: FontWeight.bold)),
                      ] else
                        Text("${order.totalAmount} ₴", style: const TextStyle(
                            fontWeight: FontWeight.w600)),
                    ],
                  ),
                  subtitle: Text(
                      "${order.date.substring(0, 10)} • ${order.status}",
                      style: const TextStyle(fontSize: 12)),
                  trailing: IconButton(
                    icon: const Icon(Icons.replay, color: kPrimaryColor),
                    onPressed: () => _repeatOrder(context, order),
                    tooltip: "Повторити",
                  ),
                  children: order.items.map((item) =>
                      ListTile(
                        dense: true,
                        title: Text(item.product?.name ?? "Видалений товар"),
                        trailing: Text("${item.quantity} шт."),
                      )).toList(),
                ),
              );
            },
          );
        }
        return const Center(
            child: CircularProgressIndicator(color: kPrimaryColor));
      },
    );
  }
}