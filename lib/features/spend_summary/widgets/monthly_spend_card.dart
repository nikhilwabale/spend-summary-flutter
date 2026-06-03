import 'package:flutter/material.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/spend_summary_models.dart';

class MonthlySpendCard extends StatelessWidget {
  final MonthlySpend spend;

  const MonthlySpendCard({super.key, required this.spend});

  @override
  Widget build(BuildContext context) {
    final progress = (spend.amount / spend.budget).clamp(0.0, 1.0).toDouble();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          colors: [Color(0xFF151A3B), Color(0xFF4F46E5), Color(0xFF14B8A6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(.30),
            blurRadius: 28,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.16),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.auto_graph_rounded, color: Colors.white),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  spend.month,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            'Monthly Spend',
            style: TextStyle(color: Colors.white.withOpacity(.78), fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatter.inr(spend.amount),
            style: const TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w900, letterSpacing: -.8),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(
                spend.isIncrease ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                color: spend.isIncrease ? const Color(0xFFFFE082) : const Color(0xFFBBF7D0),
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                '${spend.isIncrease ? '+' : '-'}${spend.percentageChange}% vs last month',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 22),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: Colors.white.withOpacity(.18),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${CurrencyFormatter.inr(spend.budget - spend.amount)} left from budget',
            style: TextStyle(color: Colors.white.withOpacity(.82), fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
