import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _classReminders = true;
  bool _achievementAlerts = true;
  bool _teacherMessages = true;
  bool _practiceReminders = true;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.valueOrNull?.user;
    final name = (user?['name'] as String?) ?? 'Abdullah Ahmad';
    final email = (user?['email'] as String?) ?? 'student@alabraar.com';

    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Profile card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
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
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : 'A',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textDark)),
                      const SizedBox(height: 2),
                      Text(email,
                          style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => _showEditProfile(context, name, email),
                  child: const Text('Edit',
                      style: TextStyle(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),

          // Notifications
          _SectionLabel(label: 'Notifications'),
          _ToggleTile(
            icon: Icons.alarm_rounded,
            color: AppTheme.primaryGreen,
            title: 'Class Reminders',
            subtitle: 'Get notified 30 minutes before class',
            value: _classReminders,
            onChanged: (v) => setState(() => _classReminders = v),
          ),
          _ToggleTile(
            icon: Icons.emoji_events_rounded,
            color: AppTheme.goldAccent,
            title: 'Achievement Alerts',
            subtitle: 'Notify when you earn a badge',
            value: _achievementAlerts,
            onChanged: (v) => setState(() => _achievementAlerts = v),
          ),
          _ToggleTile(
            icon: Icons.chat_bubble_rounded,
            color: const Color(0xFF0EA5E9),
            title: 'Teacher Messages',
            subtitle: 'Notify on new messages from teachers',
            value: _teacherMessages,
            onChanged: (v) => setState(() => _teacherMessages = v),
          ),
          _ToggleTile(
            icon: Icons.self_improvement_rounded,
            color: const Color(0xFF8B5CF6),
            title: 'Practice Reminders',
            subtitle: 'Daily reminder to maintain your streak',
            value: _practiceReminders,
            onChanged: (v) => setState(() => _practiceReminders = v),
          ),

          // Account
          _SectionLabel(label: 'Account'),
          _ActionTile(
            icon: Icons.lock_outline_rounded,
            color: const Color(0xFF6366F1),
            title: 'Change Password',
            onTap: () => _showChangePassword(context),
          ),
          _ActionTile(
            icon: Icons.language_rounded,
            color: const Color(0xFF0EA5E9),
            title: 'Language',
            trailing: const Text('English',
                style: TextStyle(
                    color: AppTheme.textSecondary, fontSize: 14)),
            onTap: () => _showLanguagePicker(context),
          ),

          // About
          _SectionLabel(label: 'About'),
          _ActionTile(
            icon: Icons.info_outline_rounded,
            color: AppTheme.textSecondary,
            title: 'App Version',
            trailing: const Text('1.0.0',
                style: TextStyle(
                    color: AppTheme.textSecondary, fontSize: 14)),
            onTap: () {},
          ),
          _ActionTile(
            icon: Icons.privacy_tip_outlined,
            color: AppTheme.textSecondary,
            title: 'Privacy Policy',
            onTap: () => _showTextModal(context, 'Privacy Policy',
                _privacyText),
          ),
          _ActionTile(
            icon: Icons.description_outlined,
            color: AppTheme.textSecondary,
            title: 'Terms of Service',
            onTap: () =>
                _showTextModal(context, 'Terms of Service', _termsText),
          ),

          // Danger zone
          _SectionLabel(label: 'Account Actions'),
          _ActionTile(
            icon: Icons.logout_rounded,
            color: AppTheme.errorRed,
            title: 'Sign Out',
            isDestructive: true,
            onTap: () => _confirmLogout(context),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  static const _privacyText =
      'Al-Abraar collects only the information needed to provide your '
      'learning experience: your name, email address, and usage data such '
      'as attendance and practice scores.\n\n'
      'We do not sell or share your personal data with third parties. '
      'All data is encrypted in transit and at rest.\n\n'
      'You may request deletion of your account and data at any time by '
      'contacting support@alabraar.com.\n\n'
      'This policy was last updated: May 2026.';

  static const _termsText =
      'By using Al-Abraar you agree to use the app solely for lawful '
      'educational purposes.\n\n'
      'You must not share your login credentials or attempt to access '
      'another student\'s account.\n\n'
      'All course materials, recordings, and content within the app are '
      'the intellectual property of Al-Abraar Academy and may not be '
      'reproduced without written permission.\n\n'
      'Al-Abraar reserves the right to suspend accounts that violate '
      'these terms.\n\n'
      'Last updated: May 2026.';

  void _showLanguagePicker(BuildContext context) {
    const languages = ['English', 'Arabic', 'Urdu', 'French'];
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Language',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            ...languages.map((lang) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(lang,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500)),
                  trailing: lang == 'English'
                      ? const Icon(Icons.check_rounded,
                          color: AppTheme.primaryGreen)
                      : null,
                  onTap: () => Navigator.pop(context),
                )),
          ],
        ),
      ),
    );
  }

  void _showTextModal(
      BuildContext context, String title, String body) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (_, ctrl) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  controller: ctrl,
                  child: Text(
                    body,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                      height: 1.7,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfile(
      BuildContext context, String currentName, String currentEmail) {
    final nameCtrl = TextEditingController(text: currentName);
    final emailCtrl = TextEditingController(text: currentEmail);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 20, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Edit Profile',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 20),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: emailCtrl,
              decoration:
                  const InputDecoration(labelText: 'Email Address'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePassword(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 20, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Change Password',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 20),
            const TextField(
              obscureText: true,
              decoration:
                  InputDecoration(labelText: 'Current Password'),
            ),
            const SizedBox(height: 14),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'New Password'),
            ),
            const SizedBox(height: 14),
            const TextField(
              obscureText: true,
              decoration:
                  InputDecoration(labelText: 'Confirm New Password'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Update Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sign Out',
                style: TextStyle(color: AppTheme.errorRed)),
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

// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppTheme.textSecondary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surfaceWhite,
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark)),
        subtitle: Text(subtitle,
            style: const TextStyle(
                fontSize: 12, color: AppTheme.textSecondary)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppTheme.primaryGreen,
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final Widget? trailing;
  final bool isDestructive;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.onTap,
    this.trailing,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surfaceWhite,
      child: ListTile(
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
          title,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDestructive
                  ? AppTheme.errorRed
                  : AppTheme.textDark),
        ),
        trailing: trailing ??
            (isDestructive
                ? null
                : const Icon(Icons.chevron_right_rounded,
                    color: AppTheme.textSecondary)),
      ),
    );
  }
}
