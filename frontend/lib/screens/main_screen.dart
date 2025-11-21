import 'package:flutter/material.dart';
import '../constants.dart';
import 'cart_screen.dart';
import 'catalog_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

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
              child: const Text("ЕкоАптека", style: TextStyle(color: kTextColor, fontWeight: FontWeight.w900, fontSize: 22)),
            ),

            const SizedBox(width: 60),

            _buildMenuItem("Головна", 0),
            const SizedBox(width: 20),
            _buildMenuItem("Каталог", 1),
          ],
        ),
        actions: [

          Container(
            margin: const EdgeInsets.only(right: 20),
            child: IconButton(
              icon: const Icon(Icons.shopping_bag_outlined, color: kTextColor),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                ).then((_) => setState(() {}));
              },
            ),
          ),
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