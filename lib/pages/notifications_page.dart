import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final List<String> notifications;

  const NotificationsPage({super.key, this.notifications = const [
    "You just made a transaction: Rp.1,000,000",
    "Balance added: Rp.500,000"
  ]});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A2A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD97941),
        title: const Text("Notifications", style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1F),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(notifications[index], style: const TextStyle(color: Colors.white)),
          );
        },
      ),
    );
  }
}