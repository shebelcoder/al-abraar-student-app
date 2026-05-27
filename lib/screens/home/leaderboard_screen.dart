import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/student_providers.dart';
import '../../theme/app_theme.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _palette = [
  Color(0xFFF59E0B),
  Color(0xFF6366F1),
  Color(0xFF0EA5E9),
  AppTheme.primaryGreen,
  Color(0xFFF97316),
  Color(0xFF8B5CF6),
  Color(0xFF10B981),
  Color(0xFF6B7280),
];

Color _colorFromName(String name) =>
    _palette[name.hashCode.abs() % _palette.length];

String _initialsFrom(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.length >= 2) {
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
  return name.substring(0, min(2, name.length)).toUpperCase();
}

class _Player {
  final String name;
  final int points;
  final String initials;
  final Color color;
  final bool isMe;
  final int rank;

  const _Player({
    required this.name,
    required this.points,
    required this.initials,
    required this.color,
    required this.isMe,
    required this.rank,
  });
}

List<_Player> _parsePlayers(
    List<Map<String, dynamic>> data, String? myUserId) {
  return data.asMap().entries.map((e) {
    final j = e.value;
    final name = j['name']?.toString() ??
        j['studentName']?.toString() ??
        j['userName']?.toString() ??
        'Student';
    final points = (j['points'] as num?)?.toInt() ??
        (j['totalPoints'] as num?)?.toInt() ??
        0;
    final rank = (j['rank'] as num?)?.toInt() ?? (e.key + 1);
    final userId = j['userId']?.toString() ??
        j['id']?.toString() ??
        j['studentId']?.toString() ??
        '';
    return _Player(
      name: name,
      points: points,
      initials: _initialsFrom(name),
      color: _colorFromName(name),
      isMe: myUserId != null && userId.isNotEmpty && userId == myUserId,
      rank: rank,
    );
  }).toList();
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() =>
      _LeaderboardScreenState();
}

class _LeaderboardScreenState
    extends ConsumerState<LeaderboardScreen> {
  int _periodIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final currentUser = ref.watch(currentUserProvider);
    final myId = currentUser?.id;

    final periods = [
      l.leaderboard_periodWeekly,
      l.leaderboard_periodMonthly,
      l.leaderboard_periodAllTime,
    ];

    final asyncProviders = [
      ref.watch(leaderboardWeeklyProvider),
      ref.watch(leaderboardMonthlyProvider),
      ref.watch(leaderboardAllTimeProvider),
    ];

    final currentAsync = asyncProviders[_periodIndex];

    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      appBar: AppBar(title: Text(l.leaderboard_appBarTitle)),
      body: Column(
        children: [
          // Period selector
          Container(
            color: AppTheme.surfaceWhite,
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            child: Row(
              children: List.generate(periods.length, (i) {
                final selected = i == _periodIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _periodIndex = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.only(left: i > 0 ? 8 : 0),
                      padding:
                          const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppTheme.primaryGreen
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        periods[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? Colors.white
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          // Content
          Expanded(
            child: currentAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(
                    color: AppTheme.primaryGreen),
              ),
              error: (_, __) => _EmptyLeaderboard(l: l),
              data: (raw) {
                if (raw.isEmpty) return _EmptyLeaderboard(l: l);
                final players = _parsePlayers(raw, myId);
                final top3 = players.take(3).toList();
                final rest = players.skip(3).toList();
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (top3.length >= 3)
                      _Podium(top3: top3, l: l),
                    const SizedBox(height: 20),
                    ...rest.map((p) => _RankRow(player: p, l: l)),
                    const SizedBox(height: 80),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyLeaderboard extends StatelessWidget {
  final AppLocalizations l;
  const _EmptyLeaderboard({required this.l});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emoji_events_rounded,
                size: 40, color: AppTheme.primaryGreen),
          ),
          const SizedBox(height: 16),
          Text(
            l.leaderboard_podiumTitle,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark),
          ),
          const SizedBox(height: 6),
          const Text(
            'No rankings yet — start practising to earn points!',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.5),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Podium + rank rows (unchanged UI, adapted to new _Player model)
// ---------------------------------------------------------------------------

class _Podium extends StatelessWidget {
  final List<_Player> top3;
  final AppLocalizations l;
  const _Podium({required this.top3, required this.l});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryGreen, Color(0xFF14532D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            l.leaderboard_podiumTitle,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                  child: _PodiumSlot(
                      player: top3[1], rank: 2, height: 72)),
              Expanded(
                  child: _PodiumSlot(
                      player: top3[0], rank: 1, height: 92)),
              Expanded(
                  child: _PodiumSlot(
                      player: top3[2], rank: 3, height: 56)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PodiumSlot extends StatelessWidget {
  final _Player player;
  final int rank;
  final double height;

  const _PodiumSlot({
    required this.player,
    required this.rank,
    required this.height,
  });

  String get _medal =>
      rank == 1 ? '🥇' : rank == 2 ? '🥈' : '🥉';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(_medal, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 6),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: player.color.withValues(alpha: 0.9),
            shape: BoxShape.circle,
            border: rank == 1
                ? Border.all(color: AppTheme.goldAccent, width: 2.5)
                : null,
          ),
          child: Center(
            child: Text(
              player.initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          player.name.split(' ').first,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          '${player.points} pts',
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
        const SizedBox(height: 8),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RankRow extends StatelessWidget {
  final _Player player;
  final AppLocalizations l;

  const _RankRow({required this.player, required this.l});

  @override
  Widget build(BuildContext context) {
    final isMe = player.isMe;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isMe
            ? AppTheme.primaryGreen.withValues(alpha: 0.06)
            : AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: isMe
            ? Border.all(
                color: AppTheme.primaryGreen.withValues(alpha: 0.3))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '#${player.rank}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isMe
                    ? AppTheme.primaryGreen
                    : AppTheme.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: player.color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                player.initials,
                style: TextStyle(
                  color: player.color,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isMe
                  ? '${player.name} ${l.leaderboard_youSuffix}'
                  : player.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight:
                    isMe ? FontWeight.w700 : FontWeight.w600,
                color: isMe
                    ? AppTheme.primaryGreen
                    : AppTheme.textDark,
              ),
            ),
          ),
          Row(
            children: [
              const Text('⭐', style: TextStyle(fontSize: 13)),
              const SizedBox(width: 4),
              Text(
                '${player.points}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isMe
                      ? AppTheme.primaryGreen
                      : AppTheme.textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
