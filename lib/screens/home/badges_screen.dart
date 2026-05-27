import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/student_providers.dart';
import '../../theme/app_theme.dart';

// ---------------------------------------------------------------------------
// Local badge catalog (emoji, color, localized name/description)
// earned status is populated from the gamification API
// ---------------------------------------------------------------------------



class _Badge {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final Color color;
  final bool earned;

  const _Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.color,
    required this.earned,
  });
}

/// Build the full badge list using localized strings for name/description,
/// and [earnedIds] from the API to mark which ones are unlocked.
List<_Badge> _buildBadges(AppLocalizations l, Set<String> earnedIds) {
  bool isEarned(String id) {
    final lId = id.toLowerCase();
    return earnedIds.any((e) {
      final le = e.toLowerCase();
      return le == lId ||
          le.replaceAll(' ', '-') == lId ||
          le.replaceAll('-', ' ') == lId.replaceAll('-', ' ');
    });
  }

  return [
    _Badge(
        id: 'first-step',
        name: l.badges_firstStepName,
        description: l.badges_firstStepDesc,
        emoji: '🌟',
        color: const Color(0xFFF59E0B),
        earned: isEarned('first-step')),
    _Badge(
        id: 'streak',
        name: l.badges_streakName,
        description: l.badges_streakDesc,
        emoji: '🔥',
        color: const Color(0xFFEF4444),
        earned: isEarned('streak')),
    _Badge(
        id: 'al-fatiha',
        name: l.badges_alfatihaName,
        description: l.badges_alfatihaDesc,
        emoji: '📖',
        color: AppTheme.primaryGreen,
        earned: isEarned('al-fatiha')),
    _Badge(
        id: 'tajweed-star',
        name: l.badges_tajweedStarName,
        description: l.badges_tajweedStarDesc,
        emoji: '✨',
        color: const Color(0xFF8B5CF6),
        earned: isEarned('tajweed-star')),
    _Badge(
        id: 'early-bird',
        name: l.badges_earlyBirdName,
        description: l.badges_earlyBirdDesc,
        emoji: '🌅',
        color: const Color(0xFF0EA5E9),
        earned: isEarned('early-bird')),
    _Badge(
        id: 'consistent',
        name: l.badges_consistentName,
        description: l.badges_consistentDesc,
        emoji: '📅',
        color: AppTheme.successGreen,
        earned: isEarned('consistent')),
    _Badge(
        id: 'quick-learner',
        name: l.badges_quickLearnerName,
        description: l.badges_quickLearnerDesc,
        emoji: '⚡',
        color: const Color(0xFFF97316),
        earned: isEarned('quick-learner')),
    _Badge(
        id: 'team-player',
        name: l.badges_teamPlayerName,
        description: l.badges_teamPlayerDesc,
        emoji: '🤝',
        color: const Color(0xFF6366F1),
        earned: isEarned('team-player')),
    _Badge(
        id: 'streak-30',
        name: l.badges_streak30Name,
        description: l.badges_streak30Desc,
        emoji: '🏆',
        color: const Color(0xFF6B7280),
        earned: isEarned('streak-30')),
    _Badge(
        id: 'juz-amma',
        name: l.badges_juzAmmaName,
        description: l.badges_juzAmmaDesc,
        emoji: '📚',
        color: const Color(0xFF6B7280),
        earned: isEarned('juz-amma')),
    _Badge(
        id: 'hafiz-path',
        name: l.badges_hafizPathName,
        description: l.badges_hafizPathDesc,
        emoji: '🌙',
        color: const Color(0xFF6B7280),
        earned: isEarned('hafiz-path')),
    _Badge(
        id: 'perfect-score',
        name: l.badges_perfectScoreName,
        description: l.badges_perfectScoreDesc,
        emoji: '💯',
        color: const Color(0xFF6B7280),
        earned: isEarned('perfect-score')),
    _Badge(
        id: 'night-owl',
        name: l.badges_nightOwlName,
        description: l.badges_nightOwlDesc,
        emoji: '🦉',
        color: const Color(0xFF6B7280),
        earned: isEarned('night-owl')),
    _Badge(
        id: 'scholar',
        name: l.badges_scholarName,
        description: l.badges_scholarDesc,
        emoji: '🎓',
        color: const Color(0xFF6B7280),
        earned: isEarned('scholar')),
  ];
}

/// Extract earned badge IDs/names from the API response list.
Set<String> _earnedSetFromApi(List<Map<String, dynamic>> apiData) {
  final result = <String>{};
  for (final b in apiData) {
    final earnedFlag = b['earned'] as bool?;
    final earnedAt = b['earnedAt'];
    final isEarned = earnedFlag == true || earnedAt != null;
    if (!isEarned) continue;

    final id = b['id']?.toString() ??
        b['badgeId']?.toString() ??
        b['slug']?.toString() ??
        '';
    final name = b['name']?.toString() ?? '';
    if (id.isNotEmpty) result.add(id);
    if (name.isNotEmpty) result.add(name);
  }
  return result;
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class BadgesScreen extends ConsumerWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final badgesAsync = ref.watch(gamificationBadgesProvider);

    return badgesAsync.when(
      loading: () => _buildScaffold(
          context, l, _buildBadges(l, {})),
      error: (_, __) => _buildScaffold(
          context, l, _buildBadges(l, {})),
      data: (apiData) {
        final earnedIds = _earnedSetFromApi(apiData);
        return _buildScaffold(
            context, l, _buildBadges(l, earnedIds));
      },
    );
  }

  Scaffold _buildScaffold(
      BuildContext context, AppLocalizations l, List<_Badge> badges) {
    final earned = badges.where((b) => b.earned).toList();
    final locked = badges.where((b) => !b.earned).toList();
    final earnedCount = earned.length;
    final lockedCount = locked.length;

    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      appBar: AppBar(title: Text(l.badges_appBarTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header banner
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
            itemBuilder: (_, i) =>
                _BadgeCard(badge: earned[i], l: l),
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
            itemBuilder: (_, i) =>
                _BadgeCard(badge: locked[i], l: l),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets (unchanged UI)
// ---------------------------------------------------------------------------

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
                badge.earned
                    ? l.badges_statusEarned
                    : l.badges_statusLocked,
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
