import 'package:al_abraar_core/al_abraar_core.dart' show SessionModel;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/student_providers.dart';
import '../../theme/app_theme.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

String _formatTime(DateTime dt) {
  final h = dt.hour;
  final m = dt.minute.toString().padLeft(2, '0');
  final period = h >= 12 ? 'PM' : 'AM';
  final hour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
  return '$hour:$m $period';
}

String _typeLabel(String type) {
  switch (type) {
    case 'ONE_ON_ONE':
      return 'One-on-One Session';
    case 'GROUP':
      return 'Group Session';
    case 'BROADCAST':
      return 'Live Broadcast';
    default:
      return 'Session';
  }
}

/// Convert a [SessionModel] → display [_Session].
_Session? _toSession(SessionModel s) {
  final dt = DateTime.tryParse(s.scheduledAt)?.toLocal();
  if (dt == null) return null;
  return _Session(
    time: _formatTime(dt),
    subject: s.title ?? _typeLabel(s.type),
    teacher: s.teacherName ?? 'TBA',
    duration: '${s.duration} min',
    isCompleted: s.status == 'COMPLETED',
    weekday: dt.weekday - 1, // 0=Mon … 6=Sun
  );
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  int _selectedDay = DateTime.now().weekday - 1; // 0 = Mon

  List<String> _days(AppLocalizations l) => [
        l.schedule_mon,
        l.schedule_tue,
        l.schedule_wed,
        l.schedule_thu,
        l.schedule_fri,
        l.schedule_sat,
        l.schedule_sun,
      ];

  void _showRequestSheet(BuildContext context, AppLocalizations l,
      List<SessionModel> all) {
    final subjectCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    String? selectedTeacher;

    // Build teacher list from real sessions; fall back to defaults.
    final teachers = all
        .map((s) => s.teacherName)
        .whereType<String>()
        .toSet()
        .toList();
    if (teachers.isEmpty) {
      teachers.addAll([
        'Sheikh Ahmed',
        'Ustadha Fatima',
        'Ustadh Ali',
        'Ustadh Omar',
      ]);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(
              24, 20, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              Text(l.schedule_requestTitle,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(l.schedule_requestSubtitle,
                  style: const TextStyle(
                      fontSize: 13, color: AppTheme.textSecondary)),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                initialValue: selectedTeacher,
                decoration: InputDecoration(
                    labelText: l.schedule_requestTeacherLabel),
                items: teachers
                    .map((t) =>
                        DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) =>
                    setSheetState(() => selectedTeacher = v),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: subjectCtrl,
                decoration: InputDecoration(
                    labelText: l.schedule_requestSubjectLabel),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: noteCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                    labelText: l.schedule_requestNotesLabel),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l.schedule_requestSent),
                        backgroundColor: AppTheme.successGreen,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  child: Text(l.schedule_sendRequest),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final days = _days(l);

    // Combine upcoming + past sessions.
    final upcomingAsync = ref.watch(upcomingSessionsProvider);
    final pastAsync = ref.watch(pastSessionsProvider);

    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      appBar: AppBar(
        title: Text(l.schedule_appBarTitle),
        automaticallyImplyLeading: false,
        actions: [
          // Pass an empty list initially; will be refreshed when data loads.
          upcomingAsync.when(
            data: (all) => IconButton(
              icon: const Icon(Icons.add_rounded),
              onPressed: () => _showRequestSheet(context, l, all),
            ),
            loading: () => IconButton(
              icon: const Icon(Icons.add_rounded),
              onPressed: () =>
                  _showRequestSheet(context, l, const []),
            ),
            error: (_, __) => IconButton(
              icon: const Icon(Icons.add_rounded),
              onPressed: () =>
                  _showRequestSheet(context, l, const []),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Day picker
          Container(
            color: AppTheme.surfaceWhite,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: List.generate(days.length, (index) {
                  final isSelected = index == _selectedDay;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedDay = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin:
                          const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryGreen
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryGreen
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: Text(
                        days[index],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: isSelected
                              ? Colors.white
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          // Session list
          Expanded(
            child: _buildSessionList(
                context, l, upcomingAsync, pastAsync),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionList(
    BuildContext context,
    AppLocalizations l,
    AsyncValue<List<SessionModel>> upcomingAsync,
    AsyncValue<List<SessionModel>> pastAsync,
  ) {
    if (upcomingAsync.isLoading && pastAsync.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryGreen),
      );
    }

    final upcoming = upcomingAsync.valueOrNull ?? [];
    final past = pastAsync.valueOrNull ?? [];
    final all = [...upcoming, ...past];

    // Filter by the selected weekday.
    final sessions = all
        .map(_toSession)
        .whereType<_Session>()
        .where((s) => s.weekday == _selectedDay)
        .toList()
      ..sort((a, b) => a.time.compareTo(b.time));

    if (sessions.isEmpty) {
      return _EmptySchedule(l: l);
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _SessionCard(session: sessions[i], l: l),
    );
  }
}

// ---------------------------------------------------------------------------
// Session card + helpers (unchanged UI)
// ---------------------------------------------------------------------------

class _SessionCard extends StatelessWidget {
  final _Session session;
  final AppLocalizations l;
  const _SessionCard({required this.session, required this.l});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  session.time.split(' ')[0],
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                Text(
                  session.time.split(' ')[1],
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.subject,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: session.isCompleted
                        ? AppTheme.textSecondary
                        : AppTheme.textDark,
                    decoration: session.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.person_outline,
                        size: 13, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      session.teacher,
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.timer_outlined,
                        size: 13, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      session.duration,
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _SessionAction(session: session, l: l),
        ],
      ),
    );
  }
}

class _SessionAction extends StatelessWidget {
  final _Session session;
  final AppLocalizations l;
  const _SessionAction({required this.session, required this.l});

  void _join(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => _JoinDialog(session: session, l: l),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!session.isCompleted) {
      return ElevatedButton(
        onPressed: () => _join(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryGreen,
          foregroundColor: Colors.white,
          minimumSize: Size.zero,
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700),
        ),
        child: Text(l.dashboard_join),
      );
    }
    return _StatusBadge(isCompleted: session.isCompleted, l: l);
  }
}

class _JoinDialog extends StatefulWidget {
  final _Session session;
  final AppLocalizations l;
  const _JoinDialog({required this.session, required this.l});

  @override
  State<_JoinDialog> createState() => _JoinDialogState();
}

class _JoinDialogState extends State<_JoinDialog> {
  bool _connecting = false;

  Future<void> _connect() async {
    setState(() => _connecting = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) Navigator.pop(context);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              widget.l.schedule_demoSnackbar(widget.session.subject)),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppTheme.primaryGreen,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.l;
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(24),
      content: _connecting
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryGreen,
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l.schedule_connecting,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen
                            .withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.video_call_rounded,
                          color: AppTheme.primaryGreen, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l.schedule_joinDialogTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.session.subject,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.person_outline,
                        size: 14, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text(widget.session.teacher,
                        style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary)),
                    const SizedBox(width: 12),
                    const Icon(Icons.access_time,
                        size: 14, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text(widget.session.time,
                        style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary)),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Color(0xFFE5E7EB)),
                          foregroundColor: AppTheme.textSecondary,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12)),
                        ),
                        child: Text(l.common_cancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _connect,
                        child: Text(l.schedule_joinNow),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isCompleted;
  final AppLocalizations l;
  const _StatusBadge({required this.isCompleted, required this.l});

  @override
  Widget build(BuildContext context) {
    final color =
        isCompleted ? AppTheme.textSecondary : AppTheme.primaryGreen;
    final bg = isCompleted
        ? const Color(0xFFF3F4F6)
        : AppTheme.primaryGreen.withValues(alpha: 0.1);

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isCompleted
            ? l.schedule_statusCompleted
            : l.schedule_statusUpcoming,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptySchedule extends StatelessWidget {
  final AppLocalizations l;
  const _EmptySchedule({required this.l});

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
            child: const Icon(
              Icons.event_available_rounded,
              size: 40,
              color: AppTheme.primaryGreen,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l.schedule_emptyTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l.schedule_emptyBody,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Local display model
// ---------------------------------------------------------------------------

class _Session {
  final String time;
  final String subject;
  final String teacher;
  final String duration;
  final bool isCompleted;
  final int weekday; // 0=Mon … 6=Sun
  const _Session({
    required this.time,
    required this.subject,
    required this.teacher,
    required this.duration,
    required this.isCompleted,
    required this.weekday,
  });
}
