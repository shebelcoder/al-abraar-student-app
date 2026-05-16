class AyahData {
  final String arabic;
  final String transliteration;
  final String translation;
  const AyahData({
    required this.arabic,
    required this.transliteration,
    required this.translation,
  });
}

class SurahData {
  final int number;
  final String name;
  final String arabicName;
  final String meaning;
  final bool isBeginner;
  final List<AyahData> ayahs;
  const SurahData({
    required this.number,
    required this.name,
    required this.arabicName,
    required this.meaning,
    required this.isBeginner,
    required this.ayahs,
  });
  int get ayahCount => ayahs.length;
}

const List<SurahData> practiseSurahs = [
  SurahData(
    number: 1,
    name: 'Al-Fatiha',
    arabicName: 'الفاتحة',
    meaning: 'The Opening',
    isBeginner: true,
    ayahs: [
      AyahData(
        arabic: 'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ',
        transliteration: 'Bismillāhir-raḥmānir-raḥīm',
        translation: 'In the name of Allah, the Most Gracious, the Most Merciful',
      ),
      AyahData(
        arabic: 'ٱلۡحَمۡدُ لِلَّهِ رَبِّ ٱلۡعَٰلَمِينَ',
        transliteration: 'Al-ḥamdu lillāhi rabbil-ʿālamīn',
        translation: 'All praise is due to Allah, Lord of all the worlds',
      ),
      AyahData(
        arabic: 'ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ',
        transliteration: 'Ar-raḥmānir-raḥīm',
        translation: 'The Most Gracious, the Most Merciful',
      ),
      AyahData(
        arabic: 'مَٰلِكِ يَوۡمِ ٱلدِّينِ',
        transliteration: 'Māliki yawmid-dīn',
        translation: 'Master of the Day of Judgment',
      ),
      AyahData(
        arabic: 'إِيَّاكَ نَعۡبُدُ وَإِيَّاكَ نَسۡتَعِينُ',
        transliteration: 'Iyyāka naʿbudu wa iyyāka nastaʿīn',
        translation: 'You alone we worship, and You alone we ask for help',
      ),
      AyahData(
        arabic: 'ٱهۡدِنَا ٱلصِّرَٰطَ ٱلۡمُسۡتَقِيمَ',
        transliteration: 'Ihdinaṣ-ṣirāṭal-mustaqīm',
        translation: 'Guide us to the straight path',
      ),
      AyahData(
        arabic:
            'صِرَٰطَ ٱلَّذِينَ أَنۡعَمۡتَ عَلَيۡهِمۡ غَيۡرِ ٱلۡمَغۡضُوبِ عَلَيۡهِمۡ وَلَا ٱلضَّآلِّينَ',
        transliteration:
            'Ṣirāṭal-ladhīna anʿamta ʿalayhim ghayril-maghḍūbi ʿalayhim wa laḍ-ḍāllīn',
        translation:
            'The path of those upon whom You have bestowed favour — not of those who have evoked anger, nor of those who are astray',
      ),
    ],
  ),
  SurahData(
    number: 112,
    name: 'Al-Ikhlas',
    arabicName: 'الإخلاص',
    meaning: 'Sincerity',
    isBeginner: true,
    ayahs: [
      AyahData(
        arabic: 'قُلۡ هُوَ ٱللَّهُ أَحَدٌ',
        transliteration: 'Qul huwallāhu aḥad',
        translation: 'Say: He is Allah, the One',
      ),
      AyahData(
        arabic: 'ٱللَّهُ ٱلصَّمَدُ',
        transliteration: 'Allāhuṣ-ṣamad',
        translation: 'Allah, the Eternal Refuge',
      ),
      AyahData(
        arabic: 'لَمۡ يَلِدۡ وَلَمۡ يُولَدۡ',
        transliteration: 'Lam yalid wa lam yūlad',
        translation: 'He neither begets nor is born',
      ),
      AyahData(
        arabic: 'وَلَمۡ يَكُن لَّهُۥ كُفُوًا أَحَدٌۢ',
        transliteration: 'Wa lam yakun lahū kufuwan aḥad',
        translation: 'Nor is there to Him any equivalent',
      ),
    ],
  ),
  SurahData(
    number: 113,
    name: 'Al-Falaq',
    arabicName: 'الفلق',
    meaning: 'The Daybreak',
    isBeginner: true,
    ayahs: [
      AyahData(
        arabic: 'قُلۡ أَعُوذُ بِرَبِّ ٱلۡفَلَقِ',
        transliteration: 'Qul aʿūdhu bi-rabbil-falaq',
        translation: 'Say: I seek refuge in the Lord of daybreak',
      ),
      AyahData(
        arabic: 'مِن شَرِّ مَا خَلَقَ',
        transliteration: 'Min sharri mā khalaq',
        translation: 'From the evil of that which He created',
      ),
      AyahData(
        arabic: 'وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ',
        transliteration: 'Wa min sharri ghāsiqin idhā waqab',
        translation: 'And from the evil of darkness when it settles',
      ),
      AyahData(
        arabic: 'وَمِن شَرِّ ٱلنَّفَّٰثَٰتِ فِي ٱلۡعُقَدِ',
        transliteration: 'Wa min sharrin-naffāthāti fil-ʿuqad',
        translation: 'And from the evil of the blowers in knots',
      ),
      AyahData(
        arabic: 'وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ',
        transliteration: 'Wa min sharri ḥāsidin idhā ḥasad',
        translation: 'And from the evil of an envier when he envies',
      ),
    ],
  ),
  SurahData(
    number: 114,
    name: 'An-Nas',
    arabicName: 'الناس',
    meaning: 'Mankind',
    isBeginner: true,
    ayahs: [
      AyahData(
        arabic: 'قُلۡ أَعُوذُ بِرَبِّ ٱلنَّاسِ',
        transliteration: 'Qul aʿūdhu bi-rabbinnās',
        translation: 'Say: I seek refuge in the Lord of mankind',
      ),
      AyahData(
        arabic: 'مَلِكِ ٱلنَّاسِ',
        transliteration: 'Malikinnās',
        translation: 'The Sovereign of mankind',
      ),
      AyahData(
        arabic: 'إِلَٰهِ ٱلنَّاسِ',
        transliteration: 'Ilāhinnās',
        translation: 'The God of mankind',
      ),
      AyahData(
        arabic: 'مِن شَرِّ ٱلۡوَسۡوَاسِ ٱلۡخَنَّاسِ',
        transliteration: 'Min sharril-waswāsil-khannās',
        translation: 'From the evil of the retreating whisperer',
      ),
      AyahData(
        arabic: 'ٱلَّذِي يُوَسۡوِسُ فِي صُدُورِ ٱلنَّاسِ',
        transliteration: 'Alladhī yuwaswisu fī ṣudūrinnās',
        translation: 'Who whispers into the breasts of mankind',
      ),
      AyahData(
        arabic: 'مِنَ ٱلۡجِنَّةِ وَٱلنَّاسِ',
        transliteration: 'Minal-jinnati wannās',
        translation: 'From among the jinn and mankind',
      ),
    ],
  ),
  SurahData(
    number: 110,
    name: 'An-Nasr',
    arabicName: 'النصر',
    meaning: 'The Victory',
    isBeginner: false,
    ayahs: [
      AyahData(
        arabic: 'إِذَا جَآءَ نَصۡرُ ٱللَّهِ وَٱلۡفَتۡحُ',
        transliteration: 'Idhā jāʾa naṣrullāhi wal-fatḥ',
        translation: 'When the victory of Allah has come and the conquest',
      ),
      AyahData(
        arabic: 'وَرَأَيۡتَ ٱلنَّاسَ يَدۡخُلُونَ فِي دِينِ ٱللَّهِ أَفۡوَاجًا',
        transliteration:
            'Wa raʾaytan-nāsa yadkhulūna fī dīnillāhi afwājā',
        translation:
            'And you see the people entering into the religion of Allah in multitudes',
      ),
      AyahData(
        arabic:
            'فَسَبِّحۡ بِحَمۡدِ رَبِّكَ وَٱسۡتَغۡفِرۡهُۚ إِنَّهُۥ كَانَ تَوَّابَۢا',
        transliteration:
            'Fasabbiḥ biḥamdi rabbika wastaghfirh; innahū kāna tawwābā',
        translation:
            'Then exalt with praise of your Lord and ask His forgiveness. Indeed, He is ever accepting of repentance',
      ),
    ],
  ),
];
