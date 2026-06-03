import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/utils/ui_helpers.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userCtrl = TextEditingController(text: 'demo@spendsummary.app');
  final passCtrl = TextEditingController(text: '123456');
  bool showPassword = false;

  @override
  void dispose() {
    userCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const SizedBox(height: 20),
            Container(
              height: 92,
              width: 92,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF14B8A6)]),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(.25), blurRadius: 22, offset: const Offset(0, 12))],
              ),
              child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 30),
            Text(language.tr('loginTitle'), style: const TextStyle(fontSize: 31, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(language.tr('loginSubtitle'), style: TextStyle(color: Colors.grey.shade600, height: 1.45)),
            const SizedBox(height: 28),
            TextField(controller: userCtrl, decoration: InputDecoration(labelText: language.tr('emailMobile'), prefixIcon: const Icon(Icons.person_outline))),
            const SizedBox(height: 16),
            TextField(
              controller: passCtrl,
              obscureText: !showPassword,
              decoration: InputDecoration(
                labelText: language.tr('password'),
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => showPassword = !showPassword),
                ),
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: auth.isLoading
                  ? null
                  : () async {
                      if (userCtrl.text.trim().isEmpty || passCtrl.text.trim().isEmpty) {
                        showAppSnackBar(context, 'Please enter Spend Summary login details');
                        return;
                      }
                      await auth.login(userCtrl.text, passCtrl.text);
                      if (context.mounted) {
                        showAppSnackBar(context, 'Login successful');
                        context.go('/dashboard');
                      }
                    },
              child: auth.isLoading
                  ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                  : Text(language.tr('secureLogin')),
            ),
            const SizedBox(height: 16),
            Center(child: TextButton(onPressed: () => context.push('/signup'), child: Text(language.tr('createAccount')))),
          ],
        ),
      ),
    );
  }
}
