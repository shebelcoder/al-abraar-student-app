import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';

const _myRank = 4;

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int _periodIndex = 0;

  static const _data = [
    // Weekly
    [
      _Player('Yusuf Al-Rashid', 680, 'YR', Color(0xFFF59E0B)),
      _Player('Amina Karim', 615, 'AK', Color(0xFF6366F1)),
      _Player('Ibrahim Syed', 590, 'IS', Color(0xFF0EA5E9)),
      _Player('Abdullah Ahmad', 540, 'AA', AppTheme.primaryGreen),
      _Player('Maryam Hassan', 510, 'MH', Color(0xFFF97316)),
      _Player('Omar Farouq', 480, 'OF', Color(0xFF8B5CF6)),
      _Player('Khadija Malik', 460, 'KM', Color(0xFF10B981)),
      _Player('Bilal Hussain', 420, 'BH', Color(0xFF6B7280)),
    ],
    // Monthly
    [
      _Player('Amina Karim', 2840, 'AK', Color(0xFF6366F1)),
      _Player('Yusuf Al-Rashid', 2710, 'YR', Color(0xFFF59E0B)),
      _Player('Omar Farouq', 2500, 'OF', Color(0xFF8B5CF6)),
      _Player('Abdullah Ahmad', 2380, 'AA', AppTheme.primaryGreen),
      _Player('Ibrahim Syed', 2200, 'IS', Color(0xFF0EA5E9)),
      _Player('Bilal Hussain', 2100, 'BH', Color(0xFF6B7280)),
      _Player('Maryam Hassan', 1980, 'MH', Color(0xFFF97316)),
      _Player('Khadija Malik', 1860, 'KM', Color(0xFF10B981)),
    ],
    // All Time
    [
      _Player('Ibrahim Syed', 12400, 'IS', Color(0xFF0EA5E9)),
      _Player('Amina Karim', 11800, 'AK', Color(0xFF6366F1)),
      _Player('Yusuf Al-Rashid', 10900, 'YR', Color(0xFFF59E0B)),
      _Player('Abdullah Ahmad', 9600, 'AA', AppTheme.primaryGreen),
      _Player('Khadija Malik', 8800, 'KM', Color(0xFF10B981)),
      _Player('Omar Farouq', 8100, 'OF', Color(0xFF8B5CF6)),
      _Player('Maryam Hassan', 7400, 'MH', Color(0xFFF97316)),
      _Player('Bilal Hussain', 6900, 'BH', Color(0xFF6B7280)),
    ],
  ];

  List<_Player> get _players => _data[_periodIndex];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final periods = [
      l.leaderboard_periodWeekly,
      l.leaderboard_periodMonthly,
      l.leaderboard_periodAllTime,
    ];
    final top3 = _players.take(3).toList();
    final rest = _players.skip(3).toList();

    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      appBar: AppBar(title: Text(l.leaderboard_appBarTitle)),
      body: Column(
        children: [
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
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _Podium(top3: top3, l: l),
                const SizedBox(height: 20),
                ...rest.asMap().entries.map((e) {
                  final rank = e.key + 4;
                  final isMe = rank == _myRank;
                  return _RankRow(
                    player: e.value,
                    rank: rank,
                    isMe: isMe,
                    l: l,
                  );
                }),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _Podium extends StatelessWidget {
  final List<_Player> top3;
  final AppLocalizations l;
  const _Podium({required this.top3, required this.l});

  @override
  Widget build(BuildContext context) {
    if (top3.length < 3) return const SizedBox();
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
              Expanded(child: _PodiumSlot(player: top3[1], rank: 2, height: 72)),
              Expanded(child: _PodiumSlot(player: top3[0], rank: 1, height: 92)),
              Expanded(child: _PodiumSlot(player: top3[2], rank: 3, height: 56)),
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

  String get _medal => rank == 1 ? '🥇' : rank == 2 ? '🥈' : '🥉';

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

// ---------------------------------------------------------------------------

class _RankRow extends StatelessWidget {
  final _Player player;
  final int rank;
  final bool isMe;
  final AppLocalizations l;

  const _RankRow({
    required this.player,
    required this.rank,
    required this.isMe,
    required this.l,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              '#$rank',
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
                fontWeight: isMe ? FontWeight.w700 : FontWeight.w600,
                color: isMe ? AppTheme.primaryGreen : AppTheme.textDark,
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
                  color: isMe ? AppTheme.primaryGreen : AppTheme.textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _Player {
  final String name;
  final int points;
  final String initials;
  final Color color;
  const _Player(this.name, this.points, this.initials, this.color);
}
