import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/student_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/guest_lock_screen.dart';

enum _Att { present, absent, excused, none }

// ---------------------------------------------------------------------------
// Parse API response → per-day map for the given month
// ---------------------------------------------------------------------------

Map<int, _Att> _parseAttendanceData(
    Map<String, dynamic> body, DateTime month) {
  // Try common response shapes:
  // { records: [{ date, status }] }  or
  // { attendance: [{ date, status }] }  or
  // { data: [{ sessionDate, attendanceStatus }] }
  final rawList = (body['records'] as List?) ??
      (body['attendance'] as List?) ??
      (body['data'] as List?) ??
      [];

  final result = <int, _Att>{};
  for (final r in rawList) {
    if (r is! Map) continue;
    final dateStr = r['date']?.toString() ??
        r['sessionDate']?.toString() ??
        r['classDate']?.toString() ??
        '';
    final dt = DateTime.tryParse(dateStr)?.toLocal();
    if (dt == null) continue;
    if (dt.year != month.year || dt.month != month.month) continue;

    final rawStatus = (r['status']?.toString() ??
            r['attendanceStatus']?.toString() ??
            '')
        .toLowerCase();
    _Att att;
    if (rawStatus.contains('present') || rawStatus == 'p') {
      att = _Att.present;
    } else if (rawStatus.contains('excused') || rawStatus == 'e') {
      att = _Att.excused;
    } else if (rawStatus.contains('absent') || rawStatus == 'a') {
      att = _Att.absent;
    } else {
      att = _Att.none;
    }
    result[dt.day] = att;
  }
  return result;
}

/// Extract summary counts from API body.
/// Falls back to computing from the per-day map.
(int present, int absent, int excused) _parseSummary(
    Map<String, dynamic> body, Map<int, _Att> dayMap) {
  final summaryMap = body['summary'] as Map<String, dynamic>?;
  if (summaryMap != null) {
    final p = (summaryMap['present'] as num?)?.toInt();
    final a = (summaryMap['absent'] as num?)?.toInt();
    final e = (summaryMap['excused'] as num?)?.toInt() ??
        (summaryMap['late'] as num?)?.toInt() ??
        0;
    if (p != null && a != null) return (p, a, e);
  }
  // Compute from day map
  final present = dayMap.values.where((v) => v == _Att.present).length;
  final absent = dayMap.values.where((v) => v == _Att.absent).length;
  final excused = dayMap.values.where((v) => v == _Att.excused).length;
  return (present, absent, excused);
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() =>
      _AttendanceScreenState();
}

