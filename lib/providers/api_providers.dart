import 'package:al_abraar_core/al_abraar_core.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

// ---------------------------------------------------------------------------
// Cookie jar — persists NextAuth session cookie across app restarts
// ---------------------------------------------------------------------------

final cookieJarProvider = FutureProvider<PersistCookieJar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return PersistCookieJar(
    storage: FileStorage('${dir.path}/.al_abraar_cookies/'),
    ignoreExpires: false,
  );
});

// ---------------------------------------------------------------------------
// Core singletons
// ---------------------------------------------------------------------------

/// Secure storage for access / refresh tokens.
final authStorageProvider = Provider<AuthStorage>((ref) => AuthStorage());

/// ApiClient — sends BOTH Bearer token (via AuthInterceptor) AND
/// NextAuth session cookie (via CookieManager) on every request.
/// Returns null while the cookie jar is still initialising.
final apiClientProvider = Provider<ApiClient?>((ref) {
  final cookieJar = ref.watch(cookieJarProvider).valueOrNull;
  final storage = ref.watch(authStorageProvider);
  if (cookieJar == null) return null;
  return ApiClient(
    baseUrl: AppConstants.apiBaseUrl,
    storage: storage,
    cookieJar: cookieJar,
  );
});

/// CookieAuthService — handles NextAuth CSRF + credentials POST.
/// Returns null while the cookie jar is still initialising.
final cookieAuthServiceProvider = Provider<CookieAuthService?>((ref) {
  final cookieJar = ref.watch(cookieJarProvider).valueOrNull;
  if (cookieJar == null) return null;
  return CookieAuthService(
    baseUrl: AppConstants.apiBaseUrl,
    cookieJar: cookieJar,
  );
});

/// AuthRepository — wraps login / logout / getMe via the core.
/// Returns null while dependencies are still initialising.
final authRepositoryProvider = Provider<AuthRepository?>((ref) {
  final client = ref.watch(apiClientProvider);
  final storage = ref.watch(authStorageProvider);
  if (client == null) return null;
  return AuthRepository(apiClient: client, storage: storage);
});
