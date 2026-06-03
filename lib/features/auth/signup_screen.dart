import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/utils/ui_helpers.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    mobileCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(language.tr('signup'))),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const Icon(Icons.account_balance_wallet_rounded, size: 72, color: Color(0xFF2563EB)),
          const SizedBox(height: 14),
          const Text('Create Spend Summary Account', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
          const SizedBox(height: 24),
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person))),
          const SizedBox(height: 14),
          TextField(controller: mobileCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Mobile Number', prefixIcon: Icon(Icons.phone))),
          const SizedBox(height: 14),
          TextField(controller: emailCtrl, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email))),
          const SizedBox(height: 14),
          TextField(controller: passCtrl, obscureText: true, decoration: InputDecoration(labelText: language.tr('password'), prefixIcon: const Icon(Icons.lock))),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: auth.isLoading
                ? null
                : () async {
                    if (nameCtrl.text.trim().isEmpty || emailCtrl.text.trim().isEmpty || passCtrl.text.trim().isEmpty) {
                      showAppSnackBar(context, 'Please fill required details');
                      return;
                    }
                    await auth.signup(name: nameCtrl.text.trim(), email: emailCtrl.text.trim(), mobile: mobileCtrl.text.trim(), password: passCtrl.text.trim());
                    if (context.mounted) {
                      showAppSnackBar(context, language.tr('signupSuccess'));
                      context.go('/dashboard');
                    }
                  },
            child: auth.isLoading
                ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                : Text(language.tr('signup')),
          ),
        ],
      ),
    );
  }
}
