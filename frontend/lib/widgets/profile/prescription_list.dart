import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/prescription.dart';
import '../../services/api_service.dart';

class PrescriptionList extends StatelessWidget {
  final int userId;

  const PrescriptionList({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Prescription>>(
      future: ApiService().getMyPrescriptions(userId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) return const Center(child: Text(
              "Рецептів немає", style: TextStyle(color: kTextLightColor)));

          return ListView.builder(
            padding: const EdgeInsets.all(kDefaultPadding),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final p = snapshot.data![index];
              return Card(
                elevation: 2,
                shadowColor: Colors.blue.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(
                        Icons.medical_services, color: Colors.blue),
                  ),
                  title: Text(p.medicationName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Дата видачі: ${p.issueDate}"),
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                ),
              );
            },
          );
        }
        return const Center(
            child: CircularProgressIndicator(color: kPrimaryColor));
      },
    );
  }
}