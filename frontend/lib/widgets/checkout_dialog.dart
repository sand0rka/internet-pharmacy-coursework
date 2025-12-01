import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/pharmacy.dart';
import '../services/api_service.dart';
import '../services/order_service.dart';
import '../services/auth_service.dart';

class CheckoutDialog extends StatefulWidget {
  const CheckoutDialog({super.key});

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  String deliveryType = 'courier';
  Pharmacy? selectedPharmacy;
  List<Pharmacy> pharmacies = [];
  final TextEditingController addressController = TextEditingController();
  bool isLoading = false;
  bool isPharmaciesLoading = false;
  bool useBonuses = false;

  @override
  void initState() {
    super.initState();
  }

  void _loadPharmacies() async {
    if (pharmacies.isNotEmpty) return;

    setState(() => isPharmaciesLoading = true);
    try {
      final data = await ApiService().getPharmacies();
      if (mounted) {
        setState(() {
          pharmacies = data;
          if (pharmacies.isNotEmpty) selectedPharmacy = pharmacies[0];
          isPharmaciesLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isPharmaciesLoading = false);
    }
  }

  void _submitOrder() async {
    setState(() => isLoading = true);

    final errorMessage = await OrderService().createOrder(
      deliveryType: deliveryType,
      pharmacyId: deliveryType == 'pickup' ? selectedPharmacy?.id : null,
      deliveryAddress: deliveryType == 'courier'
          ? addressController.text
          : null,
      useBonuses: useBonuses,
    );

    if (errorMessage == null) {
      await AuthService().refreshUser();
    }

    if (mounted) {
      Navigator.pop(context, errorMessage == null);

      if (errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Замовлення успішно створено!"),
            backgroundColor: kPrimaryColor,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(child: Text(errorMessage)),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    final double userBonuses = user?.bonusPoints ?? 0.0;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Оформлення замовлення"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (userBonuses > 0) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange.shade200)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.monetization_on, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text("У вас є ${userBonuses.toStringAsFixed(
                            2)} бонусів",
                            style: const TextStyle(fontWeight: FontWeight
                                .bold)),
                      ],
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text("Списати бонуси?"),
                      value: useBonuses,
                      activeColor: kPrimaryColor,
                      onChanged: (val) => setState(() => useBonuses = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            const Text("Спосіб доставки:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile<String>(
              title: const Text("Кур'єр"),
              value: 'courier',
              groupValue: deliveryType,
              activeColor: kPrimaryColor,
              contentPadding: EdgeInsets.zero,
              onChanged: (value) => setState(() => deliveryType = value!),
            ),
            RadioListTile<String>(
              title: const Text("Самовивіз з аптеки"),
              value: 'pickup',
              groupValue: deliveryType,
              activeColor: kPrimaryColor,
              contentPadding: EdgeInsets.zero,
              onChanged: (value) {
                setState(() => deliveryType = value!);
                if (value == 'pickup') _loadPharmacies();
              },
            ),

            if (deliveryType == 'courier') ...[
              const SizedBox(height: 10),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: "Адреса доставки",
                  hintText: "вул. Шевченка, 1, кв. 5",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  isDense: true,
                ),
              ),
            ],

            if (deliveryType == 'pickup') ...[
              const SizedBox(height: 10),
              const Text("Оберіть аптеку:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              if (isPharmaciesLoading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(color: kPrimaryColor),
                )
              else
                DropdownButtonFormField<Pharmacy>(
                  value: selectedPharmacy,
                  isExpanded: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                  ),
                  items: pharmacies.map((p) {
                    return DropdownMenuItem(
                      value: p,
                      child: Text(p.address, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => selectedPharmacy = val),
                ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Відміна", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: isLoading ? null : _submitOrder,
          child: isLoading
              ? const SizedBox(width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2))
              : const Text(
              "Підтвердити", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}