import 'package:flutter/material.dart';

IconData spendIcon(String key) {
  switch (key) {
    case 'restaurant':
      return Icons.restaurant_rounded;
    case 'flight':
      return Icons.flight_takeoff_rounded;
    case 'shopping_bag':
      return Icons.shopping_bag_rounded;
    case 'receipt':
      return Icons.receipt_long_rounded;
    case 'health':
      return Icons.health_and_safety_rounded;
    case 'movie':
      return Icons.movie_filter_rounded;
    case 'taxi':
      return Icons.local_taxi_rounded;
    case 'train':
      return Icons.train_rounded;
    case 'bus':
      return Icons.directions_bus_rounded;
    case 'car':
      return Icons.directions_car_rounded;
    case 'fuel':
      return Icons.local_gas_station_rounded;
    case 'grocery':
      return Icons.local_grocery_store_rounded;
    case 'phone':
      return Icons.phone_android_rounded;
    case 'wifi':
      return Icons.wifi_rounded;
    case 'card':
      return Icons.credit_card_rounded;
    case 'doctor':
      return Icons.medical_services_rounded;
    case 'fitness':
      return Icons.fitness_center_rounded;
    case 'music':
      return Icons.music_note_rounded;
    case 'game':
      return Icons.sports_esports_rounded;
    case 'wallet':
      return Icons.account_balance_wallet_rounded;
    default:
      return Icons.payments_rounded;
  }
}

Color colorFromHex(String value) {
  final normalized = value.replaceFirst('#', '');
  return Color(int.parse(normalized.length == 6 ? 'FF$normalized' : normalized, radix: 16));
}

Color categoryColor(String category) {
  switch (category) {
    case 'Food':
      return const Color(0xFFEF4444);
    case 'Travel':
      return const Color(0xFF3B82F6);
    case 'Shopping':
      return const Color(0xFFA855F7);
    case 'Bills':
      return const Color(0xFFF97316);
    case 'Health':
      return const Color(0xFF14B8A6);
    case 'Entertainment':
      return const Color(0xFFEC4899);
    default:
      return const Color(0xFF4F46E5);
  }
}

String defaultIconForCategory(String category) {
  switch (category) {
    case 'Food':
      return 'restaurant';
    case 'Travel':
      return 'taxi';
    case 'Shopping':
      return 'shopping_bag';
    case 'Bills':
      return 'receipt';
    case 'Health':
      return 'health';
    case 'Entertainment':
      return 'movie';
    default:
      return 'wallet';
  }
}
