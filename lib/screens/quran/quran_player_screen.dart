import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/quran_data.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/quran_provider.dart';
import '../../theme/app_theme.dart';

class QuranPlayerScreen extends ConsumerStatefulWidget {
  final QuranSurah surah;
  const QuranPlayerScreen({super.key, required this.surah});

  @override
  ConsumerState<QuranPlayerScreen> createState() =>
      _QuranPlayerScreenState();
}

class _QuranPlayerScreenState extends ConsumerState<QuranPlayerScreen>
    with SingleTickerProviderStateMixin {
  final _scrollCtrl = ScrollController();
  late AudioPlayer _player;
  StreamSubscription<PlayerState>? _playerSub;

  // Playback state
  int _currentAyah = 1; // 1-indexed
  bool _isPlaying = false;
  bool _isLoading = false;
  int _repLeft = 1; // repetitions remaining for current ayah

  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _playerSub = _player.playerStateStream.listen((ps) {
      if (!mounted) return;
      setState(() => _isLoading =
          ps.processingState == ProcessingState.loading ||
              ps.processingState == ProcessingState.buffering);

      if (ps.processingState == ProcessingState.completed) {
        _onAyahFinished();
      }
    });
  }

  @override
  void dispose() {
    _playerSub?.cancel();
    _player.dispose();
    _pulseCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ── Audio control ─────────────────────────────────────────────────────────

  String _audioUrl(int ayah) {
    final prefs = ref.read(quranPrefsProvider);
    return prefs.reciter.audioUrl(widget.surah.number, ayah);
  }

  Future<void> _playAyah(int ayahNumber) async {
    setState(() {
      _currentAyah = ayahNumber;
      _repLeft = ref.read(quranPrefsProvider).repetitionsPerAyah;
      _isPlaying = true;
    });
    _scrollToAyah(ayahNumber);
    try {
      await _player.setUrl(_audioUrl(ayahNumber));
      await _player.play();
    } catch (_) {
      // Network error — skip to next after a brief pause
      Future.delayed(const Duration(seconds: 1), _onAyahFinished);
    }
  }

  void _onAyahFinished() {
    if (!mounted) return;
    if (_repLeft > 1) {
      // Repeat current ayah
      setState(() => _repLeft--);
      _player.seek(Duration.zero).then((_) => _player.play());
    } else if (_currentAyah < widget.surah.ayahCount) {
      // Advance to next ayah
      _playAyah(_currentAyah + 1);
    } else {
      // Surah complete
      setState(() => _isPlaying = false);
      _showCompletionDialog();
    }
  }

  Future<void> _togglePlay(List<QuranAyah> ayahs) async {
    if (_isPlaying) {
      await _player.pause();
      setState(() => _isPlaying = false);
    } else {
      if (_player.processingState == ProcessingState.idle ||
          _player.processingState == ProcessingState.completed) {
        await _playAyah(_currentAyah);
      } else {
        await _player.play();
        setState(() => _isPlaying = true);
      }
    }
  }

  void _prevAyah() {
    if (_currentAyah > 1) _playAyah(_currentAyah - 1);
  }

  void _nextAyah() {
    if (_currentAyah < widget.surah.ayahCount) {
      _playAyah(_currentAyah + 1);
    }
  }

  void _scrollToAyah(int ayahNumber) {
    final itemH = 140.0;
    final offset = (ayahNumber - 1) * itemH - 80;
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        math.max(0, offset),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  // ── Pickers ───────────────────────────────────────────────────────────────

  void _showReciterPicker() {
    final l = AppLocalizations.of(context);
    final prefs = ref.read(quranPrefsProvider);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.quran_player_chooseReciter,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            ...quranReciters.map((r) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(r.name,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: Text(r.arabicName,
                      style: const TextStyle(
                          color: AppTheme.textSecondary)),
                  trailing: r.id == prefs.reciter.id
                      ? const Icon(Icons.check_rounded,
                          color: AppTheme.primaryGreen)
                      : null,
                  onTap: () {
                    ref
                        .read(quranPrefsProvider.notifier)
                        .setReciter(r);
                    Navigator.pop(context);
                    // Restart current ayah with new reciter
                    if (_isPlaying) _playAyah(_currentAyah);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showRepetitionPicker() {
    final l = AppLocalizations.of(context);
    final prefs = ref.read(quranPrefsProvider);
    const options = [1, 3, 5, 10, 25];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.quran_player_repetitionsTitle,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(
                l.quran_player_repetitionsDesc,
                style: const TextStyle(
                    fontSize: 13, color: AppTheme.textSecondary)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: options.map((n) {
                final selected = n == prefs.repetitionsPerAyah;
                return GestureDetector(
                  onTap: () {
                    ref
                        .read(quranPrefsProvider.notifier)
                        .setRepetitions(n);
                    Navigator.pop(context);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppTheme.primaryGreen
                          : const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$n',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: selected
                                ? Colors.white
                                : AppTheme.textDark,
                          ),
                        ),
                        Text(
                          l.quran_player_time(n),
                          style: TextStyle(
                            fontSize: 9,
                            color: selected
                                ? Colors.white70
                                : AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker() {
    final l = AppLocalizations.of(context);
    final prefs = ref.read(quranPrefsProvider);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.quran_translationLanguage,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            ...translationEditions.keys.map((lang) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(lang,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500)),
                  trailing: lang == prefs.language
                      ? const Icon(Icons.check_rounded,
                          color: AppTheme.primaryGreen)
                      : null,
                  onTap: () {
                    ref
                        .read(quranPrefsProvider.notifier)
                        .setLanguage(lang);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  // ── Completion ────────────────────────────────────────────────────────────

  void _showCompletionDialog() {
    final l = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 52)),
            const SizedBox(height: 12),
            Text(
              l.quran_player_completionTitle(widget.surah.name),
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              l.quran_player_completionMessage,
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _playAyah(1); // Restart
            },
            child: Text(l.quran_player_listenAgain),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.common_done),
          ),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(quranPrefsProvider);
    final ayahsAsync = ref.watch(
        quranAyahsProvider((widget.surah.number, prefs.language)));

    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.surah.name,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark)),
            Text(prefs.reciter.name,
                style: const TextStyle(
                    fontSize: 11, color: AppTheme.textSecondary)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language_rounded,
                color: AppTheme.primaryGreen),
            tooltip: l.quran_translationLanguage,
            onPressed: _showLanguagePicker,
          ),
        ],
      ),
      body: ayahsAsync.when(
        loading: () => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppTheme.primaryGreen),
              const SizedBox(height: 16),
              Text(l.session_loadingRecitation,
                  style: const TextStyle(color: AppTheme.textSecondary)),
            ],
          ),
        ),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off_rounded,
                    size: 48, color: AppTheme.textSecondary),
                const SizedBox(height: 16),
                Text(l.quran_player_loadingError,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(l.common_error_noInternet,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppTheme.textSecondary)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => ref.invalidate(quranAyahsProvider),
                  child: Text(l.common_retry),
                ),
              ],
            ),
          ),
        ),
        data: (ayahs) => Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: _currentAyah / widget.surah.ayahCount,
              backgroundColor:
                  AppTheme.primaryGreen.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation(
                  AppTheme.primaryGreen),
              minHeight: 3,
            ),

            // Ayah list
            Expanded(
              child: ListView.builder(
                controller: _scrollCtrl,
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                itemCount: ayahs.length,
                itemBuilder: (_, i) {
                  final ayah = ayahs[i];
                  final isCurrent = ayah.number == _currentAyah;
                  return _AyahCard(
                    ayah: ayah,
                    isCurrent: isCurrent,
                    isPlaying: isCurrent && _isPlaying,
                    repetitionsLeft: isCurrent ? _repLeft : 0,
                    totalRepetitions: prefs.repetitionsPerAyah,
                    pulseCtrl: _pulseCtrl,
                    onTap: () => _playAyah(ayah.number),
                  );
                },
              ),
            ),

            // Controls bar
            _ControlsBar(
              isPlaying: _isPlaying,
              isLoading: _isLoading,
              currentAyah: _currentAyah,
              totalAyahs: widget.surah.ayahCount,
              reciterName: prefs.reciter.name,
              repetitions: prefs.repetitionsPerAyah,
              onPrev: _currentAyah > 1 ? _prevAyah : null,
              onNext: _currentAyah < widget.surah.ayahCount
                  ? _nextAyah
                  : null,
              onPlayPause: () => _togglePlay(ayahs),
              onReciterTap: _showReciterPicker,
              onRepeatTap: _showRepetitionPicker,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Ayah card
// ---------------------------------------------------------------------------

class _AyahCard extends StatelessWidget {
  final QuranAyah ayah;
  final bool isCurrent;
  final bool isPlaying;
  final int repetitionsLeft;
  final int totalRepetitions;
  final AnimationController pulseCtrl;
  final VoidCallback onTap;

  const _AyahCard({
    required this.ayah,
    required this.isCurrent,
    required this.isPlaying,
    required this.repetitionsLeft,
    required this.totalRepetitions,
    required this.pulseCtrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCurrent
              ? AppTheme.primaryGreen.withValues(alpha: 0.06)
              : AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border(
            left: BorderSide(
              color: isCurrent
                  ? AppTheme.primaryGreen
                  : Colors.transparent,
              width: 3,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ayah number + playing indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? AppTheme.primaryGreen
                        : const Color(0xFFE5E7EB),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${ayah.number}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: isCurrent
                            ? Colors.white
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
                if (isPlaying && totalRepetitions > 1)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$repetitionsLeft/$totalRepetitions ×',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  ),
                if (isPlaying && totalRepetitions == 1)
                  AnimatedBuilder(
                    animation: pulseCtrl,
                    builder: (_, __) => Icon(
                      Icons.volume_up_rounded,
                      color: AppTheme.primaryGreen
                          .withValues(alpha: 0.5 + 0.5 * pulseCtrl.value),
                      size: 18,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Arabic text
            Text(
              ayah.arabic,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 22,
                height: 1.8,
                fontWeight: FontWeight.w500,
                color: isCurrent
                    ? AppTheme.primaryGreen
                    : AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 10),
            // Divider
            Container(height: 1, color: const Color(0xFFE5E7EB)),
            const SizedBox(height: 10),
            // Translation
            Text(
              ayah.translation,
              style: TextStyle(
                fontSize: 13,
                color: isCurrent
                    ? AppTheme.textDark
                    : AppTheme.textSecondary,
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Controls bar
// ---------------------------------------------------------------------------

class _ControlsBar extends StatelessWidget {
  final bool isPlaying;
  final bool isLoading;
  final int currentAyah;
  final int totalAyahs;
  final String reciterName;
  final int repetitions;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final VoidCallback onPlayPause;
  final VoidCallback onReciterTap;
  final VoidCallback onRepeatTap;

  const _ControlsBar({
    required this.isPlaying,
    required this.isLoading,
    required this.currentAyah,
    required this.totalAyahs,
    required this.reciterName,
    required this.repetitions,
    required this.onPrev,
    required this.onNext,
    required this.onPlayPause,
    required this.onReciterTap,
    required this.onRepeatTap,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ayah counter + reciter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: onReciterTap,
                    child: Row(
                      children: [
                        const Icon(Icons.person_outline_rounded,
                            size: 14, color: AppTheme.primaryGreen),
                        const SizedBox(width: 4),
                        Text(
                          reciterName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down_rounded,
                            size: 16, color: AppTheme.primaryGreen),
                      ],
                    ),
                  ),
                  Text(
                    l.quran_player_ayahCounter(currentAyah, totalAyahs),
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.textSecondary),
                  ),
                  GestureDetector(
                    onTap: onRepeatTap,
                    child: Row(
                      children: [
                        const Icon(Icons.repeat_rounded,
                            size: 14, color: AppTheme.primaryGreen),
                        const SizedBox(width: 4),
                        Text(
                          '$repetitions×',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Playback controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Prev
                  IconButton(
                    onPressed: onPrev,
                    icon: Icon(
                      Icons.skip_previous_rounded,
                      size: 32,
                      color: onPrev != null
                          ? AppTheme.textDark
                          : AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Play / Pause
                  GestureDetector(
                    onTap: onPlayPause,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.5),
                            )
                          : Icon(
                              isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Next
                  IconButton(
                    onPressed: onNext,
                    icon: Icon(
                      Icons.skip_next_rounded,
                      size: 32,
                      color: onNext != null
                          ? AppTheme.textDark
                          : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
