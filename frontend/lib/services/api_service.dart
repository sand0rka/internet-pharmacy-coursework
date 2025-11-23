import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

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
      List<Product> products = body.map((dynamic item) => Product.fromJson(item)).toList();
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }
}