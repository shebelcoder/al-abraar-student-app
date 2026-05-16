import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/practice_history_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/guest_lock_screen.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(isGuestProvider)) {
      return Scaffold(
        backgroundColor: AppTheme.warmBackground,
        appBar: AppBar(title: const Text('My Progress')),
        body: const GuestLockScreen(
          featureName: 'Your Progress',
          description:
              'Sign in to track your Quran memorisation,\nskills and weekly activity.',
          icon: Icons.bar_chart_rounded,
        ),
      );
    }
    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      appBar: AppBar(
        title: const Text('My Progress'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _OverallCard(),
          SizedBox(height: 16),
          _WeeklyActivity(), // ConsumerWidget — reads weeklyActivityProvider
          SizedBox(height: 16),
          _SkillsBreakdown(),
          SizedBox(height: 16),
          _SurahProgress(),
          SizedBox(height: 80),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _OverallCard extends ConsumerWidget {
  const _OverallCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(userStatsProvider);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryGreen, Color(0xFF14532D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(100, 100),
                  painter: _RingPainter(progress: 0.18),
                ),
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '18%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Quran',
                      style: TextStyle(
                          color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Overall Progress',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                const _StatRow(label: 'Surahs Memorised', value: '12'),
                const SizedBox(height: 6),
                _StatRow(
                    label: 'Ayahs Recited',
                    value: '${stats.totalAyahsRecited}'),
                const SizedBox(height: 6),
                _StatRow(
                    label: 'Practice Sessions',
                    value: '${stats.totalSessions}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  const _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    final strokeWidth = 8.0;

    // Background ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}

// ---------------------------------------------------------------------------

class _WeeklyActivity extends ConsumerWidget {
  const _WeeklyActivity();

  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counts = ref.watch(weeklyActivityProvider);
    final totalSessions =
        ref.watch(practiceHistoryProvider).length;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'This Week',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$totalSessions session${totalSessions == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_days.length, (i) {
                final count = i < counts.length ? counts[i] : 0;
                final maxCount =
                    counts.isEmpty ? 1 : counts.reduce(math.max);
                final ratio = maxCount == 0 ? 0.0 : count / maxCount;
                final isToday = i == DateTime.now().weekday - 1;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: count > 0
                            ? AppTheme.primaryGreen
                            : AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      width: 28,
                      height: count == 0 ? 6 : 50 * ratio,
                      decoration: BoxDecoration(
                        color: isToday
                            ? AppTheme.primaryGreen
                            : count > 0
                                ? AppTheme.primaryGreen
                                    .withValues(alpha: 0.5)
                                : const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _days[i],
                      style: TextStyle(
                        fontSize: 10,
                        color: isToday
                            ? AppTheme.primaryGreen
                            : AppTheme.textSecondary,
                        fontWeight: isToday
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _SkillsBreakdown extends StatelessWidget {
  const _SkillsBreakdown();

  static const _skills = [
    _Skill('Tajweed', 0.82, Color(0xFF8B5CF6)),
    _Skill('Memorisation', 0.64, AppTheme.primaryGreen),
    _Skill('Recitation', 0.75, Color(0xFF0EA5E9)),
    _Skill('Arabic', 0.58, AppTheme.goldAccent),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Skills Breakdown',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 16),
          ..._skills.map((skill) => _SkillBar(skill: skill)),
        ],
      ),
    );
  }
}

class _SkillBar extends StatelessWidget {
  final _Skill skill;
  const _SkillBar({required this.skill});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skill.label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                ),
              ),
              Text(
                '${(skill.value * 100).round()}%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: skill.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: skill.value,
              minHeight: 8,
              backgroundColor: skill.color.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(skill.color),
            ),
          ),
        ],
      ),
    );
  }
}

class _Skill {
  final String label;
  final double value;
  final Color color;
  const _Skill(this.label, this.value, this.color);
}

// ---------------------------------------------------------------------------

class _SurahProgress extends StatelessWidget {
  const _SurahProgress();

  static const _surahs = [
    _SurahItem('Al-Fatiha (1)', 1.0, true),
    _SurahItem('An-Nas (114)', 1.0, true),
    _SurahItem('Al-Falaq (113)', 1.0, true),
    _SurahItem('Al-Ikhlas (112)', 1.0, true),
    _SurahItem('Al-Masad (111)', 1.0, true),
    _SurahItem('An-Nasr (110)', 1.0, true),
    _SurahItem('Al-Kafirun (109)', 0.85, false),
    _SurahItem('Al-Kausar (108)', 0.6, false),
    _SurahItem('Al-Maun (107)', 0.3, false),
    _SurahItem('Al-Baqarah (2)', 0.08, false),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Surah Progress',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 16),
          ..._surahs.map((s) => _SurahRow(item: s)),
        ],
      ),
    );
  }
}

class _SurahRow extends StatelessWidget {
  final _SurahItem item;
  const _SurahRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: item.completed
                  ? AppTheme.successGreen.withValues(alpha: 0.12)
                  : AppTheme.primaryGreen.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.completed
                  ? Icons.check_rounded
                  : Icons.menu_book_rounded,
              size: 14,
              color: item.completed
                  ? AppTheme.successGreen
                  : AppTheme.primaryGreen,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                      ),
                    ),
                    Text(
                      item.completed
                          ? 'Complete'
                          : '${(item.progress * 100).round()}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: item.completed
                            ? AppTheme.successGreen
                            : AppTheme.primaryGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: item.progress,
                    minHeight: 4,
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      item.completed
                          ? AppTheme.successGreen
                          : AppTheme.primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SurahItem {
  final String name;
  final double progress;
  final bool completed;
  const _SurahItem(this.name, this.progress, this.completed);
}
