import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/practice/session_setup_screen.dart';
import 'student_providers.dart' show gamificationPointsProvider;

// ---------------------------------------------------------------------------
// Session model
// ---------------------------------------------------------------------------

class PracticeSession {
  final String surahName;
  final int score;
  final int totalPossible;
  final int ayahCount;
  final PracticeMode mode;
  final DateTime completedAt;

  const PracticeSession({
    required this.surahName,
    required this.score,
    required this.totalPossible,
    required this.ayahCount,
    required this.mode,
    required this.completedAt,
  });

  double get accuracy =>
      totalPossible == 0 ? 0 : (score / totalPossible).clamp(0.0, 1.0);

  int get accuracyPercent => (accuracy * 100).round();

  String get grade {
    if (accuracy >= 0.90) return 'A';
    if (accuracy >= 0.75) return 'B';
    if (accuracy >= 0.60) return 'C';
    return 'D';
  }

  String get dateLabel {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sessionDay = DateTime(
        completedAt.year, completedAt.month, completedAt.day);
    final diff = today.difference(sessionDay).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '$diff days ago';
  }
}

// ---------------------------------------------------------------------------
// History notifier
// ---------------------------------------------------------------------------

class PracticeHistoryNotifier extends Notifier<List<PracticeSession>> {
  @override
  List<PracticeSession> build() {
    final now = DateTime.now();
    // Seed with realistic mock history spread over recent days
    return [
      PracticeSession(
        surahName: 'An-Nas',
        score: 57,
        totalPossible: 60,
        ayahCount: 6,
        mode: PracticeMode.listenRepeat,
        completedAt: now.subtract(const Duration(hours: 3)),
      ),
      PracticeSession(
        surahName: 'Al-Ikhlas',
        score: 33,
        totalPossible: 40,
        ayahCount: 4,
        mode: PracticeMode.memorisationTest,
        completedAt: now.subtract(const Duration(days: 1, hours: 2)),
      ),
      PracticeSession(
        surahName: 'Al-Fatiha',
        score: 65,
        totalPossible: 70,
        ayahCount: 7,
        mode: PracticeMode.listenRepeat,
        completedAt: now.subtract(const Duration(days: 2)),
      ),
      PracticeSession(
        surahName: 'Al-Falaq',
        score: 48,
        totalPossible: 50,
        ayahCount: 5,
        mode: PracticeMode.turnTaking,
        completedAt: now.subtract(const Duration(days: 3)),
      ),
      PracticeSession(
        surahName: 'An-Nasr',
        score: 28,
        totalPossible: 30,
        ayahCount: 3,
        mode: PracticeMode.listenRepeat,
        completedAt: now.subtract(const Duration(days: 4)),
      ),
      PracticeSession(
        surahName: 'Al-Ikhlas',
        score: 30,
        totalPossible: 40,
        ayahCount: 4,
        mode: PracticeMode.memorisationTest,
        completedAt: now.subtract(const Duration(days: 5)),
      ),
      PracticeSession(
        surahName: 'Al-Fatiha',
        score: 60,
        totalPossible: 70,
        ayahCount: 7,
        mode: PracticeMode.listenRepeat,
        completedAt: now.subtract(const Duration(days: 6)),
      ),
    ];
  }

  void addSession(PracticeSession session) {
    state = [session, ...state].take(50).toList();
  }
}

final practiceHistoryProvider =
    NotifierProvider<PracticeHistoryNotifier, List<PracticeSession>>(
        PracticeHistoryNotifier.new);

// ---------------------------------------------------------------------------
// Derived providers
// ---------------------------------------------------------------------------

/// Session counts per weekday (Mon=0 … Sun=6) for the current week.
final weeklyActivityProvider = Provider<List<int>>((ref) {
  final history = ref.watch(practiceHistoryProvider);
  final now = DateTime.now();
  final weekStart = now.subtract(Duration(days: now.weekday - 1));
  final startDate =
      DateTime(weekStart.year, weekStart.month, weekStart.day);
  return List.generate(7, (day) {
    final date = startDate.add(Duration(days: day));
    return history
        .where((s) =>
            s.completedAt.year == date.year &&
            s.completedAt.month == date.month &&
            s.completedAt.day == date.day)
        .length;
  });
});

// ---------------------------------------------------------------------------
// UserStats — single derived object used across Dashboard, Profile, Progress
// ---------------------------------------------------------------------------

class UserStats {
  final int totalPoints;
  final int streak;
  final int totalSessions;
  final int totalAyahsRecited;

  const UserStats({
    required this.totalPoints,
    required this.streak,
    required this.totalSessions,
    required this.totalAyahsRecited,
  });
}

int _computeStreak(List<PracticeSession> history) {
  if (history.isEmpty) return 0;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  bool hasSession(DateTime date) => history.any((s) {
        final d = DateTime(
            s.completedAt.year, s.completedAt.month, s.completedAt.day);
        return d == date;
      });

  // Start counting from today; if today has no session, fall back to yesterday
  var checkDay = today;
  if (!hasSession(checkDay)) {
    checkDay = today.subtract(const Duration(days: 1));
    if (!hasSession(checkDay)) return 0;
  }

  int count = 0;
  while (hasSession(checkDay)) {
    count++;
    checkDay = checkDay.subtract(const Duration(days: 1));
  }
  return count;
}

final userStatsProvider = Provider<UserStats>((ref) {
  final history = ref.watch(practiceHistoryProvider);

  // Pull real streak / points from /api/gamification/points.
  // Response shape: { points: { total, weekly, monthly }, streak: { current, longest } }
  // Falls back to locally-computed values while loading or if offline.
  final gamAsync = ref.watch(gamificationPointsProvider);
  final gamData = gamAsync.valueOrNull;

  final pointsMap = gamData?['points'] as Map<String, dynamic>?;
  final streakMap = gamData?['streak'] as Map<String, dynamic>?;

  final totalPoints =
      (pointsMap?['total'] as int?) ??
      history.fold<int>(0, (sum, s) => sum + s.score);

  final streak =
      (streakMap?['current'] as int?) ??
      _computeStreak(history);

  return UserStats(
    totalPoints: totalPoints,
    streak: streak,
    totalSessions: history.length,
    totalAyahsRecited: history.fold<int>(0, (sum, s) => sum + s.ayahCount),
  );
});
