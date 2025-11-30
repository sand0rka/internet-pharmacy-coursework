import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/notification_model.dart';
import '../../services/api_service.dart';

class NotificationList extends StatefulWidget {
  final int userId;

  const NotificationList({super.key, required this.userId});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NotificationModel>>(
      future: ApiService().getMyNotifications(widget.userId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) return const Center(child: Text(
              "Сповіщень немає", style: TextStyle(color: kTextLightColor)));

          return ListView.builder(
            padding: const EdgeInsets.all(kDefaultPadding),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final note = snapshot.data![index];
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                color: note.isRead ? Colors.white : kSecondaryColor.withOpacity(
                    0.3),
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: Icon(
                      note.isRead ? Icons.notifications_none : Icons
                          .notifications_active,
                      color: note.isRead ? Colors.grey : kPrimaryColor
                  ),
                  title: Text(note.message, style: TextStyle(
                      fontWeight: note.isRead ? FontWeight.normal : FontWeight
                          .bold, fontSize: 14)),
                  subtitle: Text(note.createdAt.substring(0, 10),
                      style: const TextStyle(fontSize: 12)),
                  onTap: () async {
                    if (!note.isRead) {
                      await ApiService().markNotificationAsRead(note.id);
                      setState(() {});
                    }
                  },
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