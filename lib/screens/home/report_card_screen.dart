import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/guest_lock_screen.dart';

class ReportCardScreen extends ConsumerStatefulWidget {
  const ReportCardScreen({super.key});

  @override
  ConsumerState<ReportCardScreen> createState() =>
      _ReportCardScreenState();
}

class _ReportCardScreenState extends ConsumerState<ReportCardScreen> {
  int _termIndex = 0;

  static const _termData = [
    _TermData(
      overallGrade: 'B+',
      overallScore: 83,
      attendanceRate: 92,
      subjects: [
        _SubjectResult('Quran Recitation', 88, 'A-', 'Sheikh Ahmed',
            'Excellent tajweed. Needs to work on longer surahs.'),
        _SubjectResult('Tajweed Rules', 76, 'C+', 'Sheikh Ahmed',
            'Good understanding of basic rules. Makharij needs more practice.'),
        _SubjectResult('Arabic Language', 91, 'A', 'Ustadh Ali',
            'Outstanding vocabulary. Grammar is a strong point.'),
        _SubjectResult('Quran Memorisation', 82, 'B', 'Ustadha Fatima',
            'Consistent progress. Al-Fatiha and Juz Amma surahs complete.'),
        _SubjectResult('Islamic Studies', 69, 'C', 'Ustadh Omar',
            'Needs to engage more in class discussions. Homework completion should improve.'),
      ],
      comment:
          'Abdullah has shown great dedication this term. His recitation has improved significantly and he maintains a positive attitude. Keep up the excellent work!',
      teacher: 'Sheikh Ahmed',
    ),
    _TermData(
      overallGrade: 'A-',
      overallScore: 87,
      attendanceRate: 95,
      subjects: [
        _SubjectResult('Quran Recitation', 92, 'A', 'Sheikh Ahmed',
            'Remarkable improvement. Surah Yaseen memorised flawlessly.'),
        _SubjectResult('Tajweed Rules', 84, 'B', 'Sheikh Ahmed',
            'Makharij has improved greatly. Ghunna rules are now solid.'),
        _SubjectResult('Arabic Language', 89, 'B+', 'Ustadh Ali',
            'Strong vocabulary. Reading fluency has improved.'),
        _SubjectResult('Quran Memorisation', 88, 'B+', 'Ustadha Fatima',
            'Memorising at a faster pace. Consistent revision is appreciated.'),
        _SubjectResult('Islamic Studies', 78, 'C+', 'Ustadh Omar',
            'Better participation this term. Written work is improving.'),
      ],
      comment:
          'A wonderful term for Abdullah. His commitment to Quran memorisation is commendable and his grades reflect his hard work. Looking forward to seeing continued progress.',
      teacher: 'Sheikh Ahmed',
    ),
    _TermData(
      overallGrade: 'A',
      overallScore: 91,
      attendanceRate: 98,
      subjects: [
        _SubjectResult('Quran Recitation', 95, 'A', 'Sheikh Ahmed',
            'Near-perfect recitation. A role model for the class.'),
        _SubjectResult('Tajweed Rules', 89, 'B+', 'Sheikh Ahmed',
            'All rules mastered to a high standard.'),
        _SubjectResult('Arabic Language', 94, 'A', 'Ustadh Ali',
            'Exceptional performance. Writing skills are outstanding.'),
        _SubjectResult('Quran Memorisation', 92, 'A', 'Ustadha Fatima',
            'Juz Amma complete. Has started on longer surahs.'),
        _SubjectResult('Islamic Studies', 84, 'B', 'Ustadh Omar',
            'Significant improvement. Thoughtful contributions in class.'),
      ],
      comment:
          'An exceptional term. Abdullah has truly excelled across all subjects. His dedication to his studies and love for the Quran is an inspiration to his peers. May Allah bless his journey.',
      teacher: 'Sheikh Ahmed',
    ),
  ];

  _TermData get _current => _termData[_termIndex];

  Color get _gradeColor {
    final s = _current.overallScore;
    if (s >= 85) return AppTheme.successGreen;
    if (s >= 70) return AppTheme.goldAccent;
    return AppTheme.errorRed;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final terms = [l.reportCard_term1, l.reportCard_term2, l.reportCard_term3];

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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Term selector
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
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: sel
                            ? AppTheme.primaryGreen
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Text(
                        terms[i],
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
                colors: [_gradeColor, _gradeColor.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: _gradeColor.withValues(alpha: 0.3),
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
                      _current.overallGrade,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 52,
                          fontWeight: FontWeight.w900,
                          height: 1),
                    ),
                    Text('${_current.overallScore}${l.reportCard_averageSuffix}',
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
                        value: '${_current.attendanceRate}%'),
                    const SizedBox(height: 10),
                    _CardStat(
                        label: l.reportCard_statSubjects,
                        value:
                            '${_current.subjects.length}'),
                    const SizedBox(height: 10),
                    _CardStat(
                        label: l.reportCard_statTerm,
                        value: terms[_termIndex]),
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
          ..._current.subjects
              .map((s) => _SubjectRow(subject: s)),
          const SizedBox(height: 20),

          // Teacher comment
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
                        Text(_current.teacher,
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _current.comment,
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
      ),
    );
  }
}

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
            Text(subject.teacher,
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 13)),
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

// ---------------------------------------------------------------------------

class _TermData {
  final String overallGrade;
  final int overallScore;
  final int attendanceRate;
  final List<_SubjectResult> subjects;
  final String comment;
  final String teacher;
  const _TermData({
    required this.overallGrade,
    required this.overallScore,
    required this.attendanceRate,
    required this.subjects,
    required this.comment,
    required this.teacher,
  });
}

class _SubjectResult {
  final String name;
  final int score;
  final String grade;
  final String teacher;
  final String comment;
  const _SubjectResult(
      this.name, this.score, this.grade, this.teacher, this.comment);
}
