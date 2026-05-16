import 'package:al_abraar_core/al_abraar_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_providers.dart';

// ---------------------------------------------------------------------------
// Auth state
// ---------------------------------------------------------------------------

class AuthState {
  final bool isLoggedIn;
  final bool isGuest;
  final UserModel? user;

  const AuthState({
    required this.isLoggedIn,
    this.isGuest = false,
    this.user,
  });

  /// Convenience getter — screens that need user fields as Map still work.
  Map<String, dynamic>? get userMap => user?.toJson();
}

// ---------------------------------------------------------------------------
// Auth notifier
// ---------------------------------------------------------------------------

class AuthNotifier extends AsyncNotifier<AuthState> {
  AuthRepository get _repo => ref.read(authRepositoryProvider);
  AuthStorage get _storage => ref.read(authStorageProvider);

  @override
  Future<AuthState> build() async {
    // Purge any leftover dev tokens from previous builds.
    final raw = await _storage.getAccessToken();
    if (raw == 'demo_token') {
      await _storage.clearAll();
      return const AuthState(isLoggedIn: false);
    }

    final isLoggedIn = await _repo.isLoggedIn();
    if (!isLoggedIn) return const AuthState(isLoggedIn: false);

    try {
      final user = await _repo.getMe();
      return AuthState(isLoggedIn: true, user: user);
    } catch (_) {
      // Token exists but /me failed (offline or expired) — stay logged in with
      // cached user data if available.
      final cached = await _storage.getUser();
      if (cached != null) {
        return AuthState(
          isLoggedIn: true,
          user: UserModel.fromJson(cached),
        );
      }
      return const AuthState(isLoggedIn: true);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repo.login(email: email, password: password);

      // This app is student-only — block other roles.
      if (user.role.toUpperCase() != 'STUDENT') {
        state = AsyncValue.error(
          'This app is for students only. Please use the correct Al-Abraar app for your role.',
          StackTrace.current,
        );
        await _storage.clearAll();
        return;
      }

      state = AsyncValue.data(AuthState(isLoggedIn: true, user: user));
    } on ApiException catch (e) {
      // Provide a friendlier message for common cases.
      final msg = e.statusCode == 401 || e.statusCode == 403
          ? 'Incorrect email or password. Please try again.'
          : e.message;
      state = AsyncValue.error(msg, StackTrace.current);
      rethrow;
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
      rethrow;
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required int age,
    required String region,
    required bool isParentRegistering,
  }) async {
    state = const AsyncValue.loading();
    try {
      final client = ref.read(apiClientProvider);
      final data = await client.post<Map<String, dynamic>>(
        ApiEndpoints.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'age': age,
          'region': region,
          'isParentRegistering': isParentRegistering,
          'role': 'STUDENT',
        },
      );
      final accessToken =
          (data['accessToken'] ?? data['access_token']) as String;
      final refreshToken =
          (data['refreshToken'] ?? data['refresh_token']) as String;
      await _storage.saveTokens(accessToken, refreshToken);

      final userJson = data['user'] as Map<String, dynamic>? ?? data;
      final user = UserModel.fromJson(userJson);
      await _storage.saveUser(user.toJson());

      state = AsyncValue.data(AuthState(isLoggedIn: true, user: user));
    } on ApiException catch (e) {
      state = AsyncValue.error(e.message, StackTrace.current);
      rethrow;
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
      rethrow;
    }
  }

  Future<void> loginAsGuest() async {
    state = const AsyncValue.data(AuthState(isLoggedIn: false, isGuest: true));
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AsyncValue.data(AuthState(isLoggedIn: false));
  }

  UserModel? get currentUser => state.valueOrNull?.user;
}

final authStateProvider =
    AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

final isGuestProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).valueOrNull?.isGuest ?? false;
});

/// The signed-in user, or null.
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authStateProvider).valueOrNull?.user;
});
