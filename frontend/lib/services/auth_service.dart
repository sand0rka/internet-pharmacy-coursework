import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class CurrentUser {
  final int id;
  final String name;
  final String email;

  CurrentUser({required this.id, required this.name, required this.email});

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    return CurrentUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
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

  Future<bool> register(String name, String email, String phone, String password) async {
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