import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../data/datasources/secure_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final SecureStorageService _secureStorage;

  AuthProvider(this._secureStorage);

  static const String _userEmailKey = 'spend_summary_user_email';

  bool isInitialized = false;
  bool isLoading = false;
  bool isLoggedIn = false;
  String? currentUserEmail;

  Future<void> initialize() async {
    final token = await _secureStorage.read(AppConstants.sessionTokenKey);
    final email = await _secureStorage.read(_userEmailKey);

    isLoggedIn = token != null && token.isNotEmpty;
    currentUserEmail = email;
    isInitialized = true;
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 550));
    final email = username.trim();
    await _secureStorage.write(AppConstants.sessionTokenKey, 'mock_spend_summary_token');
    await _secureStorage.write(_userEmailKey, email);
    currentUserEmail = email;
    isLoggedIn = true;
    isLoading = false;
    notifyListeners();
  }

  Future<void> signup({
    required String name,
    required String email,
    required String mobile,
    required String password,
  }) async {
    isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 650));
    final userEmail = email.trim();
    await _secureStorage.write(AppConstants.sessionTokenKey, 'mock_spend_summary_token');
    await _secureStorage.write(_userEmailKey, userEmail);
    currentUserEmail = userEmail;
    isLoggedIn = true;
    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _secureStorage.delete(AppConstants.sessionTokenKey);
    await _secureStorage.delete(_userEmailKey);
    currentUserEmail = null;
    isLoggedIn = false;
    notifyListeners();
  }
}
