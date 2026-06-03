import 'package:flutter/material.dart';

import '../data/datasources/secure_storage_service.dart';

class AppFlowProvider extends ChangeNotifier {
  final SecureStorageService _secureStorage;

  AppFlowProvider(this._secureStorage);

  static const String _permissionsKey = 'spend_summary_permissions_completed';
  static const String _introKey = 'spend_summary_intro_completed';
  static const String _languageKey = 'spend_summary_language_selected';

  bool isInitialized = false;
  bool permissionsCompleted = false;
  bool introCompleted = false;
  bool languageSelected = false;

  Future<void> initialize() async {
    final permissions = await _secureStorage.read(_permissionsKey);
    final intro = await _secureStorage.read(_introKey);
    final language = await _secureStorage.read(_languageKey);

    permissionsCompleted = permissions == 'true';
    introCompleted = intro == 'true';
    languageSelected = language == 'true';
    isInitialized = true;
    notifyListeners();
  }

  Future<void> completePermissions() async {
    permissionsCompleted = true;
    await _secureStorage.write(_permissionsKey, 'true');
    notifyListeners();
  }

  Future<void> completeIntro() async {
    introCompleted = true;
    await _secureStorage.write(_introKey, 'true');
    notifyListeners();
  }

  Future<void> completeLanguage() async {
    languageSelected = true;
    await _secureStorage.write(_languageKey, 'true');
    notifyListeners();
  }
}
