import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../data/surahs_data.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/practice_history_provider.dart';
import '../../theme/app_theme.dart';
import 'session_setup_screen.dart';

// ---------------------------------------------------------------------------
// Stage machine
// ---------------------------------------------------------------------------
enum _Stage {
  aiPlayback,
  countdown,
  recording,
  reviewing,
  completed,
}

enum AyahResult { correct, smallMistake, wrong, skipped }

extension _AyahResultLabel on AyahResult {
  String label(AppLocalizations l) {
    switch (this) {
      case AyahResult.correct:
        return l.session_correct;
      case AyahResult.smallMistake:
        return l.session_smallMistake;
      case AyahResult.wrong:
        return l.session_wrong;
      case AyahResult.skipped:
        return l.session_skipped;
    }
  }
}

// ---------------------------------------------------------------------------

class AIPracticeSessionScreen extends ConsumerStatefulWidget {
  final int surahIndex;
  final PracticeMode mode;

  const AIPracticeSessionScreen({
    super.key,
    required this.surahIndex,
    required this.mode,
  });

  @override
  ConsumerState<AIPracticeSessionScreen> createState() =>
      _AIPracticeSessionScreenState();
}

class _AIPracticeSessionScreenState
    extends ConsumerState<AIPracticeSessionScreen>
    with TickerProviderStateMixin {
  // Session state
  int _current = 0;
  int _score = 0;
  int _lives = 3;
  _Stage _stage = _Stage.aiPlayback;
  final List<AyahResult> _results = [];
  bool _showTransliteration = true;
  bool _showTranslation = false;

  // Audio
  late AudioPlayer _player;
  bool _audioPlaying = false;
  StreamSubscription<PlayerState>? _playerSub;

  // Recording
  late stt.SpeechToText _speech;
  bool _speechAvailable = false;
  bool _isListening = false;
  String _transcript = '';
  int _recordSeconds = 0;
  Timer? _recordTimer;

  // Countdown
  int _countdown = 3;
  Timer? _countdownTimer;

  // Animations
  late AnimationController _waveCtrl;
  late AnimationController _micPulseCtrl;
  late Animation<double> _micPulse;

  SurahData get _surah => practiseSurahs[widget.surahIndex];
  AyahData get _ayah => _surah.ayahs[_current];
  bool get _isLastAyah => _current >= _surah.ayahs.length - 1;

  bool get _isStudentTurn {
    if (widget.mode == PracticeMode.turnTaking) {
      return _current % 2 == 1;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _player = AudioPlayer();

    _playerSub = _player.playerStateStream.listen((ps) {
      if (!mounted) return;
      setState(() => _audioPlaying = ps.playing);
      if (ps.processingState == ProcessingState.completed &&
          _stage == _Stage.aiPlayback) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && _stage == _Stage.aiPlayback) _onAIFinished();
        });
      }
    });

    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _micPulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _micPulse = Tween<double>(begin: 1.0, end: 1.14).animate(
      CurvedAnimation(parent: _micPulseCtrl, curve: Curves.easeInOut),
    );

    _initSpeech();
    _beginAyah();
  }

  // ── Audio ────────────────────────────────────────────────────────────────

  String _audioUrl(int surahNumber, int ayahIndex) {
    final s = surahNumber.toString().padLeft(3, '0');
    final a = (ayahIndex + 1).toString().padLeft(3, '0');
    return 'https://everyayah.com/data/Alafasy_128kbps/$s$a.mp3';
  }

  Future<void> _playAudio() async {
    try {
      await _player.setUrl(_audioUrl(_surah.number, _current));
      await _player.play();
    } catch (_) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _stage == _Stage.aiPlayback) _onAIFinished();
      });
    }
  }

  Future<void> _initSpeech() async {
    final ok = await _speech.initialize(
      onStatus: (s) {
        if ((s == 'done' || s == 'notListening') && mounted) {
          setState(() => _isListening = false);
          _stopRecordTimer();
        }
      },
      onError: (_) {
        if (mounted) setState(() => _isListening = false);
        _stopRecordTimer();
      },
    );
    if (mounted) setState(() => _speechAvailable = ok);
  }

  // ── Navigation through ayahs ────────────────────────────────────────────

  void _beginAyah() {
    _transcript = '';
    if (widget.mode == PracticeMode.memorisationTest) {
      setState(() => _stage = _Stage.countdown);
      _startCountdown();
    } else if (widget.mode == PracticeMode.turnTaking && !_isStudentTurn) {
      setState(() => _stage = _Stage.aiPlayback);
      _playAudio();
    } else {
      setState(() => _stage = _Stage.aiPlayback);
      _playAudio();
    }
  }

  void _onHearAgain() {
    setState(() {
      _stage = _Stage.aiPlayback;
      _transcript = '';
    });
    _player.seek(Duration.zero).then((_) => _player.play());
  }

  void _onAIFinished() {
    setState(() => _stage = _Stage.countdown);
    _startCountdown();
  }

  void _startCountdown() {
    _countdown = 3;
    _countdownTimer?.cancel();
    _countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_countdown <= 1) {
        t.cancel();
        _startRecording();
      } else {
        setState(() => _countdown--);
      }
    });
  }

  Future<void> _startRecording() async {
    setState(() {
      _stage = _Stage.recording;
      _transcript = '';
      _recordSeconds = 0;
      _isListening = true;
    });
    _recordTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _recordSeconds++);
    });

    if (_speechAvailable) {
      await _speech.listen(
        localeId: 'ar_SA',
        onResult: (r) {
          if (mounted) setState(() => _transcript = r.recognizedWords);
        },
        listenFor: const Duration(seconds: 20),
        pauseFor: const Duration(seconds: 3),
      );
    }
  }

  void _stopRecording() {
    _speech.stop();
    _stopRecordTimer();
    setState(() {
      _isListening = false;
      _stage = _Stage.reviewing;
    });
  }

  void _stopRecordTimer() {
    _recordTimer?.cancel();
    _recordTimer = null;
  }

  // ── Scoring ─────────────────────────────────────────────────────────────

  String _normalize(String text) {
    return text
        .replaceAll(RegExp(r'[ؐ-ًؚ-ٰٟ]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  double _similarity(String transcript, String expected) {
    final t = _normalize(transcript);
    final e = _normalize(expected);
    if (t.isEmpty || e.isEmpty) return 0;
    if (t == e) return 1.0;
    int matches = 0;
    final eChars = e.split('');
    for (final c in t.split('')) {
      if (eChars.contains(c)) matches++;
    }
    return (matches / e.length).clamp(0.0, 1.0);
  }

  AyahResult get _autoSuggestion {
    final sim = _similarity(_transcript, _ayah.arabic);
    if (sim >= 0.75) return AyahResult.correct;
    if (sim >= 0.40) return AyahResult.smallMistake;
    return AyahResult.wrong;
  }

  double get _autoScore =>
      _similarity(_transcript, _ayah.arabic);

  void _submit(AyahResult result) {
    _results.add(result);
    switch (result) {
      case AyahResult.correct:
        setState(() => _score += 10);
      case AyahResult.smallMistake:
        setState(() => _score += 5);
      case AyahResult.wrong:
        if (_lives > 0) setState(() => _lives--);
      case AyahResult.skipped:
        break;
    }
    _advanceAyah();
  }

  void _advanceAyah() {
    if (_isLastAyah) {
      final totalPossible = _surah.ayahCount * 10;
      ref.read(practiceHistoryProvider.notifier).addSession(
            PracticeSession(
              surahName: _surah.name,
              score: _score,
              totalPossible: totalPossible,
              ayahCount: _surah.ayahCount,
              mode: widget.mode,
              completedAt: DateTime.now(),
            ),
          );
      setState(() => _stage = _Stage.completed);
    } else {
      setState(() => _current++);
      _beginAyah();
    }
  }

  void _retryMistakes() {
    final wrongIndices = <int>[];
    for (var i = 0; i < _results.length; i++) {
      if (_results[i] != AyahResult.correct) wrongIndices.add(i);
    }
    if (wrongIndices.isEmpty) return;
    context.push(
      '/practice/session',
      extra: {
        'surahIndex': widget.surahIndex,
        'mode': widget.mode.name,
      },
    );
  }

  void _practiceAgain() {
    setState(() {
      _current = 0;
      _score = 0;
      _lives = 3;
      _results.clear();
      _transcript = '';
    });
    _beginAyah();
  }

  @override
  void dispose() {
    _playerSub?.cancel();
    _player.dispose();
    _waveCtrl.dispose();
    _micPulseCtrl.dispose();
    _countdownTimer?.cancel();
    _recordTimer?.cancel();
    _speech.stop();
    super.dispose();
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    if (_stage == _Stage.completed) {
      return _CompletionScreen(
        surah: _surah,
        results: _results,
        score: _score,
        lives: _lives,
        onPracticeAgain: _practiceAgain,
        onRetryMistakes: _retryMistakes,
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      appBar: _buildAppBar(l),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            children: [
              _buildProgressBar(l),
              const SizedBox(height: 16),
              Expanded(child: _buildAyahCard(l)),
              const SizedBox(height: 12),
              _buildStagePanel(l),
              const SizedBox(height: 8),
              _buildFooter(l),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppLocalizations l) {
    return AppBar(
      backgroundColor: AppTheme.surfaceWhite,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close_rounded, color: AppTheme.textDark),
        onPressed: () => _showEndConfirmation(l),
      ),
      titleSpacing: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _surah.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppTheme.textDark,
            ),
          ),
          Text(
            widget.mode.title(l),
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
      actions: [
        Row(
          children: List.generate(
            3,
            (i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Icon(
                Icons.favorite,
                size: 18,
                color: i < _lives ? Colors.red : Colors.grey.shade300,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: AppTheme.goldAccent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('⭐', style: TextStyle(fontSize: 13)),
              const SizedBox(width: 3),
              Text(
                '$_score',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.goldAccent,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l.session_ayahProgress(_current + 1, _surah.ayahCount),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            Text(
              '${((_current + 1) / _surah.ayahCount * 100).round()}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (_current + 1) / _surah.ayahCount,
            minHeight: 6,
            backgroundColor: AppTheme.primaryGreen.withValues(alpha: 0.12),
            valueColor: const AlwaysStoppedAnimation(AppTheme.primaryGreen),
          ),
        ),
        if (_results.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: List.generate(_surah.ayahCount, (i) {
                if (i >= _results.length) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE5E7EB),
                      shape: BoxShape.circle,
                    ),
                  );
                }
                final color = switch (_results[i]) {
                  AyahResult.correct => AppTheme.successGreen,
                  AyahResult.smallMistake => AppTheme.goldAccent,
                  AyahResult.wrong => AppTheme.errorRed,
                  AyahResult.skipped => AppTheme.textSecondary,
                };
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }

  Widget _buildAyahCard(AppLocalizations l) {
    final hideArabic = widget.mode == PracticeMode.memorisationTest &&
        (_stage == _Stage.countdown || _stage == _Stage.recording);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              l.session_ayahNumber(_current + 1),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryGreen,
              ),
            ),
          ),
          const SizedBox(height: 16),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: hideArabic
                ? Column(
                    key: const ValueKey('hidden'),
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color:
                              AppTheme.primaryGreen.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.psychology_rounded,
                            color: AppTheme.primaryGreen, size: 30),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l.session_reciteFromMemory,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                : Text(
                    key: ValueKey('arabic-$_current'),
                    _ayah.arabic,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontSize: 26,
                      height: 2.0,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                      fontFamily: 'Arial',
                    ),
                  ),
          ),

          const SizedBox(height: 12),

          if (!hideArabic) ...[
            GestureDetector(
              onTap: () => setState(
                  () => _showTransliteration = !_showTransliteration),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _showTransliteration
                    ? Text(
                        key: const ValueKey('translit-on'),
                        _ayah.transliteration,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.primaryGreen,
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      )
                    : Text(
                        key: const ValueKey('translit-off'),
                        l.session_showTransliteration,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.primaryGreen
                              .withValues(alpha: 0.6),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () =>
                  setState(() => _showTranslation = !_showTranslation),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _showTranslation
                    ? Text(
                        key: const ValueKey('trans-on'),
                        _ayah.translation,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                          height: 1.5,
                        ),
                      )
                    : Text(
                        key: const ValueKey('trans-off'),
                        l.session_showTranslation,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary
                              .withValues(alpha: 0.7),
                        ),
                      ),
              ),
            ),
          ],

          if (_stage == _Stage.reviewing && _transcript.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFE5E7EB)),
            const SizedBox(height: 12),
            Text(
              l.session_yourRecitation,
              style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              _transcript,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 16,
                color: _autoScore >= 0.75
                    ? AppTheme.successGreen
                    : _autoScore >= 0.4
                        ? AppTheme.goldAccent
                        : AppTheme.errorRed,
                fontWeight: FontWeight.w500,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 6),
            _SimilarityBar(score: _autoScore, l: l),
          ],

          if (_stage == _Stage.reviewing && _transcript.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                l.session_noSpeechDetected,
                style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.errorRed.withValues(alpha: 0.8)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStagePanel(AppLocalizations l) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: switch (_stage) {
        _Stage.aiPlayback => _AIPlaybackPanel(
            key: const ValueKey('ai'),
            waveCtrl: _waveCtrl,
            audioPlaying: _audioPlaying,
            onMyTurn: widget.mode == PracticeMode.turnTaking && !_isStudentTurn
                ? null
                : _onAIFinished,
            mode: widget.mode,
            l: l,
          ),
        _Stage.countdown => _CountdownPanel(
            key: const ValueKey('cd'),
            count: _countdown,
            l: l,
          ),
        _Stage.recording => _RecordingPanel(
            key: const ValueKey('rec'),
            seconds: _recordSeconds,
            isListening: _isListening,
            micPulse: _micPulse,
            onStop: _stopRecording,
            l: l,
          ),
        _Stage.reviewing => _ReviewingPanel(
            key: const ValueKey('rev'),
            suggestion: _autoSuggestion,
            onSubmit: _submit,
            onHearAgain: widget.mode != PracticeMode.memorisationTest
                ? _onHearAgain
                : null,
            isLastAyah: _isLastAyah,
            l: l,
          ),
        _Stage.completed => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildFooter(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextButton.icon(
        onPressed: () => _showEndConfirmation(l),
        icon: const Icon(Icons.stop_circle_outlined,
            color: AppTheme.errorRed, size: 18),
        label: Text(
          l.session_endSessionButton,
          style: const TextStyle(
              color: AppTheme.errorRed, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _showEndConfirmation(AppLocalizations l) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l.session_endSessionTitle),
        content: Text(l.session_endSessionBody(_results.length, _surah.ayahCount)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.common_continue),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/home/practice');
            },
            child: Text(l.session_end,
                style: const TextStyle(color: AppTheme.errorRed)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stage panel widgets
// ---------------------------------------------------------------------------

class _AIPlaybackPanel extends StatelessWidget {
  final AnimationController waveCtrl;
  final bool audioPlaying;
  final VoidCallback? onMyTurn;
  final PracticeMode mode;
  final AppLocalizations l;

  const _AIPlaybackPanel({
    super.key,
    required this.waveCtrl,
    required this.audioPlaying,
    required this.onMyTurn,
    required this.mode,
    required this.l,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppTheme.primaryGreen.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                audioPlaying
                    ? Icons.volume_up_rounded
                    : Icons.volume_off_rounded,
                color: AppTheme.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                audioPlaying
                    ? (mode == PracticeMode.turnTaking
                        ? l.session_aiTurnReciting
                        : l.session_aiReciting)
                    : l.session_loadingRecitation,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _WaveformBars(controller: waveCtrl, color: AppTheme.primaryGreen),
          if (onMyTurn != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onMyTurn,
                icon: const Icon(Icons.mic_rounded, size: 18),
                label: Text(l.session_myTurnButton),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CountdownPanel extends StatelessWidget {
  final int count;
  final AppLocalizations l;
  const _CountdownPanel({super.key, required this.count, required this.l});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppTheme.goldAccent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppTheme.goldAccent.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Text(
            count == 0 ? l.session_go : '$count',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: count == 0
                  ? AppTheme.successGreen
                  : AppTheme.goldAccent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l.session_getReady,
            style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _RecordingPanel extends StatelessWidget {
  final int seconds;
  final bool isListening;
  final Animation<double> micPulse;
  final VoidCallback onStop;
  final AppLocalizations l;

  const _RecordingPanel({
    super.key,
    required this.seconds,
    required this.isListening,
    required this.micPulse,
    required this.onStop,
    required this.l,
  });

  String get _display {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.errorRed.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppTheme.errorRed.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onStop,
            child: AnimatedBuilder(
              animation: micPulse,
              builder: (_, child) => Transform.scale(
                scale: isListening ? micPulse.value : 1.0,
                child: child,
              ),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.errorRed,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.errorRed.withValues(alpha: 0.4),
                      blurRadius: 14,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: const Icon(Icons.stop_rounded,
                    color: Colors.white, size: 28),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.session_recording,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.errorRed,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l.session_tapToStop,
                  style: const TextStyle(
                      fontSize: 12, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 6),
                _LiveWaveform(),
              ],
            ),
          ),
          Text(
            _display,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewingPanel extends StatelessWidget {
  final AyahResult suggestion;
  final void Function(AyahResult) onSubmit;
  final VoidCallback? onHearAgain;
  final bool isLastAyah;
  final AppLocalizations l;

  const _ReviewingPanel({
    super.key,
    required this.suggestion,
    required this.onSubmit,
    required this.onHearAgain,
    required this.isLastAyah,
    required this.l,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(Icons.auto_awesome_rounded,
                  size: 16, color: AppTheme.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l.session_aiSuggestion(suggestion.label(l)),
                  style: const TextStyle(
                      fontSize: 12, color: AppTheme.textSecondary),
                ),
              ),
            ],
          ),
        ),

        Row(
          children: [
            Expanded(
              child: _AssessButton(
                label: l.session_correct,
                icon: Icons.check_circle_rounded,
                color: AppTheme.successGreen,
                isHighlighted: suggestion == AyahResult.correct,
                onTap: () => onSubmit(AyahResult.correct),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _AssessButton(
                label: l.session_smallMistake,
                icon: Icons.warning_amber_rounded,
                color: AppTheme.goldAccent,
                isHighlighted: suggestion == AyahResult.smallMistake,
                onTap: () => onSubmit(AyahResult.smallMistake),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _AssessButton(
                label: l.session_wrong,
                icon: Icons.cancel_rounded,
                color: AppTheme.errorRed,
                isHighlighted: suggestion == AyahResult.wrong,
                onTap: () => onSubmit(AyahResult.wrong),
              ),
            ),
          ],
        ),
        if (onHearAgain != null || true)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                if (onHearAgain != null)
                  Expanded(
                    child: TextButton.icon(
                      onPressed: onHearAgain,
                      icon: const Icon(Icons.replay_rounded, size: 16),
                      label: Text(l.session_hearAgain),
                      style: TextButton.styleFrom(
                          foregroundColor: AppTheme.primaryGreen),
                    ),
                  ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => onSubmit(AyahResult.skipped),
                    icon: const Icon(Icons.skip_next_rounded, size: 16),
                    label: Text(isLastAyah ? l.session_finish : l.session_skip),
                    style: TextButton.styleFrom(
                        foregroundColor: AppTheme.textSecondary),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Completion screen
// ---------------------------------------------------------------------------

class _CompletionScreen extends StatelessWidget {
  final SurahData surah;
  final List<AyahResult> results;
  final int score;
  final int lives;
  final VoidCallback onPracticeAgain;
  final VoidCallback onRetryMistakes;

  const _CompletionScreen({
    required this.surah,
    required this.results,
    required this.score,
    required this.lives,
    required this.onPracticeAgain,
    required this.onRetryMistakes,
  });

  int get _correct =>
      results.where((r) => r == AyahResult.correct).length;
  int get _mistakes =>
      results.where((r) => r == AyahResult.smallMistake).length;
  int get _wrong =>
      results.where((r) => r == AyahResult.wrong).length;
  int get _totalPossible => surah.ayahCount * 10;

  double get _accuracy =>
      _totalPossible == 0 ? 0 : score / _totalPossible;

  String get _grade {
    if (_accuracy >= 0.90) return 'A';
    if (_accuracy >= 0.75) return 'B';
    if (_accuracy >= 0.60) return 'C';
    return 'D';
  }

  Color get _gradeColor {
    if (_accuracy >= 0.90) return AppTheme.successGreen;
    if (_accuracy >= 0.75) return AppTheme.primaryGreen;
    if (_accuracy >= 0.60) return AppTheme.goldAccent;
    return AppTheme.errorRed;
  }

  String _message(AppLocalizations l) {
    if (_accuracy >= 0.90) return l.session_completionGradeA;
    if (_accuracy >= 0.75) return l.session_completionGradeB;
    if (_accuracy >= 0.60) return l.session_completionGradeC;
    return l.session_completionGradeD;
  }

  bool get _hasMistakes => _mistakes + _wrong > 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.go('/home/practice'),
        ),
        title: Text(l.session_completionTitle),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_gradeColor, _gradeColor.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _gradeColor.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: Column(
              children: [
                Text(
                  _grade,
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  surah.name,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _GradeStat(label: l.session_scoreLabel, value: '$score pts', icon: '⭐'),
                    _GradeStat(
                        label: l.session_accuracyLabel,
                        value: '${(_accuracy * 100).round()}%',
                        icon: '🎯'),
                    _GradeStat(
                        label: l.session_livesLeftLabel, value: '$lives', icon: '❤️'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              _message(l),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: AppTheme.textDark,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            l.session_ayahBreakdown,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(results.length, (i) {
            final result = results[i];
            final ayah = surah.ayahs[i];
            final (color, icon) = switch (result) {
              AyahResult.correct => (AppTheme.successGreen, Icons.check_circle_rounded),
              AyahResult.smallMistake => (AppTheme.goldAccent, Icons.warning_amber_rounded),
              AyahResult.wrong => (AppTheme.errorRed, Icons.cancel_rounded),
              AyahResult.skipped => (AppTheme.textSecondary, Icons.skip_next_rounded),
            };
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border(
                  left: BorderSide(color: color, width: 3),
                ),
              ),
              child: Row(
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.session_ayahNumber(i + 1),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          ayah.transliteration,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textDark,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    result.label(l),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SummaryChip(count: _correct, label: l.session_correct, color: AppTheme.successGreen),
                _SummaryChip(count: _mistakes, label: l.session_mistakes, color: AppTheme.goldAccent),
                _SummaryChip(count: _wrong, label: l.session_wrong, color: AppTheme.errorRed),
              ],
            ),
          ),
          const SizedBox(height: 24),

          if (_hasMistakes)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: onRetryMistakes,
                icon: const Icon(Icons.replay_rounded),
                label: Text(l.session_retryMistakes),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.goldAccent,
                ),
              ),
            ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onPracticeAgain,
              child: Text(l.session_practiceAgain),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () => context.go('/home/practice'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.primaryGreen),
                foregroundColor: AppTheme.primaryGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(l.session_backToPractice),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared micro-widgets
// ---------------------------------------------------------------------------

class _AssessButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isHighlighted;
  final VoidCallback onTap;

  const _AssessButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.isHighlighted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isHighlighted
              ? color.withValues(alpha: 0.18)
              : color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHighlighted
                ? color
                : color.withValues(alpha: 0.25),
            width: isHighlighted ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isHighlighted ? FontWeight.w800 : FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SimilarityBar extends StatelessWidget {
  final double score;
  final AppLocalizations l;
  const _SimilarityBar({required this.score, required this.l});

  Color get _color {
    if (score >= 0.75) return AppTheme.successGreen;
    if (score >= 0.4) return AppTheme.goldAccent;
    return AppTheme.errorRed;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l.session_matchScore,
                style: const TextStyle(
                    fontSize: 10, color: AppTheme.textSecondary)),
            Text(
              '${(score * 100).round()}%',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: _color),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: score,
            minHeight: 5,
            backgroundColor: _color.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation(_color),
          ),
        ),
      ],
    );
  }
}

class _WaveformBars extends StatelessWidget {
  final AnimationController controller;
  final Color color;
  const _WaveformBars({required this.controller, required this.color});

  @override
  Widget build(BuildContext context) {
    const barCount = 18;
    return SizedBox(
      height: 32,
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(barCount, (i) {
            final phase = (i / barCount) * 2 * math.pi;
            final t = controller.value * 2 * math.pi;
            final h = (math.sin(t + phase) * 0.5 + 0.5) * 24 + 4;
            return Container(
              width: 3,
              height: h,
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.6 + 0.4 * (h / 28)),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _LiveWaveform extends StatefulWidget {
  const _LiveWaveform();

  @override
  State<_LiveWaveform> createState() => _LiveWaveformState();
}

class _LiveWaveformState extends State<_LiveWaveform>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _WaveformBars(controller: _ctrl, color: AppTheme.errorRed);
  }
}

class _GradeStat extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  const _GradeStat(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800)),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  const _SummaryChip(
      {required this.count, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$count',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w900, color: color)),
        Text(label,
            style: const TextStyle(
                fontSize: 12, color: AppTheme.textSecondary)),
      ],
    );
  }
}
