import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/live/live_viewer_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/attendance_screen.dart';
import '../screens/home/badges_screen.dart';
import '../screens/home/dashboard_screen.dart';
import '../screens/home/help_screen.dart';
import '../screens/home/leaderboard_screen.dart';
import '../screens/home/marks_screen.dart';
import '../screens/home/messages_screen.dart';
import '../screens/home/notifications_screen.dart';
import '../screens/home/practice_screen.dart';
import '../screens/home/profile_screen.dart';
import '../screens/home/progress_screen.dart';
import '../screens/home/report_card_screen.dart';
import '../screens/home/schedule_screen.dart';
import '../screens/home/settings_screen.dart';
import '../screens/messages/chat_screen.dart';
import '../screens/practice/ai_practice_session_screen.dart';
import '../screens/practice/session_setup_screen.dart';
import '../screens/quran/quran_player_screen.dart';
import '../screens/quran/quran_screen.dart';
import '../widgets/main_shell.dart';

// Bridges Riverpod auth state to a GoRouter-compatible Listenable so the
// router refreshes its redirect without recreating the GoRouter instance.
class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this._ref) {
    _ref.listen<AsyncValue<AuthState>>(
      authStateProvider,
      (_, __) => notifyListeners(),
    );
  }

  final Ref _ref;

  String? redirect(BuildContext context, GoRouterState state) {
    final authAsync = _ref.read(authStateProvider);
    if (authAsync.isLoading) return null;

    final authState = authAsync.valueOrNull;
    final isLoggedIn = authState?.isLoggedIn ?? false;
    final isGuest = authState?.isGuest ?? false;
    final hasSession = isLoggedIn || isGuest;
    final path = state.uri.path;
    final isAuthRoute =
        path == '/login' || path == '/register' || path == '/splash';

    if (!hasSession && !isAuthRoute) return '/login';
    if (hasSession && (path == '/login' || path == '/splash')) {
      return '/home/dashboard';
    }
    // Guests cannot access practice sessions
    if (isGuest && (path == '/practice/session' || path == '/practice/setup')) {
      return '/home/practice';
    }
    return null;
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);
  ref.onDispose(notifier.dispose);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (_, __) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, __) => const RegisterScreen(),
      ),
      ShellRoute(
        builder: (_, __, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home/dashboard',
            builder: (_, __) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/home/practice',
            builder: (_, __) => const PracticeScreen(),
          ),
          GoRoute(
            path: '/home/schedule',
            builder: (_, __) => const ScheduleScreen(),
          ),
          GoRoute(
            path: '/home/messages',
            builder: (_, __) => const MessagesScreen(),
          ),
          GoRoute(
            path: '/home/profile',
            builder: (_, __) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/home/progress',
            builder: (_, __) => const ProgressScreen(),
          ),
          GoRoute(
            path: '/home/leaderboard',
            builder: (_, __) => const LeaderboardScreen(),
          ),
          GoRoute(
            path: '/home/badges',
            builder: (_, __) => const BadgesScreen(),
          ),
          GoRoute(
            path: '/home/attendance',
            builder: (_, __) => const AttendanceScreen(),
          ),
          GoRoute(
            path: '/home/notifications',
            builder: (_, __) => const NotificationsScreen(),
          ),
          GoRoute(
            path: '/home/settings',
            builder: (_, __) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/home/marks',
            builder: (_, __) => const MarksScreen(),
          ),
          GoRoute(
            path: '/home/report-card',
            builder: (_, __) => const ReportCardScreen(),
          ),
          GoRoute(
            path: '/home/help',
            builder: (_, __) => const HelpScreen(),
          ),
          // Quran tab (inside ShellRoute so bottom nav stays visible)
          GoRoute(
            path: '/quran',
            builder: (_, __) => const QuranScreen(),
          ),
        ],
      ),
      // Quran player — full screen (no bottom nav)
      GoRoute(
        path: '/quran/player',
        builder: (_, state) {
          final surah = state.extra as dynamic;
          if (surah == null) {
            return const QuranScreen();
          }
          return QuranPlayerScreen(surah: surah);
        },
      ),
      GoRoute(
        path: '/live/viewer',
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return LiveViewerScreen(
            teacherName: extra['teacherName'] as String? ?? 'Teacher',
            subject: extra['subject'] as String? ?? 'Live Session',
            teacherInitials: extra['teacherInitials'] as String? ?? 'T',
            teacherColor: Color(extra['teacherColor'] as int? ?? 0xFF166534),
          );
        },
      ),
      GoRoute(
        path: '/practice/setup',
        builder: (_, __) => const SessionSetupScreen(),
      ),
      GoRoute(
        path: '/practice/session',
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final surahIndex = extra['surahIndex'] as int? ?? 0;
          final modeName = extra['mode'] as String? ?? 'listenRepeat';
          final mode = PracticeMode.values.firstWhere(
            (m) => m.name == modeName,
            orElse: () => PracticeMode.listenRepeat,
          );
          return AIPracticeSessionScreen(
              surahIndex: surahIndex, mode: mode);
        },
      ),
      GoRoute(
        path: '/messages/chat',
        builder: (context, state) {
          final params = state.uri.queryParameters;
          return ChatScreen(
            name: params['name'] ?? 'Teacher',
            initials: params['initials'] ?? '?',
            colorValue: int.tryParse(params['color'] ?? '') ??
                0xFF166534,
          );
        },
      ),
    ],
  );
});
