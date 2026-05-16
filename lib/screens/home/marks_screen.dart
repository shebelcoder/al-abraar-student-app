import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/guest_lock_screen.dart';

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

  static const _assessments = [
    _Assessment('Quran Recitation', 'Al-Fatiha Test', '88/100', 88, 'Apr 28'),
    _Assessment('Tajweed Rules', 'Mid-term Quiz', '76/100', 76, 'Apr 22'),
    _Assessment('Arabic Language', 'Vocab Test 3', '91/100', 91, 'Apr 18'),
    _Assessment('Quran Memorisation', 'Juz Amma Progress', '82/100', 82, 'Apr 12'),
    _Assessment('Islamic Studies', 'Unit 2 Exam', '69/100', 69, 'Apr 5'),
    _Assessment('Quran Recitation', 'Surah Yaseen', '94/100', 94, 'Mar 29'),
    _Assessment('Arabic Language', 'Grammar Test', '73/100', 73, 'Mar 22'),
    _Assessment('Tajweed Rules', 'Makharij Quiz', '85/100', 85, 'Mar 15'),
  ];

  static const _subjects = [
    _Subject('Quran Recitation', 91, 3),
    _Subject('Arabic Language', 82, 2),
    _Subject('Tajweed Rules', 80, 2),
    _Subject('Quran Memorisation', 82, 1),
    _Subject('Islamic Studies', 69, 1),
  ];

  double get _average {
    final total = _assessments.fold(0, (s, a) => s + a.score);
    return total / _assessments.length;
  }

  int get _highest =>
      _assessments.map((a) => a.score).reduce((a, b) => a > b ? a : b);

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
      body: Column(
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
                    value: '${_average.round()}%',
                    color: _gradeColor(_average.round())),
                _vDivider(),
                _StatChip(
                    label: l.marks_statBest,
                    value: '$_highest%',
                    color: AppTheme.successGreen),
                _vDivider(),
                _StatChip(
                    label: l.marks_statTests,
                    value: '${_assessments.length}',
                    color: AppTheme.primaryGreen),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                // Recent tab
                ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _assessments.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 10),
                  itemBuilder: (_, i) =>
                      _AssessmentCard(a: _assessments[i]),
                ),
                // By Subject tab
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ..._subjects.map((s) => _SubjectCard(s: s, l: l)),
                    const SizedBox(height: 80),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
                    backgroundColor: color.withValues(alpha: 0.12),
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

// ---------------------------------------------------------------------------

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