class _AttendanceScreenState
    extends ConsumerState<AttendanceScreen> {
  late DateTime _month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
  }

  void _prevMonth() =>
      setState(() => _month = DateTime(_month.year, _month.month - 1));

  void _nextMonth() {
    final next = DateTime(_month.year, _month.month + 1);
    if (!next.isAfter(DateTime.now())) {
      setState(() => _month = next);
    }
  }

  bool get _canGoNext {
    final now = DateTime.now();
    return _month.year < now.year ||
        (_month.year == now.year && _month.month < now.month);
  }

  String _monthLabel(Locale locale) {
    final monthName =
        DateFormat('MMMM', locale.languageCode).format(_month);
    return '$monthName ${_month.year}';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);

    if (ref.watch(isGuestProvider)) {
      return Scaffold(
        backgroundColor: AppTheme.warmBackground,
        appBar: AppBar(title: Text(l.attendance_appBarTitle)),
        body: GuestLockScreen(
          featureName: l.attendance_guestFeatureName,
          description: l.attendance_guestDesc,
          icon: Icons.event_available_rounded,
        ),
      );
    }

    final attendanceAsync = ref.watch(attendanceProvider);

    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      appBar: AppBar(title: Text(l.attendance_appBarTitle)),
      body: attendanceAsync.when(
        loading: () => const Center(
          child:
              CircularProgressIndicator(color: AppTheme.primaryGreen),
        ),
        error: (_, __) => _buildBody(context, l, locale, {}),
        data: (body) {
          final dayMap = _parseAttendanceData(body, _month);
          return _buildBody(context, l, locale, dayMap,
              apiBody: body);
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l,
    Locale locale,
    Map<int, _Att> dayMap, {
    Map<String, dynamic>? apiBody,
  }) {
    final (present, absent, excused) = apiBody != null
        ? _parseSummary(apiBody, dayMap)
        : (
            dayMap.values.where((v) => v == _Att.present).length,
            dayMap.values.where((v) => v == _Att.absent).length,
            dayMap.values.where((v) => v == _Att.excused).length
          );

    final total = present + absent + excused;
    final rate = total == 0 ? 0.0 : present / total;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Stats banner
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0EA5E9), Color(0xFF0369A1)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0EA5E9).withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _AttStat(
                  label: l.attendance_present,
                  value: '$present',
                  color: Colors.white,
                ),
              ),
              _Divider(),
              Expanded(
                child: _AttStat(
                  label: l.attendance_absent,
                  value: '$absent',
                  color: Colors.white,
                ),
              ),
              _Divider(),
              Expanded(
                child: _AttStat(
                  label: l.attendance_rate,
                  value: '${(rate * 100).round()}%',
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Calendar
        Container(
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _prevMonth,
                    icon: const Icon(Icons.chevron_left_rounded,
                        color: AppTheme.textDark),
                  ),
                  Text(
                    _monthLabel(locale),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  IconButton(
                    onPressed: _canGoNext ? _nextMonth : null,
                    icon: Icon(
                      Icons.chevron_right_rounded,
                      color: _canGoNext
                          ? AppTheme.textDark
                          : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                    .map((d) => Expanded(
                          child: Center(
                            child: Text(
                              d,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 8),
              _CalendarGrid(month: _month, data: dayMap),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Legend
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: AppTheme.surfaceWhite,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _LegendItem(
                  label: l.attendance_legendPresent,
                  color: AppTheme.successGreen),
              _LegendItem(
                  label: l.attendance_legendAbsent,
                  color: AppTheme.errorRed),
              _LegendItem(
                  label: l.attendance_legendExcused,
                  color: AppTheme.goldAccent),
              _LegendItem(
                  label: l.attendance_legendNoClass,
                  color: const Color(0xFFE5E7EB)),
            ],
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets (unchanged UI)
// ---------------------------------------------------------------------------

class _CalendarGrid extends StatelessWidget {
  final DateTime month;
  final Map<int, _Att> data;
  const _CalendarGrid({required this.month, required this.data});

  @override
  Widget build(BuildContext context) {
    final firstWeekday =
        DateTime(month.year, month.month, 1).weekday - 1;
    final daysInMonth =
        DateUtils.getDaysInMonth(month.year, month.month);
    final totalCells = firstWeekday + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Column(
      children: List.generate(rows, (row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: List.generate(7, (col) {
              final cell = row * 7 + col;
              final day = cell - firstWeekday + 1;
              if (day < 1 || day > daysInMonth) {
                return const Expanded(child: SizedBox());
              }
              final att = data[day] ?? _Att.none;
              return Expanded(child: _DayCell(day: day, att: att));
            }),
          ),
        );
      }),
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final _Att att;
  const _DayCell({required this.day, required this.att});

  Color get _bg {
    switch (att) {
      case _Att.present:
        return AppTheme.successGreen;
      case _Att.absent:
        return AppTheme.errorRed;
      case _Att.excused:
        return AppTheme.goldAccent;
      case _Att.none:
        return const Color(0xFFF3F4F6);
    }
  }

  Color get _fg {
    return att == _Att.none ? AppTheme.textSecondary : Colors.white;
  }

  bool get _isToday {
    final now = DateTime.now();
    return day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: _bg,
          shape: BoxShape.circle,
          border: _isToday
              ? Border.all(color: AppTheme.primaryGreen, width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            '$day',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _fg,
            ),
          ),
        ),
      ),
    );
  }
}

class _AttStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _AttStat(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        Text(
          label,
          style:
              TextStyle(fontSize: 12, color: color.withValues(alpha: 0.8)),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: Colors.white.withValues(alpha: 0.3),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  const _LegendItem({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration:
              BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
              fontSize: 11, color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}
