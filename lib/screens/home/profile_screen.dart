import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/practice_history_provider.dart';
import '../../theme/app_theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final isGuest = authState.valueOrNull?.isGuest ?? false;
    final user = authState.valueOrNull?.user;
    final name = (user?['name'] as String?) ?? 'Abdullah Ahmad';
    final email = (user?['email'] as String?) ?? 'student@alabraar.com';
    final initials = name.isNotEmpty
        ? name.split(' ').map((w) => w[0]).take(2).join().toUpperCase()
        : 'AA';
    final stats = ref.watch(userStatsProvider);

    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      appBar: AppBar(
        title: const Text('My Profile'),
        automaticallyImplyLeading: false,
        actions: [
          if (!isGuest)
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.push('/home/settings'),
            ),
        ],
      ),
      body: ListView(
        children: [
          if (isGuest) ...[
            // Guest hero
            Container(
              color: AppTheme.surfaceWhite,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.textSecondary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_outline_rounded,
                        size: 40, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Guest User',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign in to access your profile,\ntrack progress, and connect with teachers.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.go('/login'),
                          child: const Text('Sign In'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.go('/register'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: AppTheme.primaryGreen),
                            foregroundColor: AppTheme.primaryGreen,
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                          child: const Text('Register'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ] else ...[
            // Signed-in header
            Container(
              color: AppTheme.surfaceWhite,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Student',
                      style: TextStyle(
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatItem(
                          label: 'Points',
                          value: '${stats.totalPoints}',
                          icon: '⭐'),
                      _divider(),
                      _StatItem(
                          label: 'Streak',
                          value: '${stats.streak} days',
                          icon: '🔥'),
                      _divider(),
                      _StatItem(
                          label: 'Badges', value: '12', icon: '🏅'),
                    ],
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          if (!isGuest) ...[
            _MenuSection(
              title: 'Learning',
              items: [
                _MenuItem(
                  icon: Icons.bar_chart_rounded,
                  label: 'My Progress',
                  color: AppTheme.primaryGreen,
                  onTap: () => context.push('/home/progress'),
                ),
                _MenuItem(
                  icon: Icons.military_tech_rounded,
                  label: 'My Badges',
                  color: AppTheme.goldAccent,
                  onTap: () => context.push('/home/badges'),
                ),
                _MenuItem(
                  icon: Icons.emoji_events_rounded,
                  label: 'Leaderboard',
                  color: const Color(0xFFF97316),
                  onTap: () => context.push('/home/leaderboard'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _MenuSection(
              title: 'Academic',
              items: [
                _MenuItem(
                  icon: Icons.event_available_rounded,
                  label: 'Attendance',
                  color: const Color(0xFF0EA5E9),
                  onTap: () => context.push('/home/attendance'),
                ),
                _MenuItem(
                  icon: Icons.grade_rounded,
                  label: 'Marks',
                  color: const Color(0xFF8B5CF6),
                  onTap: () => context.push('/home/marks'),
                ),
                _MenuItem(
                  icon: Icons.description_rounded,
                  label: 'Report Card',
                  color: const Color(0xFF10B981),
                  onTap: () => context.push('/home/report-card'),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          _MenuSection(
            title: 'Account',
            items: [
              _MenuItem(
                icon: Icons.help_outline_rounded,
                label: 'Help & Support',
                color: AppTheme.textSecondary,
                onTap: () => context.push('/home/help'),
              ),
              if (!isGuest)
                _MenuItem(
                  icon: Icons.logout_rounded,
                  label: 'Logout',
                  color: AppTheme.errorRed,
                  isDestructive: true,
                  onTap: () => _confirmLogout(context, ref),
                ),
            ],
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: AppTheme.errorRed),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(authStateProvider.notifier).logout();
      if (context.mounted) context.go('/login');
    }
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  const _StatItem(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppTheme.textDark,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
              fontSize: 12, color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}

Widget _divider() => Container(
      width: 1,
      height: 40,
      color: const Color(0xFFE5E7EB),
    );

class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;
  const _MenuSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          color: AppTheme.surfaceWhite,
          child: Column(
            children: items
                .asMap()
                .entries
                .map((e) => Column(
                      children: [
                        e.value,
                        if (e.key < items.length - 1)
                          const Divider(
                            height: 1,
                            indent: 56,
                            color: Color(0xFFF3F4F6),
                          ),
                      ],
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDestructive;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isDestructive ? AppTheme.errorRed : AppTheme.textDark,
        ),
      ),
      trailing: isDestructive
          ? null
          : const Icon(Icons.chevron_right_rounded,
              color: AppTheme.textSecondary),
    );
  }
}
