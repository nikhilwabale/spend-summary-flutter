import 'package:go_router/go_router.dart';

import '../features/auth/login_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/auth/splash_screen.dart';
import '../features/contact/contact_us_screen.dart';
import '../features/faqs/faqs_screen.dart';
import '../features/flow/intro_screen.dart';
import '../features/flow/language_selection_screen.dart';
import '../features/flow/permission_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/profile/settings_screen.dart';
import '../features/spend_summary/spend_summary_screen.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/permissions', builder: (context, state) => const PermissionScreen()),
      GoRoute(path: '/intro', builder: (context, state) => const IntroScreen()),
      GoRoute(path: '/language', builder: (context, state) => const LanguageSelectionScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
      GoRoute(path: '/dashboard', builder: (context, state) => const SpendSummaryScreen()),
      GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
      GoRoute(path: '/contact-us', builder: (context, state) => const ContactUsScreen()),
      GoRoute(path: '/faqs', builder: (context, state) => const FaqsScreen()),
      GoRoute(path: '/alerts', builder: (context, state) => const NotificationsScreen()),
    ],
  );
}
