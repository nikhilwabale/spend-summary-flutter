import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/app_flow_provider.dart';
import '../../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    final flow = context.read<AppFlowProvider>();
    final auth = context.read<AuthProvider>();

    await Future.wait([
      flow.initialize(),
      auth.initialize(),
      Future<void>.delayed(const Duration(milliseconds: 700)),
    ]);

    if (!mounted) return;

    if (!flow.permissionsCompleted) {
      context.go('/permissions');
      return;
    }

    if (!flow.introCompleted) {
      context.go('/intro');
      return;
    }

    if (auth.isLoggedIn) {
      context.go('/dashboard');
      return;
    }

    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2563EB), Color(0xFF14B8A6)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 92),
              SizedBox(height: 18),
              Text('Spend Summary', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900)),
              SizedBox(height: 8),
              Text('Smart monthly expense overview', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
              SizedBox(height: 28),
              SizedBox(
                height: 28,
                width: 28,
                child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
