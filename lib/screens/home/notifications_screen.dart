import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/notifications_provider.dart';
import '../../theme/app_theme.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final notifsAsync = ref.watch(notificationsProvider);
    final notifs = notifsAsync.valueOrNull ?? [];
    final unread = notifs.where((n) => !n.read).length;

    final groupLabels = {
      'Today': l.notifications_groupToday,
      'Yesterday': l.notifications_groupYesterday,
      'Earlier': l.notifications_groupEarlier,
    };
    final groups = ['Today', 'Yesterday', 'Earlier'];

    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      appBar: AppBar(
        title: Row(
          children: [
            Text(l.notifications_appBarTitle),
            if (unread > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.errorRed,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$unread',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (unread > 0)
            TextButton(
              onPressed: () =>
                  ref.read(notificationsProvider.notifier).markAllRead(),
              child: Text(
                l.notifications_markAllRead,
                style: const TextStyle(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
      body: notifsAsync.isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifs.isEmpty
              ? _Empty(l: l)
              : ListView(
                  children: [
                    for (final group in groups)
                      if (notifs.any((n) => n.group == group)) ...[
                        _GroupHeader(label: groupLabels[group] ?? group),
                        ...notifs
                            .where((n) => n.group == group)
                            .map((n) => _NotifTile(
                                  notif: n,
                                  onTap: () => ref
                                      .read(notificationsProvider.notifier)
                                      .markRead(n.id),
                                )),
                      ],
                    const SizedBox(height: 80),
              ],
            ),
    );
  }
}

// ---------------------------------------------------------------------------

class _GroupHeader extends StatelessWidget {
  final String label;
  const _GroupHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppTheme.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final AppNotification notif;
  final VoidCallback onTap;
  const _NotifTile({required this.notif, required this.onTap});

  Color get _accent {
    switch (notif.type) {
      case NotifType.reminder:
        return AppTheme.primaryGreen;
      case NotifType.message:
        return const Color(0xFF0EA5E9);
      case NotifType.achievement:
        return AppTheme.goldAccent;
      case NotifType.grade:
        return const Color(0xFF8B5CF6);
      case NotifType.announcement:
        return AppTheme.warningOrange;
    }
  }

  IconData get _icon {
    switch (notif.type) {
      case NotifType.reminder:
        return Icons.alarm_rounded;
      case NotifType.message:
        return Icons.chat_bubble_rounded;
      case NotifType.achievement:
        return Icons.emoji_events_rounded;
      case NotifType.grade:
        return Icons.grade_rounded;
      case NotifType.announcement:
        return Icons.campaign_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notif.read
              ? AppTheme.surfaceWhite
              : _accent.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: notif.read
              ? null
              : Border(left: BorderSide(color: _accent, width: 3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(_icon, color: _accent, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notif.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: notif.read
                                ? FontWeight.w600
                                : FontWeight.w700,
                            color: AppTheme.textDark,
                          ),
                        ),
                      ),
                      Text(
                        notif.time,
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notif.body,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (!notif.read)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(left: 8, top: 4),
                decoration: BoxDecoration(
                    color: _accent, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final AppLocalizations l;
  const _Empty({required this.l});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_none_rounded,
                size: 40, color: AppTheme.primaryGreen),
          ),
          const SizedBox(height: 16),
          Text(l.notifications_emptyTitle,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark)),
          const SizedBox(height: 6),
          Text(l.notifications_emptyBody,
              style: const TextStyle(
                  fontSize: 14, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
