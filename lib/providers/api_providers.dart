import 'package:al_abraar_core/al_abraar_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Singleton AuthStorage — shared across the app.
final authStorageProvider = Provider<AuthStorage>((ref) => AuthStorage());

/// Singleton ApiClient — reads API_BASE_URL from dart-define at build time,
/// falls back to the production URL baked into AppConstants.
final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.watch(authStorageProvider);
  return ApiClient(
    baseUrl: AppConstants.apiBaseUrl,
    storage: storage,
  );
});

/// AuthRepository — wraps login / logout / me via the core package.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    apiClient: ref.watch(apiClientProvider),
    storage: ref.watch(authStorageProvider),
  );
});
