import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import 'cart_screen.dart';
import 'catalog_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkNotifications();
  }

  void _checkNotifications() async {
    final user = AuthService().currentUser;
    if (user != null) {
      final unread = await ApiService().getUnreadNotifications(user.id);

      if (unread.isNotEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.notifications_active, color: Colors.white),
                const SizedBox(width: 10),
                Text("У вас ${unread.length} нових сповіщень!"),
              ],
            ),
            backgroundColor: kPrimaryColor,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'ПЕРЕГЛЯНУТИ',
              textColor: Colors.yellow,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ProfileScreen(initialTab: 1)));
              },
            ),
          ),
        );
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeTab(onToCatalog: () => _onItemTapped(1)),
      const CatalogTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black12,
        title: Row(
          children: [
            const Icon(Icons.local_pharmacy, color: kPrimaryColor, size: 28),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => _onItemTapped(0),
              child: const Text("ЕкоАптека",
                  style: TextStyle(
                      color: kTextColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 22)),
            ),
            const SizedBox(width: 60),
            _buildMenuItem("Головна", 0),
            const SizedBox(width: 20),
            _buildMenuItem("Каталог", 1),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: kTextColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              ).then((_) => setState(() {}));
            },
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.person, color: kTextColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
    );
  }

  Widget _buildMenuItem(String title, int index) {
    final bool isActive = _selectedIndex == index;
    return TextButton(
      onPressed: () => _onItemTapped(index),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? kPrimaryColor : kTextLightColor,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          fontSize: 16,
        ),
      ),
    );
  }
}