import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class CurrentUser {
  final int id;
  final String name;
  final String email;
  final String clientType;
  final double bonusPoints;

  CurrentUser({
    required this.id,
    required this.name,
    required this.email,
    required this.clientType,
    required this.bonusPoints,
  });

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    return CurrentUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      clientType: json['client_type_name'] ?? "Standard",
      bonusPoints: double.tryParse(json['bonus_points'].toString()) ?? 0.0,
    );
  }
}

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  AuthService._internal();

  CurrentUser? _currentUser;

  CurrentUser? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  double get currentDiscountPercent {
    if (_currentUser == null) return 0.0;

    switch (_currentUser!.clientType) {
      case 'Premium':
        return 0.15;
      case 'Social':
        return 0.05;
      default:
        return 0.0;
    }
  }

  Future<void> refreshUser() async {
    if (_currentUser == null) return;

    try {
      // Робимо запит на отримання деталей поточного юзера
      final url = Uri.parse(
          '${ApiService.baseUrl}/clients/${_currentUser!.id}/');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        _currentUser = CurrentUser.fromJson(data); // Перезаписуємо дані
      }
    } catch (e) {
      print("Refresh user error: $e");
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final url = Uri.parse('${ApiService.baseUrl}/clients/login/');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        _currentUser = CurrentUser.fromJson(data);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String name, String email, String phone,
      String password) async {
    try {
      final url = Uri.parse('${ApiService.baseUrl}/clients/register/');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        _currentUser = CurrentUser.fromJson(data);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void logout() {
    _currentUser = null;
  }
}