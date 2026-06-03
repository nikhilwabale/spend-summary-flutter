import 'package:flutter/material.dart';

import '../../core/widgets/app_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alerts = [
      'Monthly spend crossed 70% of your mock budget',
      'Shopping category increased compared to last week',
      'New transaction added successfully',
      'Weekly spend summary is ready to review',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Spend Alerts')),
      body: ListView.separated(
        padding: const EdgeInsets.all(18),
        itemCount: alerts.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return AppCard(
            child: Row(
              children: [
                const CircleAvatar(backgroundColor: Color(0xFFEFF6FF), child: Icon(Icons.notifications, color: Color(0xFF2563EB))),
                const SizedBox(width: 12),
                Expanded(child: Text(alerts[index], style: const TextStyle(fontWeight: FontWeight.w700))),
              ],
            ),
          );
        },
      ),
    );
  }
}
