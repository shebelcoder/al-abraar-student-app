import 'package:al_abraar_core/al_abraar_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_providers.dart';
import 'auth_provider.dart';

enum NotifType { reminder, message, achievement, grade, announcement }

class AppNotification {
  final String id;
  final NotifType type;
  final String title;
  final String body;
  final String time;
  final String group;
  final bool read;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    required this.group,
    required this.read,
  });

  AppNotification copyWith({bool? read}) => AppNotification(
        id: id,
        type: type,
        title: title,
        body: body,
        time: time,
        group: group,
        read: read ?? this.read,
      );

  static NotifType _typeFrom(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'message':
        return NotifType.message;
      case 'achievement':
      case 'badge':
        return NotifType.achievement;
      case 'grade':
      case 'mark':
        return NotifType.grade;
      case 'announcement':
        return NotifType.announcement;
      default:
        return NotifType.reminder;
    }
  }

  static String _groupFrom(String? createdAt) {
    if (createdAt == null) return 'Earlier';
    final dt = DateTime.tryParse(createdAt)?.toLocal();
    if (dt == null) return 'Earlier';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return 'Earlier';
  }

  static String _timeFrom(String? createdAt) {
    if (createdAt == null) return '';
    final dt = DateTime.tryParse(createdAt)?.toLocal();
    if (dt == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) {
      final h = dt.hour;
      final m = dt.minute.toString().padLeft(2, '0');
      final period = h >= 12 ? 'PM' : 'AM';
      final hour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
      return '$hour:$m $period';
    }
    if (diff == 1) return 'Yesterday';
    return '$diff days ago';
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id']?.toString() ?? '',
      type: _typeFrom(json['type']?.toString()),
      title: json['title']?.toString() ?? '',
      body: (json['body'] ?? json['message'] ?? json['content'])?.toString() ?? '',
      time: _timeFrom(json['createdAt']?.toString()),
      group: _groupFrom(json['createdAt']?.toString()),
      read: json['read'] as bool? ?? json['isRead'] as bool? ?? false,
    );
  }
}

class NotificationsNotifier extends AsyncNotifier<List<AppNotification>> {
  @override
  Future<List<AppNotification>> build() async {
    // Re-fetch whenever auth changes (login / logout).
    ref.watch(authStateProvider);

    final isGuest = ref.read(isGuestProvider);
    if (isGuest) return [];

    try {
      final client = ref.read(apiClientProvider);
      if (client == null) return [];
      final data =
          await client.get<List<dynamic>>(ApiEndpoints.notifications);
      return data
          .cast<Map<String, dynamic>>()
          .map(AppNotification.fromJson)
          .toList();
    } on ApiException {
      return [];
    }
  }

  void markRead(String id) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(
      current.map((n) => n.id == id ? n.copyWith(read: true) : n).toList(),
    );
    // Fire-and-forget — best-effort server sync.
    _markReadOnServer(id);
  }

  void markAllRead() {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.map((n) => n.copyWith(read: true)).toList());
  }

  Future<void> _markReadOnServer(String id) async {
    try {
      final client = ref.read(apiClientProvider);
      await client?.post<void>('${ApiEndpoints.notifications}/$id/read');
    } catch (_) {}
  }
}

final notificationsProvider =
    AsyncNotifierProvider<NotificationsNotifier, List<AppNotification>>(
        NotificationsNotifier.new);

final unreadCountProvider = Provider<int>((ref) {
  return ref
      .watch(notificationsProvider)
      .valueOrNull
      ?.where((n) => !n.read)
      .length ?? 0;
});
