import 'package:al_abraar_core/al_abraar_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_providers.dart';
import 'auth_provider.dart';

// Convenience accessor — apiClientProvider is now always non-nullable.
ApiClient _client(Ref ref) => ref.read(apiClientProvider);

// ---------------------------------------------------------------------------
// Dashboard  →  /api/student/dashboard
// { currentStreak, weeklyPoints, nextSession?, quranLevel?, ... }
// ---------------------------------------------------------------------------

final dashboardProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  ref.watch(authStateProvider);
  return _client(ref).get<Map<String, dynamic>>(ApiEndpoints.dashboard);
});

// Live broadcasts  →  /api/broadcasts/live
final liveBroadcastsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(authStateProvider);
  try {
    final data =
        await _client(ref).get<List<dynamic>>(ApiEndpoints.liveBroadcasts);
    return data.cast<Map<String, dynamic>>();
  } catch (_) {
    return [];
  }
});

// ---------------------------------------------------------------------------
// Learning sessions  →  /api/student/live-sessions
// ---------------------------------------------------------------------------

final upcomingSessionsProvider =
    FutureProvider<List<SessionModel>>((ref) async {
  ref.watch(authStateProvider);
  final data = await _client(ref).get<List<dynamic>>(
    ApiEndpoints.sessions,
    queryParameters: {'filter': 'upcoming'},
  );
  return data.cast<Map<String, dynamic>>().map(SessionModel.fromJson).toList();
});

final pastSessionsProvider = FutureProvider<List<SessionModel>>((ref) async {
  ref.watch(authStateProvider);
  final data = await _client(ref).get<List<dynamic>>(
    ApiEndpoints.sessions,
    queryParameters: {'filter': 'past'},
  );
  return data.cast<Map<String, dynamic>>().map(SessionModel.fromJson).toList();
});

// ---------------------------------------------------------------------------
// Notifications  →  /api/notifications
// ---------------------------------------------------------------------------

final notificationsListProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(authStateProvider);
  final data = await _client(ref).get<List<dynamic>>(ApiEndpoints.notifications);
  return data.cast<Map<String, dynamic>>();
});

final unreadCountProvider = FutureProvider<int>((ref) async {
  ref.watch(authStateProvider);
  try {
    final data =
        await _client(ref).get<Map<String, dynamic>>(ApiEndpoints.unreadCount);
    return (data['count'] as int?) ?? 0;
  } catch (_) {
    return 0;
  }
});

// ---------------------------------------------------------------------------
// Gamification  →  /api/gamification/*
// ---------------------------------------------------------------------------

final gamificationPointsProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  ref.watch(authStateProvider);
  return _client(ref).get<Map<String, dynamic>>(ApiEndpoints.gamificationPoints);
});

final gamificationStreakProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  ref.watch(authStateProvider);
  return _client(ref).get<Map<String, dynamic>>(ApiEndpoints.gamificationStreak);
});

final gamificationBadgesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(authStateProvider);
  final data =
      await _client(ref).get<List<dynamic>>(ApiEndpoints.gamificationBadges);
  return data.cast<Map<String, dynamic>>();
});

final leaderboardWeeklyProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(authStateProvider);
  final data = await _client(ref).get<List<dynamic>>(
    ApiEndpoints.gamificationLeaderboard,
    queryParameters: {'period': 'weekly'},
  );
  return data.cast<Map<String, dynamic>>();
});

final leaderboardMonthlyProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(authStateProvider);
  final data = await _client(ref).get<List<dynamic>>(
    ApiEndpoints.gamificationLeaderboard,
    queryParameters: {'period': 'monthly'},
  );
  return data.cast<Map<String, dynamic>>();
});

final leaderboardAllTimeProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(authStateProvider);
  final data = await _client(ref).get<List<dynamic>>(
    ApiEndpoints.gamificationLeaderboard,
    queryParameters: {'period': 'all_time'},
  );
  return data.cast<Map<String, dynamic>>();
});

// ---------------------------------------------------------------------------
// SMS — Marks, Attendance, Report Card
// ---------------------------------------------------------------------------

final marksProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  final data = await _client(ref).get<List<dynamic>>(
    ApiEndpoints.marksByStudent(user.id),
  );
  return data.cast<Map<String, dynamic>>();
});

final attendanceProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return {};
  return _client(ref).get<Map<String, dynamic>>(
    ApiEndpoints.attendanceSummary(user.id),
  );
});

final reportCardProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return {};
  return _client(ref).get<Map<String, dynamic>>(
    ApiEndpoints.reportCardByStudent(user.id),
  );
});

// ---------------------------------------------------------------------------
// Community / Conversations
// ---------------------------------------------------------------------------

final conversationsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(authStateProvider);
  final data = await _client(ref)
      .get<List<dynamic>>(ApiEndpoints.communityConversations);
  return data.cast<Map<String, dynamic>>();
});

final conversationMessagesProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>(
        (ref, conversationId) async {
  ref.watch(authStateProvider);
  final data = await _client(ref).get<List<dynamic>>(
    ApiEndpoints.conversationMessages(conversationId),
  );
  return data.cast<Map<String, dynamic>>();
});

// ---------------------------------------------------------------------------
// Practice history
// ---------------------------------------------------------------------------

final practiceHistoryRemoteProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(authStateProvider);
  final data =
      await _client(ref).get<List<dynamic>>(ApiEndpoints.practiceHistory);
  return data.cast<Map<String, dynamic>>();
});

// ---------------------------------------------------------------------------
// Quran
// ---------------------------------------------------------------------------

final quranSurahsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final data = await _client(ref).get<List<dynamic>>(ApiEndpoints.quranSurahs);
  return data.cast<Map<String, dynamic>>();
});

final quranRecitersProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final data =
      await _client(ref).get<List<dynamic>>(ApiEndpoints.quranReciters);
  return data.cast<Map<String, dynamic>>();
});
