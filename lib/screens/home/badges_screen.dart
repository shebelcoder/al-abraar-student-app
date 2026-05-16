import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    final badges = [
      // Earned
      _Badge(l.badges_firstStepName, l.badges_firstStepDesc, '🌟', const Color(0xFFF59E0B), true),
      _Badge(l.badges_streakName, l.badges_streakDesc, '🔥', const Color(0xFFEF4444), true),
      _Badge(l.badges_alfatihaName, l.badges_alfatihaDesc, '📖', AppTheme.primaryGreen, true),
      _Badge(l.badges_tajweedStarName, l.badges_tajweedStarDesc, '✨', const Color(0xFF8B5CF6), true),
      _Badge(l.badges_earlyBirdName, l.badges_earlyBirdDesc, '🌅', const Color(0xFF0EA5E9), true),
      _Badge(l.badges_consistentName, l.badges_consistentDesc, '📅', AppTheme.successGreen, true),
      _Badge(l.badges_quickLearnerName, l.badges_quickLearnerDesc, '⚡', const Color(0xFFF97316), true),
      _Badge(l.badges_teamPlayerName, l.badges_teamPlayerDesc, '🤝', const Color(0xFF6366F1), true),
      // Locked
      _Badge(l.badges_streak30Name, l.badges_streak30Desc, '🏆', const Color(0xFF6B7280), false),
      _Badge(l.badges_juzAmmaName, l.badges_juzAmmaDesc, '📚', const Color(0xFF6B7280), false),
      _Badge(l.badges_hafizPathName, l.badges_hafizPathDesc, '🌙', const Color(0xFF6B7280), false),
      _Badge(l.badges_perfectScoreName, l.badges_perfectScoreDesc, '💯', const Color(0xFF6B7280), false),
      _Badge(l.badges_nightOwlName, l.badges_nightOwlDesc, '🦉', const Color(0xFF6B7280), false),
      _Badge(l.badges_scholarName, l.badges_scholarDesc, '🎓', const Color(0xFF6B7280), false),
    ];

    final earnedCount = badges.where((b) => b.earned).length;
    final earned = badges.where((b) => b.earned).toList();
    final locked = badges.where((b) => !b.earned).toList();
    final lockedCount = badges.length - earnedCount;

    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      appBar: AppBar(title: Text(l.badges_appBarTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.goldAccent, Color(0xFFFBBF24)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.goldAccent.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Text('🏅', style: TextStyle(fontSize: 44)),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.badges_earnedCount(earnedCount),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      l.badges_remaining(lockedCount),
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: l.badges_sectionEarned, count: null),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: earned.length,
            itemBuilder: (_, i) => _BadgeCard(badge: earned[i], l: l),
          ),
          const SizedBox(height: 24),
          _SectionHeader(
              title: l.badges_sectionLocked,
              count: l.badges_remaining(lockedCount)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: locked.length,
            itemBuilder: (_, i) => _BadgeCard(badge: locked[i], l: l),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? count;
  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        if (count != null) ...[
          const SizedBox(width: 8),
          Text(
            count!,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final _Badge badge;
  final AppLocalizations l;
  const _BadgeCard({required this.badge, required this.l});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetail(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: badge.earned
                    ? badge.color.withValues(alpha: 0.12)
                    : const Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  badge.earned ? badge.emoji : '🔒',
                  style: TextStyle(
                      fontSize: badge.earned ? 24 : 20),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                badge.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: badge.earned
                      ? AppTheme.textDark
                      : AppTheme.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(24)),
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
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: badge.earned
                    ? badge.color.withValues(alpha: 0.12)
                    : const Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  badge.earned ? badge.emoji : '🔒',
                  style: TextStyle(
                      fontSize: badge.earned ? 32 : 28),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              badge.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              badge.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: badge.earned
                    ? AppTheme.successGreen.withValues(alpha: 0.1)
                    : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                badge.earned ? l.badges_statusEarned : l.badges_statusLocked,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: badge.earned
                      ? AppTheme.successGreen
                      : AppTheme.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge {
  final String name;
  final String description;
  final String emoji;
  final Color color;
  final bool earned;
  const _Badge(
      this.name, this.description, this.emoji, this.color, this.earned);
}
