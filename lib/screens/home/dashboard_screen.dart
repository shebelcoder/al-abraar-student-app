import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notifications_provider.dart';
import '../../providers/practice_history_provider.dart';
import '../../theme/app_theme.dart';

const _mockName = 'Abdullah';

class _LiveSession {
  final String teacherName;
  final String subject;
  final String teacherInitials;
  final Color teacherColor;
  const _LiveSession({
    required this.teacherName,
    required this.subject,
    required this.teacherInitials,
    required this.teacherColor,
  });
}

const _mockLiveSession = _LiveSession(
  teacherName: 'Sheikh Ahmed',
  subject: 'Quran Recitation — Level 2',
  teacherInitials: 'SA',
  teacherColor: Color(0xFF166534),
);

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String _getStudentName() {
    final user = ref.read(authStateProvider).valueOrNull?.user;
    final name = user?.name;
    if (name != null && name.isNotEmpty) return name.split(' ').first;
    return _mockName;
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final name = _getStudentName();
    final stats = ref.watch(userStatsProvider);

    final actions = [
      _ActionItem(icon: Icons.mic_rounded,            label: l.dashboard_action_aiPractice,  color: const Color(0xFF8B5CF6), route: '/practice/setup'),
      _ActionItem(icon: Icons.calendar_today_rounded,  label: l.dashboard_action_mySchedule,  color: const Color(0xFF3B82F6), route: '/home/schedule'),
      _ActionItem(icon: Icons.bar_chart_rounded,       label: l.dashboard_action_myProgress,  color: AppTheme.primaryGreen,   route: '/home/progress'),
      _ActionItem(icon: Icons.event_available_rounded, label: l.dashboard_action_attendance,   color: const Color(0xFF0EA5E9), route: '/home/attendance'),
      _ActionItem(icon: Icons.chat_bubble_rounded,     label: l.dashboard_action_messages,    color: const Color(0xFF6366F1), route: '/home/messages'),
      _ActionItem(icon: Icons.emoji_events_rounded,    label: l.dashboard_action_leaderboard, color: AppTheme.goldAccent,     route: '/home/leaderboard'),
    ];

    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      body: RefreshIndicator(
        color: AppTheme.primaryGreen,
        onRefresh: _refresh,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: AppTheme.surfaceWhite,
              elevation: 0,
              titleSpacing: 16,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.dashboard_greeting,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined,
                            color: AppTheme.textDark),
                        onPressed: () =>
                            context.push('/home/notifications'),
                      ),
                      if (ref.watch(unreadCountProvider) > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: AppTheme.errorRed,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${ref.watch(unreadCountProvider)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'A',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _LiveNowBanner(session: _mockLiveSession, l: l),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _StreakCard(streak: stats.streak, l: l)),
                      const SizedBox(width: 12),
                      Expanded(child: _PointsCard(points: stats.totalPoints, l: l)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _TodaysClassCard(l: l),
                  const SizedBox(height: 20),
                  Text(
                    l.dashboard_quickActions,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _QuickActionsGrid(actions: actions),
                  const SizedBox(height: 80),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _StreakCard extends StatelessWidget {
  final int streak;
  final AppLocalizations l;
  const _StreakCard({required this.streak, required this.l});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFFF9A3C)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B35).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 22)),
          const SizedBox(height: 8),
          Text(
            l.dashboard_streakDays(streak),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          Text(
            l.dashboard_streak,
            style: const TextStyle(fontSize: 13, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _PointsCard extends StatelessWidget {
  final int points;
  final AppLocalizations l;
  const _PointsCard({required this.points, required this.l});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('⭐', style: TextStyle(fontSize: 22)),
          const SizedBox(height: 8),
          Text(
            '$points',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          Text(
            l.dashboard_points,
            style: const TextStyle(fontSize: 13, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _TodaysClassCard extends StatelessWidget {
  final AppLocalizations l;
  const _TodaysClassCard({required this.l});

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
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    l.dashboard_todaysClass,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Quran Recitation with Sheikh Ahmed at 5:00 PM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 14, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text(
                      l.dashboard_startsIn,
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => context.go('/home/schedule'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryGreen,
              minimumSize: const Size(64, 40),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 13),
            ),
            child: Text(l.dashboard_join),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  final List<_ActionItem> actions;
  const _QuickActionsGrid({required this.actions});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return GestureDetector(
          onTap: () => context.go(action.route),
          child: Container(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: action.color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child:
                      Icon(action.icon, color: action.color, size: 24),
                ),
                const SizedBox(height: 10),
                Text(
                  action.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String label;
  final Color color;
  final String route;
  const _ActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.route,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Live Now Banner
// ─────────────────────────────────────────────────────────────────────────────

class _LiveNowBanner extends StatelessWidget {
  final _LiveSession session;
  final AppLocalizations l;
  const _LiveNowBanner({required this.session, required this.l});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/live/viewer', extra: {
        'teacherName': session.teacherName,
        'subject': session.subject,
        'teacherInitials': session.teacherInitials,
        'teacherColor': session.teacherColor.toARGB32(),
      }),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7F1D1D), Color(0xFFDC2626)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFDC2626).withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              l.live_badge,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.teacherName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    session.subject,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                l.dashboard_join,
                style: const TextStyle(
                  color: Color(0xFFDC2626),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
