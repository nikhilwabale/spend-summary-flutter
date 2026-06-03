import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/currency_formatter.dart';
import '../../data/models/spend_summary_models.dart';
import '../../data/repositories/spend_summary_repository.dart';
import 'widgets/category_spend_card.dart';
import 'widgets/monthly_spend_card.dart';
import 'widgets/spend_ui_helpers.dart';
import 'widgets/transaction_tile.dart';

class SpendSummaryScreen extends StatefulWidget {
  const SpendSummaryScreen({super.key});

  @override
  State<SpendSummaryScreen> createState() => _SpendSummaryScreenState();
}

class _SpendSummaryScreenState extends State<SpendSummaryScreen> {
  SpendSummaryData? _data;
  bool _isLoading = true;
  String _selectedCategory = 'All';
  final List<SpendTransaction> _transactions = [];
  num _lastMonthSpend = 0;

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    try {
      final data = await SpendSummaryRepository().loadSpendSummary();
      if (!mounted) return;
      setState(() {
        _data = data;
        _transactions
          ..clear()
          ..addAll(data.transactions);
        final currentAmount = data.monthlySpend.amount;
        final change = data.monthlySpend.percentageChange / 100;
        _lastMonthSpend = data.monthlySpend.isIncrease
            ? currentAmount / (1 + change)
            : currentAmount / (1 - change);
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  List<SpendTransaction> get _filteredTransactions {
    if (_selectedCategory == 'All') return _transactions;
    return _transactions.where((item) => item.category == _selectedCategory).toList();
  }

  List<SpendCategory> _buildCategories(SpendSummaryData data) {
    return data.categories.map((category) {
      final amount = category.name == 'All'
          ? _transactions.fold<num>(0, (sum, item) => sum + item.amount)
          : _transactions
              .where((item) => item.category == category.name)
              .fold<num>(0, (sum, item) => sum + item.amount);
      return SpendCategory(
        name: category.name,
        amount: amount,
        icon: category.icon,
        color: category.color,
      );
    }).toList();
  }

  MonthlySpend _buildMonthlySpend(SpendSummaryData data) {
    final total = _transactions.fold<num>(0, (sum, item) => sum + item.amount);
    final change = _lastMonthSpend == 0 ? 0 : ((total - _lastMonthSpend) / _lastMonthSpend * 100);
    return MonthlySpend(
      amount: total,
      percentageChange: num.parse(change.abs().toStringAsFixed(1)),
      isIncrease: change >= 0,
      month: data.monthlySpend.month,
      budget: data.monthlySpend.budget,
    );
  }

  Future<void> _showAddTransactionSheet() async {
    final data = _data;
    if (data == null) return;

    final added = await showModalBottomSheet<SpendTransaction>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddTransactionSheet(data: data),
    );

    if (added == null || !mounted) return;
    setState(() {
      _transactions.insert(0, added);
      _selectedCategory = added.category;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${added.title} added successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        titleSpacing: 20,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Spend Summary', style: TextStyle(fontWeight: FontWeight.w900)),
            SizedBox(height: 2),
            Text('Track your monthly expenses', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.tune_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTransactionSheet,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add'),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final data = _data;
    if (data == null) {
      return const Center(child: Text('Unable to load spend summary.'));
    }

    final categories = _buildCategories(data);
    final filteredTransactions = _filteredTransactions;
    final total = categories.first.amount;

    return RefreshIndicator(
      onRefresh: _loadSummary,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
        children: [
          MonthlySpendCard(spend: _buildMonthlySpend(data)),
          const SizedBox(height: 22),
          _SummaryChips(
            totalTransactions: _transactions.length,
            selectedTransactions: filteredTransactions.length,
            totalAmount: total,
          ),
          const SizedBox(height: 28),
          _SectionHeader(
            title: 'Spending Categories',
            actionText: _selectedCategory == 'All' ? 'Tap to filter' : 'Clear filter',
            onActionTap: _selectedCategory == 'All' ? null : () => setState(() => _selectedCategory = 'All'),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 134,
            child: ListView.builder(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 280 + (index * 45)),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(offset: Offset(20 * (1 - value), 0), child: child),
                    );
                  },
                  child: CategorySpendCard(
                    category: category,
                    isSelected: _selectedCategory == category.name,
                    onTap: () => setState(() => _selectedCategory = category.name),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 28),
          _SectionHeader(
            title: _selectedCategory == 'All' ? 'Recent Transactions' : '$_selectedCategory Transactions',
            actionText: '${filteredTransactions.length} items',
          ),
          const SizedBox(height: 14),
          if (filteredTransactions.isEmpty)
            _EmptyTransactions(category: _selectedCategory)
          else
            ...filteredTransactions.map((transaction) => TransactionTile(transaction: transaction)),
        ],
      ),
    );
  }
}

class _SummaryChips extends StatelessWidget {
  final int totalTransactions;
  final int selectedTransactions;
  final num totalAmount;

  const _SummaryChips({
    required this.totalTransactions,
    required this.selectedTransactions,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InfoChip(
            icon: Icons.receipt_long_rounded,
            title: '$totalTransactions',
            subtitle: 'Total records',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _InfoChip(
            icon: Icons.filter_alt_rounded,
            title: '$selectedTransactions',
            subtitle: 'Showing now',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _InfoChip(
            icon: Icons.payments_rounded,
            title: CurrencyFormatter.inr(totalAmount),
            subtitle: 'Total spend',
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoChip({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? const Color(0xFF263244) : const Color(0xFFE8ECF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback? onActionTap;

  const _SectionHeader({required this.title, required this.actionText, this.onActionTap});

  @override
  Widget build(BuildContext context) {
    final action = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        actionText,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
        ),
        if (onActionTap == null) action else InkWell(
          onTap: onActionTap,
          borderRadius: BorderRadius.circular(999),
          child: action,
        ),
      ],
    );
  }
}

class _EmptyTransactions extends StatelessWidget {
  final String category;

  const _EmptyTransactions({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(.06),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox_rounded, size: 42, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 12),
          Text('No $category transactions found', style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _AddTransactionSheet extends StatefulWidget {
  final SpendSummaryData data;

  const _AddTransactionSheet({required this.data});

  @override
  State<_AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<_AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late String _category;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _amountController = TextEditingController();
    _category = widget.data.categories.firstWhere((item) => item.name != 'All').name;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    final amount = num.parse(_amountController.text.trim());

    Navigator.of(context).pop(
      SpendTransaction(
        title: _titleController.text.trim(),
        category: _category,
        amount: amount,
        date: 'Just now',
        type: 'debit',
        icon: defaultIconForCategory(_category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final maxHeight = MediaQuery.of(context).size.height * .88;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Material(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            clipBehavior: Clip.antiAlias,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 5,
                        width: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Add Transaction',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Add a mock transaction locally for this session.',
                      style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 22),
                    TextFormField(
                      controller: _titleController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'Example: Coffee, Uber, Amazon',
                        prefixIcon: Icon(Icons.edit_note_rounded),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) return 'Please enter transaction title';
                        if (text.length < 3) return 'Title should be at least 3 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _amountController,
                      textInputAction: TextInputAction.done,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        hintText: 'Example: 450',
                        prefixIcon: Icon(Icons.currency_rupee_rounded),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final amount = num.tryParse(value?.trim() ?? '');
                        if (amount == null) return 'Please enter valid amount';
                        if (amount <= 0) return 'Amount should be greater than zero';
                        if (amount > 1000000) return 'Amount is too large';
                        return null;
                      },
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Category',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: widget.data.categories.where((item) => item.name != 'All').map((item) {
                        final isSelected = _category == item.name;
                        final accent = colorFromHex(item.color);
                        return ChoiceChip(
                          selected: isSelected,
                          showCheckmark: false,
                          avatar: Icon(
                            spendIcon(item.icon),
                            size: 18,
                            color: isSelected ? Colors.white : accent,
                          ),
                          label: Text(item.name),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : null,
                            fontWeight: FontWeight.w800,
                          ),
                          selectedColor: accent,
                          backgroundColor: accent.withOpacity(.09),
                          side: BorderSide(color: isSelected ? accent : accent.withOpacity(.18)),
                          onSelected: (_) => setState(() => _category = item.name),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton.icon(
                        onPressed: _submit,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Add Transaction'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
