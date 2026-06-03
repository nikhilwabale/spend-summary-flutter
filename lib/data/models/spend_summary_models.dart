class MonthlySpend {
  final num amount;
  final num percentageChange;
  final bool isIncrease;
  final String month;
  final num budget;

  const MonthlySpend({
    required this.amount,
    required this.percentageChange,
    required this.isIncrease,
    required this.month,
    required this.budget,
  });

  factory MonthlySpend.fromJson(Map<String, dynamic> json) {
    return MonthlySpend(
      amount: json['amount'] as num,
      percentageChange: json['percentageChange'] as num,
      isIncrease: json['isIncrease'] as bool,
      month: json['month'] as String,
      budget: json['budget'] as num,
    );
  }
}

class SpendCategory {
  final String name;
  final num amount;
  final String icon;
  final String color;

  const SpendCategory({
    required this.name,
    required this.amount,
    required this.icon,
    required this.color,
  });

  factory SpendCategory.fromJson(Map<String, dynamic> json) {
    return SpendCategory(
      name: json['name'] as String,
      amount: json['amount'] as num,
      icon: json['icon'] as String,
      color: json['color'] as String,
    );
  }
}

class SpendTransaction {
  final String title;
  final String category;
  final num amount;
  final String date;
  final String type;
  final String icon;

  const SpendTransaction({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.type,
    required this.icon,
  });

  factory SpendTransaction.fromJson(Map<String, dynamic> json) {
    return SpendTransaction(
      title: json['title'] as String,
      category: json['category'] as String,
      amount: json['amount'] as num,
      date: json['date'] as String,
      type: json['type'] as String,
      icon: json['icon'] as String,
    );
  }
}

class SpendSummaryData {
  final MonthlySpend monthlySpend;
  final List<SpendCategory> categories;
  final List<SpendTransaction> transactions;

  const SpendSummaryData({
    required this.monthlySpend,
    required this.categories,
    required this.transactions,
  });

  factory SpendSummaryData.fromJson(Map<String, dynamic> json) {
    return SpendSummaryData(
      monthlySpend: MonthlySpend.fromJson(json['monthlySpend'] as Map<String, dynamic>),
      categories: (json['categories'] as List<dynamic>)
          .map((item) => SpendCategory.fromJson(item as Map<String, dynamic>))
          .toList(),
      transactions: (json['transactions'] as List<dynamic>)
          .map((item) => SpendTransaction.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
