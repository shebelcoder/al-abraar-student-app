import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

class MainShell extends ConsumerWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static const _tabs = [
    _TabItem(icon: Icons.home_rounded, label: 'Home', path: '/home/dashboard'),
    _TabItem(
        icon: Icons.record_voice_over_rounded,
        label: 'Practice',
        path: '/home/practice'),
    _TabItem(
        icon: Icons.calendar_today_rounded,
        label: 'Schedule',
        path: '/home/schedule'),
    _TabItem(
        icon: Icons.chat_bubble_rounded,
        label: 'Messages',
        path: '/home/messages'),
    _TabItem(
        icon: Icons.person_rounded, label: 'Profile', path: '/home/profile'),
  ];

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    for (var i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGuest = ref.watch(isGuestProvider);
    final selected = _selectedIndex(context);
    return Scaffold(
      body: Column(
        children: [
          if (isGuest) const _GuestBanner(),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surfaceWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_tabs.length, (i) {
                final tab = _tabs[i];
                final isSelected = i == selected;
                return GestureDetector(
                  onTap: () => context.go(tab.path),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryGreen.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          tab.icon,
                          size: 24,
                          color: isSelected
                              ? AppTheme.primaryGreen
                              : AppTheme.textSecondary,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          tab.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: isSelected
                                ? AppTheme.primaryGreen
                                : AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final String label;
  final String path;
  const _TabItem(
      {required this.icon, required this.label, required this.path});
}

class _GuestBanner extends StatelessWidget {
  const _GuestBanner();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.goldAccent.withValues(alpha: 0.12),
      child: InkWell(
        onTap: () => context.go('/login'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          child: Row(
            children: [
              const Icon(Icons.lock_outline_rounded,
                  size: 15, color: AppTheme.goldAccent),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Guest mode — sign in to save your progress',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 2),
              const Icon(Icons.chevron_right_rounded,
                  size: 16, color: AppTheme.primaryGreen),
            ],
          ),
        ),
      ),
    );
  }
}
