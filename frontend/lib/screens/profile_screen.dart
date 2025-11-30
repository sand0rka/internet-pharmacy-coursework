import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import '../widgets/profile/order_list.dart';
import '../widgets/profile/notification_list.dart';
import '../widgets/profile/prescription_list.dart';

class ProfileScreen extends StatefulWidget {
  final int initialTab;

  const ProfileScreen({super.key, this.initialTab = 0});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final AuthService authService = AuthService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: widget.initialTab);
    authService.refreshUser().then((_) {
      if (mounted) setState(() {});
    });
  }

  void _logout() {
    authService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = authService.currentUser;
    if (user == null)
      return const Center(child: Text("Помилка: користувач не знайдений"));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Мій кабінет",
            style: TextStyle(color: kTextColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: kTextColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: _logout,
            tooltip: "Вийти",
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(kDefaultPadding),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [kPrimaryColor, Color(0xFF0B6359)]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [kDefaultShadow],
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: kPrimaryColor),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                      Text(user.email, style: const TextStyle(
                          color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _buildInfoTag(user.clientType, Icons.star),
                          const SizedBox(width: 10),
                          _buildInfoTag("${user.bonusPoints.toStringAsFixed(
                              0)} балів", Icons.monetization_on),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),

          TabBar(
            controller: _tabController,
            labelColor: kPrimaryColor,
            unselectedLabelColor: kTextLightColor,
            indicatorColor: kPrimaryColor,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: "Замовлення"),
              Tab(text: "Сповіщення"),
              Tab(text: "Рецепти"),
            ],
          ),

          Expanded(
            child: Container(
              color: const Color(0xFFFAFAFA),
              child: TabBarView(
                controller: _tabController,
                children: [
                  OrderList(userId: user.id, onRefresh: () => setState(() {})),
                  NotificationList(userId: user.id),
                  PrescriptionList(userId: user.id),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTag(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: kAccentColor, size: 14),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}