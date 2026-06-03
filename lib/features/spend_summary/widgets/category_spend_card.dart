import 'package:flutter/material.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/spend_summary_models.dart';
import 'spend_ui_helpers.dart';

class CategorySpendCard extends StatelessWidget {
  final SpendCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategorySpendCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = colorFromHex(category.color);
    final background = isSelected
        ? accent
        : isDark
            ? const Color(0xFF111827)
            : Colors.white;
    final borderColor = isSelected
        ? accent
        : isDark
            ? const Color(0xFF263244)
            : const Color(0xFFE6EAF2);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      width: 172,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: isSelected ? 1.3 : 1),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: (isSelected ? accent : Colors.black).withOpacity(isSelected ? .22 : .045),
              blurRadius: isSelected ? 24 : 16,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white.withOpacity(.20) : accent.withOpacity(.12),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        spendIcon(category.icon),
                        color: isSelected ? Colors.white : accent,
                        size: 22,
                      ),
                    ),
                    const Spacer(),
                    AnimatedScale(
                      duration: const Duration(milliseconds: 180),
                      scale: isSelected ? 1 : .72,
                      child: Icon(
                        isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                        color: isSelected ? Colors.white : Colors.transparent,
                        size: 22,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  category.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 15.5,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  CurrencyFormatter.inr(category.amount),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected ? Colors.white.withOpacity(.88) : Colors.grey.shade600,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
