import 'package:al_abraar_core/al_abraar_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart' show appCookieJar;

// ---------------------------------------------------------------------------
// Cookie jar — synchronous singleton, pre-initialised in main() before runApp.
// No async wait needed anywhere in the provider graph.
// ---------------------------------------------------------------------------

final cookieJarProvider = Provider<PersistCookieJar>((ref) => appCookieJar);

// ---------------------------------------------------------------------------
// Core singletons
// ---------------------------------------------------------------------------

/// Secure storage for access / refresh tokens.
final authStorageProvider = Provider<AuthStorage>((ref) => AuthStorage());

/// ApiClient — sends Bearer token (AuthInterceptor) AND NextAuth session
/// cookie (CookieManager) on every request.
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: AppConstants.apiBaseUrl,
    storage: ref.watch(authStorageProvider),
    cookieJar: ref.watch(cookieJarProvider),
  );
});

/// CookieAuthService — handles NextAuth CSRF + credentials POST.
final cookieAuthServiceProvider = Provider<CookieAuthService>((ref) {
  return CookieAuthService(
    baseUrl: AppConstants.apiBaseUrl,
    cookieJar: ref.watch(cookieJarProvider),
  );
});

/// AuthRepository — wraps login / logout / getMe via the core.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    apiClient: ref.watch(apiClientProvider),
    storage: ref.watch(authStorageProvider),
  );
});
