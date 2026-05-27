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

class _SubjectResult {
  final String name;
  final int score;
  final String grade;
  final String teacher;
  final String comment;
  const _SubjectResult(
      this.name, this.score, this.grade, this.teacher, this.comment);
}

class _TermData {
  final String label;
  final String overallGrade;
  final int overallScore;
  final int attendanceRate;
  final List<_SubjectResult> subjects;
  final String comment;
  final String teacher;
  const _TermData({
    required this.label,
    required this.overallGrade,
    required this.overallScore,
    required this.attendanceRate,
    required this.subjects,
    required this.comment,
    required this.teacher,
  });
}

_SubjectResult? _parseSubject(dynamic raw) {
  if (raw is! Map) return null;
  final j = raw as Map<String, dynamic>;
  return _SubjectResult(
    j['name']?.toString() ??
        j['subject']?.toString() ??
        j['subjectName']?.toString() ??
        'Unknown',
    (j['score'] as num?)?.toInt() ??
        (j['percentage'] as num?)?.toInt() ??
        0,
    j['grade']?.toString() ?? '-',
    j['teacher']?.toString() ??
        j['teacherName']?.toString() ??
        '',
    j['comment']?.toString() ??
        j['feedback']?.toString() ??
        j['teacherComment']?.toString() ??
        '',
  );
}

List<_TermData> _parseTerms(
    Map<String, dynamic> body, List<String> termLabels) {
  // Try { terms: [...] } or { reportCard: { terms: [...] } } or root list
  final rawTerms = (body['terms'] as List?) ??
      ((body['reportCard'] as Map?)?['terms'] as List?) ??
      [];

  if (rawTerms.isNotEmpty) {
    return rawTerms.asMap().entries.map((e) {
      final j = e.value as Map<String, dynamic>;
      final subjectsRaw = j['subjects'] as List? ?? [];
      return _TermData(
        label: termLabels[e.key.clamp(0, termLabels.length - 1)],
        overallGrade: j['grade']?.toString() ??
            j['overallGrade']?.toString() ??
            '-',
        overallScore: (j['score'] as num?)?.toInt() ??
            (j['overallScore'] as num?)?.toInt() ??
            0,
        attendanceRate: (j['attendance'] as num?)?.toInt() ??
            (j['attendanceRate'] as num?)?.toInt() ??
            0,
        subjects: subjectsRaw
            .map(_parseSubject)
            .whereType<_SubjectResult>()
            .toList(),
        comment: j['comment']?.toString() ??
            j['teacherComment']?.toString() ??
            '',
        teacher: j['teacher']?.toString() ??
            j['teacherName']?.toString() ??
            '',
      );
    }).toList();
  }

  // Flat body (single term)
  final subjectsRaw = body['subjects'] as List? ?? [];
  if (body.isNotEmpty) {
    return [
      _TermData(
        label: termLabels[0],
        overallGrade:
            body['grade']?.toString() ?? body['overallGrade']?.toString() ?? '-',
        overallScore: (body['score'] as num?)?.toInt() ??
            (body['overallScore'] as num?)?.toInt() ??
            0,
        attendanceRate: (body['attendance'] as num?)?.toInt() ??
            (body['attendanceRate'] as num?)?.toInt() ??
            0,
        subjects: subjectsRaw
            .map(_parseSubject)
            .whereType<_SubjectResult>()
            .toList(),
        comment: body['comment']?.toString() ??
            body['teacherComment']?.toString() ??
            '',
        teacher: body['teacher']?.toString() ??
            body['teacherName']?.toString() ??
            '',
      ),
    ];
  }

  return [];
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class ReportCardScreen extends ConsumerStatefulWidget {
  const ReportCardScreen({super.key});

  @override
  ConsumerState<ReportCardScreen> createState() =>
      _ReportCardScreenState();
}

class _ReportCardScreenState extends ConsumerState<ReportCardScreen> {
  int _termIndex = 0;

  Color _gradeColor(int score) {
    if (score >= 85) return AppTheme.successGreen;
    if (score >= 70) return AppTheme.goldAccent;
    return AppTheme.errorRed;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final termLabels = [
      l.reportCard_term1,
      l.reportCard_term2,
      l.reportCard_term3,
    ];

    if (ref.watch(isGuestProvider)) {
      return Scaffold(
        backgroundColor: AppTheme.warmBackground,
        appBar: AppBar(title: Text(l.reportCard_appBarTitle)),
        body: GuestLockScreen(
          featureName: l.reportCard_guestFeatureName,
          description: l.reportCard_guestDesc,
          icon: Icons.description_rounded,
        ),
      );
    }

    final reportAsync = ref.watch(reportCardProvider);

    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      appBar: AppBar(
        title: Text(l.reportCard_appBarTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            tooltip: l.reportCard_downloadTooltip,
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l.reportCard_downloadComingSoon),
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppTheme.primaryGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
      body: reportAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
              color: AppTheme.primaryGreen),
        ),
        error: (_, __) => _buildEmpty(l),
        data: (body) {
          final terms = _parseTerms(body, termLabels);
          if (terms.isEmpty) return _buildEmpty(l);
          // Clamp index if fewer terms returned than expected.
          final idx = _termIndex.clamp(0, terms.length - 1);
          return _buildContent(l, terms, idx, termLabels);
        },
      ),
    );
  }

  Widget _buildEmpty(AppLocalizations l) {
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
            child: const Icon(Icons.description_rounded,
                size: 40, color: AppTheme.primaryGreen),
          ),
          const SizedBox(height: 16),
          Text(
            l.reportCard_appBarTitle,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark),
          ),
          const SizedBox(height: 6),
          const Text(
            'Your report card will appear here after the term ends.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    AppLocalizations l,
    List<_TermData> terms,
    int idx,
    List<String> termLabels,
  ) {
    final current = terms[idx];
    final gradeColor = _gradeColor(current.overallScore);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Term selector
        if (terms.length > 1)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: List.generate(terms.length, (i) {
                final sel = i == _termIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _termIndex = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding:
                          const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: sel
                            ? AppTheme.primaryGreen
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Text(
                        terms[i].label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: sel
                              ? Colors.white
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        const SizedBox(height: 16),

        // Overall grade card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                gradeColor,
                gradeColor.withValues(alpha: 0.7)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: gradeColor.withValues(alpha: 0.3),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.reportCard_overallGrade,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(
                    current.overallGrade,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        height: 1),
                  ),
                  Text(
                      '${current.overallScore}${l.reportCard_averageSuffix}',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13)),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _CardStat(
                      label: l.reportCard_statAttendance,
                      value: '${current.attendanceRate}%'),
                  const SizedBox(height: 10),
                  _CardStat(
                      label: l.reportCard_statSubjects,
                      value: '${current.subjects.length}'),
                  const SizedBox(height: 10),
                  _CardStat(
                      label: l.reportCard_statTerm,
                      value: current.label),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Subject results
        Text(l.reportCard_subjectResults,
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark)),
        const SizedBox(height: 12),
        ...current.subjects.map((s) => _SubjectRow(subject: s)),
        const SizedBox(height: 20),

        // Teacher comment
        if (current.comment.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen
                            .withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.format_quote_rounded,
                          color: AppTheme.primaryGreen, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.reportCard_teacherComment,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textDark)),
                        if (current.teacher.isNotEmpty)
                          Text(current.teacher,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  current.comment,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    height: 1.6,
                    fontStyle: FontStyle.italic,
                  ),
                ),
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

