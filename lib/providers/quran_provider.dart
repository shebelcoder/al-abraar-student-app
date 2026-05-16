import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/quran_data.dart';

// ---------------------------------------------------------------------------
// User preferences for Quran player
// ---------------------------------------------------------------------------

class QuranPrefs {
  final Reciter reciter;
  final String language; // 'English' | 'Arabic' | 'French' | 'Somali'
  final int repetitionsPerAyah; // 1, 3, 5, 10, 25

  const QuranPrefs({
    required this.reciter,
    required this.language,
    required this.repetitionsPerAyah,
  });

  QuranPrefs copyWith({
    Reciter? reciter,
    String? language,
    int? repetitionsPerAyah,
  }) =>
      QuranPrefs(
        reciter: reciter ?? this.reciter,
        language: language ?? this.language,
        repetitionsPerAyah: repetitionsPerAyah ?? this.repetitionsPerAyah,
      );
}

class QuranPrefsNotifier extends Notifier<QuranPrefs> {
  @override
  QuranPrefs build() => QuranPrefs(
        reciter: quranReciters.first,
        language: 'English',
        repetitionsPerAyah: 1,
      );

  void setReciter(Reciter r) => state = state.copyWith(reciter: r);
  void setLanguage(String l) => state = state.copyWith(language: l);
  void setRepetitions(int n) =>
      state = state.copyWith(repetitionsPerAyah: n);
}

final quranPrefsProvider =
    NotifierProvider<QuranPrefsNotifier, QuranPrefs>(QuranPrefsNotifier.new);

// ---------------------------------------------------------------------------
// Arabic text + translation loader  (cached per surah + language)
// ---------------------------------------------------------------------------

class QuranAyah {
  final int number; // 1-indexed within surah
  final String arabic;
  final String translation;

  const QuranAyah({
    required this.number,
    required this.arabic,
    required this.translation,
  });
}

final _dio = Dio(BaseOptions(
  connectTimeout: const Duration(seconds: 15),
  receiveTimeout: const Duration(seconds: 20),
));

/// Loads [arabic text, translation] for a surah from api.alquran.cloud.
/// Cached automatically by Riverpod's FutureProvider.family.
final quranAyahsProvider =
    FutureProvider.family<List<QuranAyah>, (int surahNumber, String language)>(
        (ref, args) async {
  final (surahNumber, language) = args;
  final edition = translationEditions[language] ?? 'en.sahih';

  // Two parallel calls: Arabic text + translation
  final results = await Future.wait([
    _dio.get('https://api.alquran.cloud/v1/surah/$surahNumber/quran-simple'),
    _dio.get('https://api.alquran.cloud/v1/surah/$surahNumber/$edition'),
  ]);

  final arabicAyahs =
      (results[0].data['data']['ayahs'] as List<dynamic>);
  final translatedAyahs =
      (results[1].data['data']['ayahs'] as List<dynamic>);

  return List.generate(arabicAyahs.length, (i) {
    return QuranAyah(
      number: i + 1,
      arabic: arabicAyahs[i]['text'] as String,
      translation: translatedAyahs[i]['text'] as String,
    );
  });
});
