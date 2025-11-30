import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/pharmacy.dart';
import '../models/order_read.dart';
import '../models/notification_model.dart';
import '../models/prescription.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  Future<List<Product>> getProducts({
    String? searchQuery,
    bool? isPrescription,
    bool? inStock,
    double? minPrice,
    double? maxPrice,
  }) async {
    String url = '$baseUrl/products/?';

    if (searchQuery != null && searchQuery.isNotEmpty) {
      url += 'search=$searchQuery&';
    }
    if (isPrescription != null) {
      url += 'is_prescription=$isPrescription&';
    }
    if (inStock != null && inStock) {
      url += 'in_stock=true&';
    }
    if (minPrice != null) {
      url += 'min_price=$minPrice&';
    }
    if (maxPrice != null) {
      url += 'max_price=$maxPrice&';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Pharmacy>> getPharmacies() async {
    final response = await http.get(Uri.parse('$baseUrl/pharmacies/'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => Pharmacy.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load pharmacies');
    }
  }

  Future<List<OrderRead>> getMyOrders(int clientId) async {
    final response =
    await http.get(Uri.parse('$baseUrl/orders/?client=$clientId'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => OrderRead.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<List<NotificationModel>> getMyNotifications(int clientId) async {
    final response =
    await http.get(Uri.parse('$baseUrl/notifications/?client=$clientId'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body
          .map((dynamic item) => NotificationModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  Future<List<NotificationModel>> getUnreadNotifications(int clientId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/notifications/?client=$clientId&is_read=false'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body
          .map((dynamic item) => NotificationModel.fromJson(item))
          .toList();
    } else {
      return [];
    }
  }

  Future<bool> markNotificationAsRead(int notificationId) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/notifications/$notificationId/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'is_read': true}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<Prescription>> getMyPrescriptions(int clientId) async {
    final response =
    await http.get(Uri.parse('$baseUrl/prescriptions/?client=$clientId'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => Prescription.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load prescriptions');
    }
  }
}