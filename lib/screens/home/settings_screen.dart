import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/onboarding_provider.dart';
import '../../services/onboarding_prefs.dart';
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
    final l = AppLocalizations.of(context);
    final authState = ref.watch(authStateProvider);
    final user = authState.valueOrNull?.user;
    final name = user?.name ?? 'Abdullah Ahmad';
    final email = user?.email ?? 'student@alabraar.com';
    final currentLocale = ref.watch(localeProvider);

    // Native language names — never translated
    final currentLangName = supportedLocaleNames.entries
        .firstWhere((e) => e.value == currentLocale,
            orElse: () => supportedLocaleNames.entries.first)
        .key;

    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      appBar: AppBar(title: Text(l.settings_appBarTitle)),
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
                  onPressed: () => _showEditProfile(context, name, email, l),
                  child: Text(l.settings_editButton,
                      style: const TextStyle(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),

          // Notifications
          _SectionLabel(label: l.settings_sectionNotifications),
          _ToggleTile(
            icon: Icons.alarm_rounded,
            color: AppTheme.primaryGreen,
            title: l.settings_classRemindersTitle,
            subtitle: l.settings_classRemindersSubtitle,
            value: _classReminders,
            onChanged: (v) => setState(() => _classReminders = v),
          ),
          _ToggleTile(
            icon: Icons.emoji_events_rounded,
            color: AppTheme.goldAccent,
            title: l.settings_achievementAlertsTitle,
            subtitle: l.settings_achievementAlertsSubtitle,
            value: _achievementAlerts,
            onChanged: (v) => setState(() => _achievementAlerts = v),
          ),
          _ToggleTile(
            icon: Icons.chat_bubble_rounded,
            color: const Color(0xFF0EA5E9),
            title: l.settings_teacherMessagesTitle,
            subtitle: l.settings_teacherMessagesSubtitle,
            value: _teacherMessages,
            onChanged: (v) => setState(() => _teacherMessages = v),
          ),
          _ToggleTile(
            icon: Icons.self_improvement_rounded,
            color: const Color(0xFF8B5CF6),
            title: l.settings_practiceRemindersTitle,
            subtitle: l.settings_practiceRemindersSubtitle,
            value: _practiceReminders,
            onChanged: (v) => setState(() => _practiceReminders = v),
          ),

          // Account
          _SectionLabel(label: l.settings_sectionAccount),
          _ActionTile(
            icon: Icons.lock_outline_rounded,
            color: const Color(0xFF6366F1),
            title: l.settings_changePassword,
            onTap: () => _showChangePassword(context, l),
          ),
          _ActionTile(
            icon: Icons.language_rounded,
            color: const Color(0xFF0EA5E9),
            title: l.settings_language,
            trailing: Text(currentLangName,
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 14)),
            onTap: () => _showLanguagePicker(context, l),
          ),

          // About
          _SectionLabel(label: l.settings_sectionAbout),
          _ActionTile(
            icon: Icons.info_outline_rounded,
            color: AppTheme.textSecondary,
            title: l.settings_appVersion,
            trailing: const Text('1.0.0',
                style: TextStyle(
                    color: AppTheme.textSecondary, fontSize: 14)),
            onTap: () {},
          ),
          _ActionTile(
            icon: Icons.privacy_tip_outlined,
            color: AppTheme.textSecondary,
            title: l.settings_privacyPolicy,
            onTap: () => _showTextModal(
                context, l.settings_privacyPolicy, l.settings_privacyBody),
          ),
          _ActionTile(
            icon: Icons.description_outlined,
            color: AppTheme.textSecondary,
            title: l.settings_termsOfService,
            onTap: () => _showTextModal(
                context, l.settings_termsOfService, l.settings_termsBody),
          ),
          _ActionTile(
            icon: Icons.auto_awesome_rounded,
            color: AppTheme.primaryGreen,
            title: l.settings_replayIntro,
            onTap: () async {
              await OnboardingPrefs.clearSeen();
              // Update in-memory provider so router redirect re-evaluates.
              ref.read(onboardingSeenProvider.notifier).state = false;
              if (context.mounted) context.go('/onboarding');
            },
          ),

          // Danger zone
          _SectionLabel(label: l.settings_sectionAccountActions),
          _ActionTile(
            icon: Icons.logout_rounded,
            color: AppTheme.errorRed,
            title: l.settings_signOut,
            isDestructive: true,
            onTap: () => _confirmLogout(context, l),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, AppLocalizations l) {
    final currentLocale = ref.read(localeProvider);
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
            Text(l.settings_selectLanguage,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            ...supportedLocaleNames.entries.map((entry) {
              final isSelected = entry.value == currentLocale;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(entry.key, // native name, never translated
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500)),
                trailing: isSelected
                    ? const Icon(Icons.check_rounded,
                        color: AppTheme.primaryGreen)
                    : null,
                onTap: () {
                  ref
                      .read(localeProvider.notifier)
                      .setLocale(entry.value);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showTextModal(BuildContext context, String title, String body) {
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
                      fontSize: 18, fontWeight: FontWeight.w800)),
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
      BuildContext context, String currentName, String currentEmail, AppLocalizations l) {
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
            Text(l.settings_editProfileTitle,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 20),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(labelText: l.settings_fullNameLabel),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(labelText: l.settings_emailLabel),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l.common_save),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePassword(BuildContext context, AppLocalizations l) {
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
            Text(l.settings_changePasswordTitle,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                  labelText: l.settings_currentPasswordLabel),
            ),
            const SizedBox(height: 14),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: l.settings_newPasswordLabel),
            ),
            const SizedBox(height: 14),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                  labelText: l.settings_confirmNewPasswordLabel),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l.settings_updatePassword),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, AppLocalizations l) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: Text(l.settings_signOutTitle),
        content: Text(l.settings_signOutBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.settings_signOut,
                style: const TextStyle(color: AppTheme.errorRed)),
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
