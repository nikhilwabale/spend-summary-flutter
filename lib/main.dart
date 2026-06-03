import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/themes/app_theme.dart';
import 'providers/app_providers.dart';
import 'providers/language_provider.dart';
import 'providers/theme_provider.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SpendSummaryApp());
}

class SpendSummaryApp extends StatelessWidget {
  const SpendSummaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: Consumer2<LanguageProvider, ThemeProvider>(
        builder: (context, language, theme, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Spend Summary',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: theme.mode,
            locale: language.locale,
            supportedLocales: const [Locale('en'), Locale('hi'), Locale('mr')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: AppRoutes.router,
          );
        },
      ),
    );
  }
}
