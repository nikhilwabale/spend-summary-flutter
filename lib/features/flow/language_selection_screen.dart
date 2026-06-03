import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/app_flow_provider.dart';
import '../../providers/language_provider.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageProvider>();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.translate_rounded, size: 82, color: Color(0xFF2563EB)),
            const SizedBox(height: 24),
            const Text('Choose Language', textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text('You can change this later from Settings.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 30),
            _languageTile(context, language, 'en', 'English', 'Default'),
            _languageTile(context, language, 'hi', 'हिंदी', 'Hindi'),
            _languageTile(context, language, 'mr', 'मराठी', 'Marathi'),
            const SizedBox(height: 26),
            ElevatedButton(
              onPressed: () async {
                await context.read<AppFlowProvider>().completeLanguage();
                if (context.mounted) context.go('/login');
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _languageTile(BuildContext context, LanguageProvider language, String code, String title, String subtitle) {
    final selected = language.currentLanguageCode == code;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => language.changeLanguage(code),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF2563EB).withOpacity(.10) : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: selected ? const Color(0xFF2563EB) : Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ])),
              Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off, color: selected ? const Color(0xFF2563EB) : Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
