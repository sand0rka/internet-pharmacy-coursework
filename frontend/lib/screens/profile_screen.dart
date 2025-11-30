import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/order_read.dart';
import '../models/notification_model.dart';
import '../models/prescription.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/cart_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final int initialTab;

  const ProfileScreen({super.key, this.initialTab = 0});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final AuthService authService = AuthService();
  final ApiService apiService = ApiService();
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

  void _repeatOrder(OrderRead order) {
    for (var item in order.items) {
      if (item.product != null) {
        CartService().addToCart(item.product!);
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Товари додано в кошик!"),
          backgroundColor: kPrimaryColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = authService.currentUser;
    if (user == null)
      return const Center(child: Text("Помилка: користувач не знайдений"));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Мій кабінет", style: TextStyle(color: kTextColor)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: _logout,
            tooltip: "Вийти",
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(kDefaultPadding),
            padding: const EdgeInsets.all(kDefaultPadding),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [kDefaultShadow],
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 35, color: kPrimaryColor),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text(user.email,
                        style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                              color: kAccentColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Text("Статус: ${user.clientType}",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Бонуси: ${user.bonusPoints.toStringAsFixed(1)}",
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: kPrimaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: kPrimaryColor,
            tabs: const [
              Tab(text: "Замовлення"),
              Tab(text: "Сповіщення"),
              Tab(text: "Рецепти"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOrdersList(user.id),
                _buildNotificationsList(user.id),
                _buildPrescriptionsList(user.id),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(int userId) {
    return FutureBuilder<List<OrderRead>>(
      future: apiService.getMyOrders(userId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final orders = snapshot.data!;
          if (orders.isEmpty)
            return const Center(child: Text("Історія порожня"));

          return ListView.builder(
            padding: const EdgeInsets.all(kDefaultPadding),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              bool hasDiscount = order.finalPrice != null &&
                  double.parse(order.finalPrice!) <
                      double.parse(order.totalAmount);

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ExpansionTile(
                  leading: const Icon(Icons.inventory_2_outlined,
                      color: kPrimaryColor),
                  title: Row(
                    children: [
                      Text("Замовлення №${order.id} "),
                      if (hasDiscount) ...[
                        Text("${order.totalAmount} ₴",
                            style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                                fontSize: 12)),
                        const SizedBox(width: 5),
                        Text("${order.finalPrice} ₴",
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(width: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(4)),
                          child: const Text("%",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                        )
                      ] else
                        Text("(${order.totalAmount} ₴)"),
                    ],
                  ),
                  subtitle: Text(
                      "${order.date.substring(0, 10)} • ${order.status}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.replay, color: kPrimaryColor),
                    onPressed: () => _repeatOrder(order),
                    tooltip: "Повторити замовлення",
                  ),
                  children: order.items
                      .map((item) =>
                      ListTile(
                        title:
                        Text(item.product?.name ?? "Невідомий товар"),
                        trailing: Text("${item.quantity} шт."),
                      ))
                      .toList(),
                ),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildNotificationsList(int userId) {
    return FutureBuilder<List<NotificationModel>>(
      future: apiService.getMyNotifications(userId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty)
            return const Center(child: Text("Сповіщень немає"));

          return ListView.builder(
            padding: const EdgeInsets.all(kDefaultPadding),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final note = snapshot.data![index];
              return Card(
                color: note.isRead ? Colors.white : Colors.green[50],
                child: ListTile(
                  leading: Icon(
                      note.isRead
                          ? Icons.notifications_none
                          : Icons.notifications_active,
                      color: note.isRead ? Colors.grey : kPrimaryColor),
                  title: Text(
                    note.message,
                    style: TextStyle(
                        fontWeight:
                        note.isRead ? FontWeight.normal : FontWeight.bold),
                  ),
                  subtitle: Text(note.createdAt.substring(0, 10)),
                  onTap: () async {
                    if (!note.isRead) {
                      await apiService.markNotificationAsRead(note.id);
                      setState(() {});
                    }
                  },
                ),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildPrescriptionsList(int userId) {
    return FutureBuilder<List<Prescription>>(
      future: apiService.getMyPrescriptions(userId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty)
            return const Center(child: Text("Рецептів немає"));

          return ListView.builder(
            padding: const EdgeInsets.all(kDefaultPadding),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final p = snapshot.data![index];
              return Card(
                child: ListTile(
                  leading: const Icon(
                      Icons.medical_services, color: Colors.blue),
                  title: Text(p.medicationName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Дата видачі: ${p.issueDate}"),
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                ),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}