class _SubjectRow extends StatelessWidget {
  final _SubjectResult subject;
  const _SubjectRow({required this.subject});

  Color get _color {
    if (subject.score >= 85) return AppTheme.successGreen;
    if (subject.score >= 70) return AppTheme.goldAccent;
    return AppTheme.errorRed;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetail(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 5,
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
                  Text(subject.name,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textDark)),
                  const SizedBox(height: 2),
                  if (subject.teacher.isNotEmpty)
                    Text(subject.teacher,
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(subject.grade,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: _color)),
                Text('${subject.score}/100',
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary)),
              ],
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded,
                color: AppTheme.textSecondary, size: 18),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
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
            const SizedBox(height: 20),
            Text(subject.name,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            if (subject.teacher.isNotEmpty)
              Text(subject.teacher,
                  style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13)),
            const SizedBox(height: 16),
            Row(
              children: [
                _DetailChip(
                    label: 'Score',
                    value: '${subject.score}/100'),
                const SizedBox(width: 12),
                _DetailChip(
                    label: 'Grade', value: subject.grade),
              ],
            ),
            if (subject.comment.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text("Teacher's Feedback",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark)),
              const SizedBox(height: 8),
              Text(subject.comment,
                  style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                      height: 1.5)),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  final String label;
  final String value;
  const _DetailChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.primaryGreen)),
          Text(label,
              style: const TextStyle(
                  fontSize: 11, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}

class _CardStat extends StatelessWidget {
  final String label;
  final String value;
  const _CardStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700)),
        Text(label,
            style: const TextStyle(
                color: Colors.white60, fontSize: 11)),
      ],
    );
  }
}
