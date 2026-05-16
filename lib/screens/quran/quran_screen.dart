import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/quran_data.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/quran_provider.dart';
import '../../theme/app_theme.dart';

class QuranScreen extends ConsumerStatefulWidget {
  const QuranScreen({super.key});

  @override
  ConsumerState<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends ConsumerState<QuranScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  // Internal filter keys — not shown directly to the user
  String _filter = 'All'; // 'All' | 'Meccan' | 'Medinan'

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<QuranSurah> get _filtered {
    return allSurahs.where((s) {
      final matchesSearch = _query.isEmpty ||
          s.name.toLowerCase().contains(_query.toLowerCase()) ||
          s.arabicName.contains(_query) ||
          s.meaning.toLowerCase().contains(_query.toLowerCase()) ||
          s.number.toString() == _query;
      final matchesFilter = _filter == 'All' ||
          (_filter == 'Meccan' && s.isMeccan) ||
          (_filter == 'Medinan' && !s.isMeccan);
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _openPlayer(QuranSurah surah) {
    context.push('/quran/player', extra: surah);
  }

  void _showLanguagePicker(BuildContext context, AppLocalizations l, String current) {
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
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            ...translationEditions.keys.map((lang) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(lang,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500)),
                  trailing: lang == current
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

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(quranPrefsProvider);
    final surahs = _filtered;

    // Build filter chip data: internal key -> display label
    final filters = [
      ('All', l.quran_filterAll),
      ('Meccan', l.quran_filterMeccan),
      ('Medinan', l.quran_filterMedinan),
    ];

    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppTheme.surfaceWhite,
            elevation: 0,
            automaticallyImplyLeading: false,
            titleSpacing: 16,
            title: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.quran_arabicTitle,
                          style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500)),
                      Text(l.quran_englishTitle,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textDark)),
                    ],
                  ),
                ),
                // Page view toggle
                IconButton(
                  icon: const Icon(Icons.menu_book_rounded,
                      color: AppTheme.primaryGreen),
                  tooltip: 'Mushaf page view',
                  onPressed: () => context.push('/quran/pages'),
                ),
                // Language selector
                GestureDetector(
                  onTap: () =>
                      _showLanguagePicker(context, l, prefs.language),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.language_rounded,
                            size: 14, color: AppTheme.primaryGreen),
                        const SizedBox(width: 4),
                        Text(
                          prefs.language,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: Column(
                children: [
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (v) => setState(() => _query = v),
                      decoration: InputDecoration(
                        hintText: l.quran_searchHint,
                        hintStyle: const TextStyle(
                            color: AppTheme.textSecondary),
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: AppTheme.textSecondary),
                        suffixIcon: _query.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded,
                                    color: AppTheme.textSecondary),
                                onPressed: () {
                                  _searchCtrl.clear();
                                  setState(() => _query = '');
                                },
                              )
                            : null,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                        fillColor: AppTheme.warmBackground,
                        filled: true,
                      ),
                    ),
                  ),
                  // Filter chips
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      children: filters
                          .map((entry) {
                            final key = entry.$1;
                            final label = entry.$2;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _filter = key),
                              child: AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 180),
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _filter == key
                                      ? AppTheme.primaryGreen
                                      : const Color(0xFFE5E7EB),
                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),
                                child: Text(
                                  label,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _filter == key
                                        ? Colors.white
                                        : AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                            );
                          })
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          if (surahs.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text(l.quran_noSurahsFound,
                    style: const TextStyle(color: AppTheme.textSecondary)),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _SurahCard(
                    surah: surahs[i],
                    onTap: () => _openPlayer(surahs[i]),
                  ),
                  childCount: surahs.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _SurahCard extends StatelessWidget {
  final QuranSurah surah;
  final VoidCallback onTap;
  const _SurahCard({required this.surah, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            // Number in circle
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: AppTheme.primaryGreen,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${surah.number}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Name + meaning
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        surah.meaning,
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: surah.isMeccan
                              ? AppTheme.goldAccent
                                  .withValues(alpha: 0.12)
                              : AppTheme.primaryGreen
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          surah.isMeccan
                              ? l.quran_typeMeccan
                              : l.quran_typeMedinan,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: surah.isMeccan
                                ? AppTheme.goldAccent
                                : AppTheme.primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Arabic name + ayah count
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  surah.arabicName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 2),
                Text(
                  '${surah.ayahCount} ayahs',
                  style: const TextStyle(
                      fontSize: 11, color: AppTheme.textSecondary),
                ),
              ],
            ),
            const SizedBox(width: 8),
            const Icon(Icons.play_circle_outline_rounded,
                color: AppTheme.primaryGreen, size: 22),
          ],
        ),
      ),
    );
  }
}
