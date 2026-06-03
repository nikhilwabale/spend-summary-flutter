import 'package:flutter/material.dart';

class FaqsScreen extends StatelessWidget {
  const FaqsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {'q': 'What is Spend Summary?', 'a': 'Spend Summary is a mock Flutter expense dashboard that shows monthly spend, category-wise totals and recent transactions.'},
      {'q': 'Is backend integration required?', 'a': 'No. This assignment uses local mock JSON data only, as requested in the task.'},
      {'q': 'Can I add a new transaction?', 'a': 'Yes. Tap the floating Add button, enter title, amount and category. The dashboard totals update immediately for the current session.'},
      {'q': 'How does category filtering work?', 'a': 'Tap any category card to filter the transactions list. Tap Clear filter to return to all transactions.'},
      {'q': 'Where is the data stored?', 'a': 'Initial data is loaded from assets/data/spend_summary.json. Newly added transactions are stored in app state during the current session.'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('FAQs')),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ExpansionTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              backgroundColor: Theme.of(context).colorScheme.surface,
              collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
              leading: const Icon(Icons.help_outline_rounded),
              title: Text(faq['q']!, style: const TextStyle(fontWeight: FontWeight.w900)),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Align(alignment: Alignment.centerLeft, child: Text(faq['a']!)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
