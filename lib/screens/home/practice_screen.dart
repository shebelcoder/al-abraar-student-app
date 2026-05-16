import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/practice_history_provider.dart';
import '../../screens/practice/session_setup_screen.dart';
import '../../theme/app_theme.dart';

class PracticeScreen extends ConsumerWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGuest = ref.watch(isGuestProvider);
    final history = ref.watch(practiceHistoryProvider);
    final recent = history.take(5).toList();

    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      appBar: AppBar(
        title: const Text('Quran Practice'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Choose Practice Mode',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 12),

          // 3 active modes
          ...PracticeMode.values.map(
            (mode) => _ActiveModeCard(
              mode: mode,
              isGuest: isGuest,
            ),
          ),

          // Coming-soon mode
          const _ComingSoonModeCard(
            icon: Icons.sort_rounded,
            title: 'Order Quiz',
            description: 'Arrange the ayahs in the correct order',
            color: Color(0xFFF97316),
          ),

          const SizedBox(height: 28),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Practice',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              if (history.isNotEmpty)
                Text(
                  '${history.length} sessions',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          if (recent.isEmpty)
            _EmptyHistory(isGuest: isGuest)
          else
            ...recent.map((s) => _RecentSessionCard(session: s)),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _ActiveModeCard extends StatelessWidget {
  final PracticeMode mode;
  final bool isGuest;
  const _ActiveModeCard({required this.mode, required this.isGuest});

  void _showGuestSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.mic_rounded,
                  color: AppTheme.primaryGreen, size: 32),
            ),
            const SizedBox(height: 16),
            const Text(
              'Sign in to Practice',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create a free account to start AI-powered\nQuran practice sessions.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                  height: 1.5),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/login');
                },
                child: const Text('Sign In'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/register');
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.primaryGreen),
                  foregroundColor: AppTheme.primaryGreen,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Create Account'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => isGuest
          ? _showGuestSheet(context)
          : context.push('/practice/setup'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: mode.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(mode.icon, color: mode.color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mode.title,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mode.description,
                    style: const TextStyle(
                        fontSize: 13, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
            if (isGuest)
              const Icon(Icons.lock_rounded,
                  size: 18, color: AppTheme.textSecondary)
            else
              const Icon(Icons.chevron_right_rounded,
                  color: AppTheme.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _ComingSoonModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  const _ComingSoonModeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon,
                color: color.withValues(alpha: 0.4), size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textSecondary),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Soon',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textSecondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                      fontSize: 13,
                      color:
                          AppTheme.textSecondary.withValues(alpha: 0.7)),
                ),
              ],
            ),
          ),
          Icon(Icons.lock_outline_rounded,
              size: 18,
              color: AppTheme.textSecondary.withValues(alpha: 0.5)),
        ],
      ),
    );
  }
}

class _RecentSessionCard extends StatelessWidget {
  final PracticeSession session;
  const _RecentSessionCard({required this.session});

  Color get _gradeColor {
    if (session.accuracy >= 0.90) return AppTheme.successGreen;
    if (session.accuracy >= 0.75) return AppTheme.goldAccent;
    return AppTheme.errorRed;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: session.mode.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(session.mode.icon,
                color: session.mode.color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.surahName,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                      fontSize: 14),
                ),
                Text(
                  '${session.mode.title} · ${session.dateLabel}',
                  style: const TextStyle(
                      fontSize: 12, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _gradeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${session.accuracyPercent}%',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: _gradeColor,
                      fontSize: 13),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                session.grade,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _gradeColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  final bool isGuest;
  const _EmptyHistory({required this.isGuest});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          const Text('📖', style: TextStyle(fontSize: 32)),
          const SizedBox(height: 10),
          const Text(
            'No sessions yet',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppTheme.textDark),
          ),
          const SizedBox(height: 4),
          Text(
            isGuest
                ? 'Sign in to track your practice history'
                : 'Complete a session above to see your history here',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 13, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}
