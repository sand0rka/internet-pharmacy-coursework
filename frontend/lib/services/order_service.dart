import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'auth_service.dart';
import 'cart_service.dart';

class OrderService {
  Future<bool> createOrder({
    required String deliveryType,
    int? pharmacyId,
    String? deliveryAddress,
  }) async {
    final user = AuthService().currentUser;
    final cartItems = CartService().items;

    if (user == null || cartItems.isEmpty) return false;

    List<Map<String, dynamic>> itemsJson = cartItems.map((item) {
      return {
        "product": item.product.id,
        "quantity": item.quantity,
      };
    }).toList();

    final Map<String, dynamic> orderData = {
      "client": user.id,
      "delivery_type": deliveryType,
      "items": itemsJson,
    };

    if (pharmacyId != null) {
      orderData["pharmacy"] = pharmacyId;
    }
    if (deliveryAddress != null && deliveryAddress.isNotEmpty) {
      orderData["delivery_address"] = deliveryAddress;
    }

    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/orders/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 201) {
        CartService().clear();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}