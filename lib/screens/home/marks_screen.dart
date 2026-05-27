import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/student_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/guest_lock_screen.dart';

// ---------------------------------------------------------------------------
// Parsing helpers
// ---------------------------------------------------------------------------

String _monthShort(int month) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return months[(month - 1).clamp(0, 11)];
}

List<_Assessment> _parseAssessments(List<Map<String, dynamic>> raw) {
  final list = raw.map((j) {
    final subject = j['subject']?.toString() ??
        j['subjectName']?.toString() ??
        'Unknown';
    final title = j['title']?.toString() ??
        j['assessmentTitle']?.toString() ??
        j['name']?.toString() ??
        'Assessment';
    final score = (j['score'] as num?)?.toInt() ??
        (j['marks'] as num?)?.toInt() ??
        0;
    final maxScore = (j['maxScore'] as num?)?.toInt() ??
        (j['totalMarks'] as num?)?.toInt() ??
        (j['outOf'] as num?)?.toInt() ??
        100;
    final percent =
        maxScore > 0 ? (score * 100 / maxScore).round() : 0;
    final createdAt = j['date']?.toString() ??
        j['createdAt']?.toString() ??
        j['assessmentDate']?.toString() ??
        '';
    String dateLabel = '';
    if (createdAt.isNotEmpty) {
      final dt = DateTime.tryParse(createdAt)?.toLocal();
      if (dt != null) {
        dateLabel = '${_monthShort(dt.month)} ${dt.day}';
      }
    }
    return _Assessment(
        subject, title, '$score/$maxScore', percent, dateLabel);
  }).toList();
  // Sort newest first (by date label is fragile; keep API order which is usually desc)
  return list;
}

List<_Subject> _computeSubjects(List<_Assessment> assessments) {
  final Map<String, List<int>> map = {};
  for (final a in assessments) {
    map.putIfAbsent(a.subject, () => []).add(a.score);
  }
  return map.entries.map((e) {
    final avg =
        e.value.fold(0, (s, v) => s + v) ~/ e.value.length;
    return _Subject(e.key, avg, e.value.length);
  }).toList()
    ..sort((a, b) => b.average.compareTo(a.average));
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class MarksScreen extends ConsumerStatefulWidget {
  const MarksScreen({super.key});

  @override
  ConsumerState<MarksScreen> createState() => _MarksScreenState();
}

class _MarksScreenState extends ConsumerState<MarksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (ref.watch(isGuestProvider)) {
      return Scaffold(
        backgroundColor: AppTheme.warmBackground,
        appBar: AppBar(title: Text(l.marks_appBarTitle)),
        body: GuestLockScreen(
          featureName: l.marks_guestFeatureName,
          description: l.marks_guestDesc,
          icon: Icons.grade_rounded,
        ),
      );
    }

    final marksAsync = ref.watch(marksProvider);

    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      appBar: AppBar(
        title: Text(l.marks_appBarTitle),
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: AppTheme.primaryGreen,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorColor: AppTheme.primaryGreen,
          tabs: [
            Tab(text: l.marks_tabRecent),
            Tab(text: l.marks_tabBySubject),
          ],
        ),
      ),
      body: marksAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
              color: AppTheme.primaryGreen),
        ),
        error: (_, __) => _buildContent(context, l, []),
        data: (raw) => _buildContent(context, l, raw),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations l,
    List<Map<String, dynamic>> raw,
  ) {
    final assessments = _parseAssessments(raw);
    final subjects = _computeSubjects(assessments);

    final average = assessments.isEmpty
        ? 0
        : assessments.fold<int>(0, (s, a) => s + a.score) ~/
            assessments.length;
    final highest = assessments.isEmpty
        ? 0
        : assessments
            .map((a) => a.score)
            .reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        // Stats banner
        Container(
          color: AppTheme.surfaceWhite,
          padding: const EdgeInsets.symmetric(
              horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatChip(
                  label: l.marks_statAverage,
                  value: '$average%',
                  color: _gradeColor(average)),
              _vDivider(),
              _StatChip(
                  label: l.marks_statBest,
                  value: '$highest%',
                  color: AppTheme.successGreen),
              _vDivider(),
              _StatChip(
                  label: l.marks_statTests,
                  value: '${assessments.length}',
                  color: AppTheme.primaryGreen),
            ],
          ),
        ),
        Expanded(
          child: assessments.isEmpty
              ? _EmptyMarks(l: l)
              : TabBarView(
                  controller: _tabCtrl,
                  children: [
                    // Recent tab
                    ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: assessments.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 10),
                      itemBuilder: (_, i) =>
                          _AssessmentCard(a: assessments[i]),
                    ),
                    // By Subject tab
                    ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        ...subjects.map((s) =>
                            _SubjectCard(s: s, l: l)),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyMarks extends StatelessWidget {
  final AppLocalizations l;
  const _EmptyMarks({required this.l});

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
            child: const Icon(Icons.grade_rounded,
                size: 40, color: AppTheme.primaryGreen),
          ),
          const SizedBox(height: 16),
          Text(
            l.marks_appBarTitle,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark),
          ),
          const SizedBox(height: 6),
          const Text(
            'No marks yet. Check back after your first assessment.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14, color: AppTheme.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets (unchanged UI)
// ---------------------------------------------------------------------------

class _AssessmentCard extends StatelessWidget {
  final _Assessment a;
  const _AssessmentCard({required this.a});

  @override
  Widget build(BuildContext context) {
    final color = _gradeColor(a.score);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                _gradeLabel(a.score),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a.subject,
                    style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary)),
                const SizedBox(height: 2),
                Text(a.title,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(a.mark,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: color)),
              const SizedBox(height: 2),
              Text(a.date,
                  style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final _Subject s;
  final AppLocalizations l;
  const _SubjectCard({required this.s, required this.l});

  @override
  Widget build(BuildContext context) {
    final color = _gradeColor(s.average);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.name,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: s.average / 100,
                    minHeight: 6,
                    backgroundColor:
                        color.withValues(alpha: 0.12),
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
                const SizedBox(height: 4),
                Text(l.marks_testCount(s.tests),
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              Text('${s.average}%',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: color)),
              Text(_gradeLabel(s.average),
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: color)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: color)),
        Text(label,
            style: const TextStyle(
                fontSize: 12, color: AppTheme.textSecondary)),
      ],
    );
  }
}

Widget _vDivider() => Container(
    width: 1, height: 36, color: const Color(0xFFE5E7EB));

Color _gradeColor(int score) {
  if (score >= 85) return AppTheme.successGreen;
  if (score >= 70) return AppTheme.goldAccent;
  return AppTheme.errorRed;
}

String _gradeLabel(int score) {
  if (score >= 90) return 'A';
  if (score >= 80) return 'B';
  if (score >= 70) return 'C';
  if (score >= 60) return 'D';
  return 'F';
}

// ---------------------------------------------------------------------------
// Local display models
// ---------------------------------------------------------------------------

class _Assessment {
  final String subject;
  final String title;
  final String mark;
  final int score;
  final String date;
  const _Assessment(
      this.subject, this.title, this.mark, this.score, this.date);
}

class _Subject {
  final String name;
  final int average;
  final int tests;
  const _Subject(this.name, this.average, this.tests);
}
