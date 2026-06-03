import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/spend_summary_models.dart';

class SpendSummaryRepository {
  Future<SpendSummaryData> loadSpendSummary() async {
    final rawData = await rootBundle.loadString('assets/data/spend_summary.json');
    final jsonData = jsonDecode(rawData) as Map<String, dynamic>;
    return SpendSummaryData.fromJson(jsonData);
  }
}
