import 'package:flutter/material.dart';

import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/app_card.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.email_rounded, 'title': 'Email', 'value': 'support@spendsummary.app'},
      {'icon': Icons.chat_bubble_rounded, 'title': 'Live Chat', 'value': 'Ask questions about dashboard usage'},
      {'icon': Icons.bug_report_rounded, 'title': 'Report Issue', 'value': 'Share app feedback or UI issue'},
      {'icon': Icons.info_outline_rounded, 'title': 'App', 'value': 'Spend Summary Flutter Demo'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF14B8A6)]),
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.support_agent_rounded, color: Colors.white, size: 48),
              SizedBox(height: 12),
              Text('Need help with Spend Summary?', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
              SizedBox(height: 6),
              Text('Contact us for login help, dashboard guidance, transaction tracking questions or app feedback.', style: TextStyle(color: Colors.white70)),
            ]),
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  onTap: () => showAppSnackBar(context, '${item['title']} selected'),
                  child: Row(
                    children: [
                      CircleAvatar(backgroundColor: const Color(0xFFEFF6FF), child: Icon(item['icon'] as IconData, color: const Color(0xFF2563EB))),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.w900)),
                          Text(item['value'] as String, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                        ]),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
