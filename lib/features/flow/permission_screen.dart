import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../core/utils/ui_helpers.dart';
import '../../providers/app_flow_provider.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  Future<void> _askPermissions(BuildContext context) async {
    await [
      Permission.notification,
      Permission.camera,
      Permission.photos,
    ].request();

    if (context.mounted) {
      context.read<AppFlowProvider>().completePermissions();
      showAppSnackBar(context, 'Permissions setup completed');
      context.go('/intro');
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.notifications_active_rounded, 'title': 'Notifications', 'sub': 'Get reminders for budgets and spending alerts'},
      {'icon': Icons.camera_alt_rounded, 'title': 'Camera', 'sub': 'Capture receipt screenshots if required'},
      {'icon': Icons.photo_library_rounded, 'title': 'Photos', 'sub': 'Attach transaction proof from gallery'},
    ];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const SizedBox(height: 16),
            Container(
              height: 76,
              width: 76,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF14B8A6)]),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 24),
            const Text('Set up permissions', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text('Spend Summary uses optional permissions only to improve reminders, screenshots and receipt attachment flows.', style: TextStyle(color: Colors.grey.shade600, height: 1.4)),
            const SizedBox(height: 24),
            ...items.map((item) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Theme.of(context).dividerColor.withOpacity(.12)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(backgroundColor: const Color(0xFFEFF6FF), child: Icon(item['icon'] as IconData, color: const Color(0xFF2563EB))),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.w900)),
                          const SizedBox(height: 3),
                          Text(item['sub'] as String, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                        ]),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 18),
            ElevatedButton(onPressed: () => _askPermissions(context), child: const Text('Allow & Continue')),
            TextButton(
              onPressed: () async {
                await context.read<AppFlowProvider>().completePermissions();
                if (context.mounted) context.go('/intro');
              },
              child: const Text('Skip for now'),
            ),
          ],
        ),
      ),
    );
  }
}
