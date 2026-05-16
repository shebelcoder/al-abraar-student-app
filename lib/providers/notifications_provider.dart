import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NotifType { reminder, message, achievement, grade, announcement }

class AppNotification {
  final int id;
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
}

final _seed = <AppNotification>[
  AppNotification(
    id: 1,
    type: NotifType.reminder,
    title: 'Class in 30 minutes',
    body: 'Quran Recitation with Sheikh Ahmed starts at 5:00 PM',
    time: '4:30 PM',
    group: 'Today',
    read: false,
  ),
  AppNotification(
    id: 2,
    type: NotifType.achievement,
    title: 'Badge Unlocked!',
    body: "You earned the '7-Day Streak' badge. Keep it up!",
    time: '2:15 PM',
    group: 'Today',
    read: false,
  ),
  AppNotification(
    id: 3,
    type: NotifType.message,
    title: 'New message from Sheikh Ahmed',
    body: 'Well done on your Tajweed practice today!',
    time: '1:00 PM',
    group: 'Today',
    read: false,
  ),
  AppNotification(
    id: 4,
    type: NotifType.grade,
    title: 'New mark posted',
    body: 'Your Tajweed assessment has been marked: 88/100',
    time: 'Yesterday',
    group: 'Yesterday',
    read: true,
  ),
  AppNotification(
    id: 5,
    type: NotifType.announcement,
    title: 'Class Group – Level 2',
    body: "Don't forget tomorrow's class is at 9 AM instead of the usual time.",
    time: 'Yesterday',
    group: 'Yesterday',
    read: true,
  ),
  AppNotification(
    id: 6,
    type: NotifType.reminder,
    title: 'Daily practice reminder',
    body: "You haven't practiced today. Keep your streak going!",
    time: 'Yesterday',
    group: 'Yesterday',
    read: true,
  ),
  AppNotification(
    id: 7,
    type: NotifType.achievement,
    title: 'Al-Fatiha Complete!',
    body: "You memorised Al-Fatiha perfectly. Masha'Allah!",
    time: '2 days ago',
    group: 'Earlier',
    read: true,
  ),
  AppNotification(
    id: 8,
    type: NotifType.grade,
    title: 'Report card available',
    body: 'Your Term 1 report card is now ready to view.',
    time: '3 days ago',
    group: 'Earlier',
    read: true,
  ),
];

class NotificationsNotifier
    extends Notifier<List<AppNotification>> {
  @override
  List<AppNotification> build() => List.from(_seed);

  void markRead(int id) {
    state = state
        .map((n) => n.id == id ? n.copyWith(read: true) : n)
        .toList();
  }

  void markAllRead() {
    state = state.map((n) => n.copyWith(read: true)).toList();
  }
}

final notificationsProvider =
    NotifierProvider<NotificationsNotifier, List<AppNotification>>(
        NotificationsNotifier.new);

final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationsProvider).where((n) => !n.read).length;
});
