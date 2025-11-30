import 'product.dart';

class OrderItemRead {
  final int id;
  final int quantity;
  final String pricePerUnit;
  final Product? product;

  OrderItemRead({
    required this.id,
    required this.quantity,
    required this.pricePerUnit,
    this.product,
  });

  factory OrderItemRead.fromJson(Map<String, dynamic> json) {
    return OrderItemRead(
      id: json['id'],
      quantity: json['quantity'],
      pricePerUnit: json['price_per_unit'].toString(),
      product: json['product_details'] != null
          ? Product.fromJson(json['product_details'])
          : null,
    );
  }
}

class OrderRead {
  final int id;
  final String status;
  final String totalAmount;
  final String? finalPrice;
  final String date;
  final String deliveryType;
  final List<OrderItemRead> items;

  OrderRead({
    required this.id,
    required this.status,
    required this.totalAmount,
    this.finalPrice,
    required this.date,
    required this.deliveryType,
    required this.items,
  });

  factory OrderRead.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List;
    List<OrderItemRead> itemsList =
    list.map((i) => OrderItemRead.fromJson(i)).toList();

    return OrderRead(
      id: json['id'],
      status: json['status'],
      totalAmount: json['total_amount'].toString(),
      finalPrice: json['final_price_with_discount']?.toString(),
      date: json['order_date'],
      deliveryType: json['delivery_type'],
      items: itemsList,
    );
  }
}