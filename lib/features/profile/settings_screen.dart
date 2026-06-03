import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/utils/ui_helpers.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageProvider>();
    final theme = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(language.tr('settings'))),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text(language.tr('language'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          RadioListTile<String>(
            value: 'en',
            groupValue: language.currentLanguageCode,
            onChanged: (value) {
              if (value == null) return;
              language.changeLanguage(value);
              showAppSnackBar(context, 'Language changed to English');
            },
            title: const Text('English'),
          ),
          RadioListTile<String>(
            value: 'hi',
            groupValue: language.currentLanguageCode,
            onChanged: (value) {
              if (value == null) return;
              language.changeLanguage(value);
              showAppSnackBar(context, 'भाषा हिंदी में बदली गई');
            },
            title: const Text('हिंदी'),
          ),
          RadioListTile<String>(
            value: 'mr',
            groupValue: language.currentLanguageCode,
            onChanged: (value) {
              if (value == null) return;
              language.changeLanguage(value);
              showAppSnackBar(context, 'भाषा मराठीत बदलली');
            },
            title: const Text('मराठी'),
          ),
          const Divider(height: 28),
          SwitchListTile(
            value: theme.isDark,
            onChanged: (value) {
              theme.toggle(value);
              showAppSnackBar(context, value ? 'Dark theme enabled' : 'Light theme enabled');
            },
            title: Text(language.tr('theme')),
            subtitle: const Text('Switch between light and dark mode'),
            secondary: const Icon(Icons.dark_mode_outlined),
          ),
          const Divider(height: 28),
          ListTile(leading: const Icon(Icons.support_agent), title: Text(language.tr('contactUs')), onTap: () => context.push('/contact-us')),
          ListTile(leading: const Icon(Icons.help_outline), title: Text(language.tr('faqs')), onTap: () => context.push('/faqs')),
          const Divider(height: 28),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                showAppSnackBar(context, 'Logged out successfully');
                context.go('/login');
              }
            },
            icon: const Icon(Icons.logout),
            label: Text(language.tr('logout')),
          ),
        ],
      ),
    );
  }
}
