import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'providers/onboarding_provider.dart';
import 'router/app_router.dart';
import 'services/onboarding_prefs.dart';
import 'theme/app_theme.dart';

// Global singletons — created before runApp so they're always ready.
late final PersistCookieJar appCookieJar;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise the cookie jar once at startup — synchronous after this point.
  final dir = await getApplicationDocumentsDirectory();
  appCookieJar = PersistCookieJar(
    storage: FileStorage('${dir.path}/.al_abraar_cookies/'),
    ignoreExpires: false,
  );

  // Pre-load onboarding flag so the router redirect is synchronous.
  onboardingSeen = await OnboardingPrefs.hasSeenOnboarding();

  runApp(const ProviderScope(child: AlAbraarStudentApp()));
}

class AlAbraarStudentApp extends ConsumerWidget {
  const AlAbraarStudentApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeProvider);
    return MaterialApp.router(
      title: 'Al-Abraar Student',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
