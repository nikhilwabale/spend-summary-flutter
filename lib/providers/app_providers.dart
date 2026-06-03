import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/datasources/secure_storage_service.dart';
import 'app_flow_provider.dart';
import 'auth_provider.dart';
import 'language_provider.dart';
import 'theme_provider.dart';

class AppProviders {
  static final SecureStorageService _secureStorage = SecureStorageService();

  static List<SingleChildWidget> get providers => [
        ChangeNotifierProvider<AppFlowProvider>(create: (_) => AppFlowProvider(_secureStorage)),
        ChangeNotifierProvider<LanguageProvider>(create: (_) => LanguageProvider()),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider(_secureStorage)),
      ];
}
