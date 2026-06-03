import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/app_flow_provider.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final controller = PageController();
  int index = 0;

  final pages = const [
    _IntroData(Icons.pie_chart_rounded, 'Visualize Monthly Spend', 'See your total spend, budget progress and monthly change in one clean dashboard.'),
    _IntroData(Icons.category_rounded, 'Filter by Category', 'Review Food, Travel, Shopping and other categories with smooth horizontal filters.'),
    _IntroData(Icons.receipt_long_rounded, 'Track Transactions', 'Add mock transactions and watch totals, category amounts and recent activity update instantly.'),
  ];

  Future<void> finish() async {
    await context.read<AppFlowProvider>().completeIntro();
    if (mounted) context.go('/login');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(alignment: Alignment.centerRight, child: TextButton(onPressed: finish, child: const Text('Skip'))),
            Expanded(
              child: PageView.builder(
                controller: controller,
                itemCount: pages.length,
                onPageChanged: (value) => setState(() => index = value),
                itemBuilder: (context, i) {
                  final item = pages[i];
                  return Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF14B8A6)]),
                            borderRadius: BorderRadius.circular(42),
                            boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(.20), blurRadius: 28, offset: const Offset(0, 16))],
                          ),
                          child: Icon(item.icon, color: Colors.white, size: 76),
                        ),
                        const SizedBox(height: 34),
                        Text(item.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 12),
                        Text(item.subtitle, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600, height: 1.4)),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.all(4),
                  height: 8,
                  width: index == i ? 26 : 8,
                  decoration: BoxDecoration(color: index == i ? const Color(0xFF2563EB) : Colors.grey.shade300, borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: ElevatedButton(
                onPressed: index == pages.length - 1
                    ? finish
                    : () => controller.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut),
                child: Text(index == pages.length - 1 ? 'Continue to Login' : 'Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroData {
  final IconData icon;
  final String title;
  final String subtitle;

  const _IntroData(this.icon, this.title, this.subtitle);
}
