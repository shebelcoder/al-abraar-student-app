import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/surahs_data.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';

enum PracticeMode {
  listenRepeat,
  memorisationTest,
  turnTaking,
}

extension PracticeModeExt on PracticeMode {
  String title(AppLocalizations l) {
    switch (this) {
      case PracticeMode.listenRepeat:
        return l.practice_mode_listenRepeatTitle;
      case PracticeMode.memorisationTest:
        return l.practice_mode_memorisationTitle;
      case PracticeMode.turnTaking:
        return l.practice_mode_turnTakingTitle;
    }
  }

  String description(AppLocalizations l) {
    switch (this) {
      case PracticeMode.listenRepeat:
        return l.practice_mode_listenRepeatDesc;
      case PracticeMode.memorisationTest:
        return l.practice_mode_memorisationDesc;
      case PracticeMode.turnTaking:
        return l.practice_mode_turnTakingDesc;
    }
  }

  IconData get icon {
    switch (this) {
      case PracticeMode.listenRepeat:
        return Icons.headphones_rounded;
      case PracticeMode.memorisationTest:
        return Icons.psychology_rounded;
      case PracticeMode.turnTaking:
        return Icons.swap_horiz_rounded;
    }
  }

  Color get color {
    switch (this) {
      case PracticeMode.listenRepeat:
        return const Color(0xFF8B5CF6);
      case PracticeMode.memorisationTest:
        return AppTheme.primaryGreen;
      case PracticeMode.turnTaking:
        return const Color(0xFF0EA5E9);
    }
  }
}

class SessionSetupScreen extends StatefulWidget {
  const SessionSetupScreen({super.key});

  @override
  State<SessionSetupScreen> createState() => _SessionSetupScreenState();
}

class _SessionSetupScreenState extends State<SessionSetupScreen> {
  int? _selectedSurahIndex;
  PracticeMode? _selectedMode;

  bool get _canStart =>
      _selectedSurahIndex != null && _selectedMode != null;

  void _start() {
    if (!_canStart) return;
    context.push(
      '/practice/session',
      extra: {
        'surahIndex': _selectedSurahIndex!,
        'mode': _selectedMode!.name,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      appBar: AppBar(title: Text(l.setup_appBarTitle)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Step 1 — surah
                _StepHeader(
                  number: 1,
                  title: l.setup_step1,
                  done: _selectedSurahIndex != null,
                ),
                const SizedBox(height: 12),
                ...List.generate(practiseSurahs.length, (i) {
                  final surah = practiseSurahs[i];
                  final selected = _selectedSurahIndex == i;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedSurahIndex = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppTheme.primaryGreen
                            : AppTheme.surfaceWhite,
                        borderRadius: BorderRadius.circular(14),
                        border: selected
                            ? null
                            : Border.all(
                                color: const Color(0xFFE5E7EB)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: selected
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : AppTheme.primaryGreen
                                      .withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${surah.number}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                  color: selected
                                      ? Colors.white
                                      : AppTheme.primaryGreen,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      surah.name,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: selected
                                            ? Colors.white
                                            : AppTheme.textDark,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      surah.arabicName,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: selected
                                            ? Colors.white70
                                            : AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    Text(
                                      l.setup_ayahCount(surah.ayahCount),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: selected
                                            ? Colors.white70
                                            : AppTheme.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: selected
                                            ? Colors.white
                                                .withValues(alpha: 0.2)
                                            : (surah.isBeginner
                                                ? AppTheme.successGreen
                                                : AppTheme.goldAccent)
                                            .withValues(alpha: 0.15),
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        surah.isBeginner
                                            ? l.setup_difficultyBeginner
                                            : l.setup_difficultyIntermediate,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: selected
                                              ? Colors.white
                                              : (surah.isBeginner
                                                  ? AppTheme.successGreen
                                                  : AppTheme.goldAccent),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text(
                            surah.meaning,
                            style: TextStyle(
                              fontSize: 11,
                              color: selected
                                  ? Colors.white60
                                  : AppTheme.textSecondary,
                            ),
                          ),
                          if (selected)
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Icon(Icons.check_circle_rounded,
                                  color: Colors.white, size: 20),
                            ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 24),

                // Step 2 — mode
                _StepHeader(
                  number: 2,
                  title: l.setup_step2,
                  done: _selectedMode != null,
                ),
                const SizedBox(height: 12),
                ...PracticeMode.values.map((mode) {
                  final selected = _selectedMode == mode;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedMode = mode),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: selected
                            ? mode.color.withValues(alpha: 0.08)
                            : AppTheme.surfaceWhite,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected
                              ? mode.color.withValues(alpha: 0.4)
                              : const Color(0xFFE5E7EB),
                          width: selected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: mode.color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(mode.icon,
                                color: mode.color, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mode.title(l),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: selected
                                        ? mode.color
                                        : AppTheme.textDark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  mode.description(l),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (selected)
                            Icon(Icons.check_circle_rounded,
                                color: mode.color, size: 20),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 24),
              ],
            ),
          ),

          // Start button
          Container(
            color: AppTheme.surfaceWhite,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: SafeArea(
              top: false,
              child: AnimatedOpacity(
                opacity: _canStart ? 1.0 : 0.5,
                duration: const Duration(milliseconds: 200),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _canStart ? _start : null,
                    icon: const Icon(Icons.play_arrow_rounded, size: 22),
                    label: Text(
                      _canStart
                          ? l.setup_startButton(practiseSurahs[_selectedSurahIndex!].name)
                          : l.setup_startButtonDisabled,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  final int number;
  final String title;
  final bool done;
  const _StepHeader(
      {required this.number, required this.title, required this.done});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: done ? AppTheme.successGreen : AppTheme.primaryGreen,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: done
                ? const Icon(Icons.check_rounded,
                    color: Colors.white, size: 14)
                : Text(
                    '$number',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
      ],
    );
  }
}
