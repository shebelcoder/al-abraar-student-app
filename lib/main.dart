import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

// Global singleton — created before runApp so it's always ready.
late final PersistCookieJar appCookieJar;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise the cookie jar once at startup — synchronous after this point.
  final dir = await getApplicationDocumentsDirectory();
  appCookieJar = PersistCookieJar(
    storage: FileStorage('${dir.path}/.al_abraar_cookies/'),
    ignoreExpires: false,
  );

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
