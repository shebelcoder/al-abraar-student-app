class QuranSurah {
  final int number;
  final String name;
  final String arabicName;
  final String meaning;
  final int ayahCount;
  final bool isMeccan;

  const QuranSurah({
    required this.number,
    required this.name,
    required this.arabicName,
    required this.meaning,
    required this.ayahCount,
    required this.isMeccan,
  });

  String get type => isMeccan ? 'Meccan' : 'Medinan';
}

class Reciter {
  final String id;
  final String name;
  final String arabicName;

  const Reciter({
    required this.id,
    required this.name,
    required this.arabicName,
  });

  String audioUrl(int surahNumber, int ayahNumber) {
    final s = surahNumber.toString().padLeft(3, '0');
    final a = ayahNumber.toString().padLeft(3, '0');
    return 'https://everyayah.com/data/$id/$s$a.mp3';
  }
}

const List<Reciter> quranReciters = [
  Reciter(
    id: 'Alafasy_128kbps',
    name: 'Mishary Alafasy',
    arabicName: 'مشاري راشد العفاسي',
  ),
  Reciter(
    id: 'Maher_AlMuaiqly_128kbps',
    name: 'Maher Al-Muaiqly',
    arabicName: 'ماهر المعيقلي',
  ),
  Reciter(
    id: 'Abdul_Basit_Murattal_192kbps',
    name: 'Abdul Basit (Murattal)',
    arabicName: 'عبد الباسط عبد الصمد',
  ),
  Reciter(
    id: 'Husary_128kbps',
    name: 'Husary',
    arabicName: 'محمود خليل الحصري',
  ),
  Reciter(
    id: 'Abu_Bakr_Ash-Shaatree_128kbps',
    name: 'Abu Bakr Ash-Shaatree',
    arabicName: 'أبو بكر الشاطري',
  ),
];

// Translation edition identifiers for api.alquran.cloud
const Map<String, String> translationEditions = {
  'English': 'en.sahih',
  'Arabic': 'ar.muyassar',
  'French': 'fr.hamidullah',
  'Somali': 'so.abduh',
};

const List<QuranSurah> allSurahs = [
  QuranSurah(number: 1,   name: 'Al-Fatiha',      arabicName: 'الفاتحة',    meaning: 'The Opening',                    ayahCount: 7,   isMeccan: true),
  QuranSurah(number: 2,   name: 'Al-Baqarah',     arabicName: 'البقرة',     meaning: 'The Cow',                        ayahCount: 286, isMeccan: false),
  QuranSurah(number: 3,   name: "Ali 'Imran",     arabicName: 'آل عمران',   meaning: 'Family of Imran',                ayahCount: 200, isMeccan: false),
  QuranSurah(number: 4,   name: 'An-Nisa',         arabicName: 'النساء',     meaning: 'The Women',                      ayahCount: 176, isMeccan: false),
  QuranSurah(number: 5,   name: "Al-Ma'idah",     arabicName: 'المائدة',    meaning: 'The Table Spread',               ayahCount: 120, isMeccan: false),
  QuranSurah(number: 6,   name: "Al-An'am",       arabicName: 'الأنعام',    meaning: 'The Cattle',                     ayahCount: 165, isMeccan: true),
  QuranSurah(number: 7,   name: "Al-A'raf",       arabicName: 'الأعراف',    meaning: 'The Heights',                    ayahCount: 206, isMeccan: true),
  QuranSurah(number: 8,   name: 'Al-Anfal',        arabicName: 'الأنفال',    meaning: 'The Spoils of War',              ayahCount: 75,  isMeccan: false),
  QuranSurah(number: 9,   name: 'At-Tawbah',       arabicName: 'التوبة',     meaning: 'The Repentance',                 ayahCount: 129, isMeccan: false),
  QuranSurah(number: 10,  name: 'Yunus',           arabicName: 'يونس',       meaning: 'Jonah',                          ayahCount: 109, isMeccan: true),
  QuranSurah(number: 11,  name: 'Hud',             arabicName: 'هود',        meaning: 'Hud',                            ayahCount: 123, isMeccan: true),
  QuranSurah(number: 12,  name: 'Yusuf',           arabicName: 'يوسف',       meaning: 'Joseph',                         ayahCount: 111, isMeccan: true),
  QuranSurah(number: 13,  name: "Ar-Ra'd",        arabicName: 'الرعد',      meaning: 'The Thunder',                    ayahCount: 43,  isMeccan: false),
  QuranSurah(number: 14,  name: 'Ibrahim',         arabicName: 'إبراهيم',    meaning: 'Abraham',                        ayahCount: 52,  isMeccan: true),
  QuranSurah(number: 15,  name: 'Al-Hijr',         arabicName: 'الحجر',      meaning: 'The Rocky Tract',                ayahCount: 99,  isMeccan: true),
  QuranSurah(number: 16,  name: 'An-Nahl',         arabicName: 'النحل',      meaning: 'The Bee',                        ayahCount: 128, isMeccan: true),
  QuranSurah(number: 17,  name: "Al-Isra'",       arabicName: 'الإسراء',    meaning: 'The Night Journey',              ayahCount: 111, isMeccan: true),
  QuranSurah(number: 18,  name: 'Al-Kahf',         arabicName: 'الكهف',      meaning: 'The Cave',                       ayahCount: 110, isMeccan: true),
  QuranSurah(number: 19,  name: 'Maryam',          arabicName: 'مريم',       meaning: 'Mary',                           ayahCount: 98,  isMeccan: true),
  QuranSurah(number: 20,  name: 'Ta-Ha',           arabicName: 'طه',         meaning: 'Ta-Ha',                          ayahCount: 135, isMeccan: true),
  QuranSurah(number: 21,  name: 'Al-Anbiya',       arabicName: 'الأنبياء',   meaning: 'The Prophets',                   ayahCount: 112, isMeccan: true),
  QuranSurah(number: 22,  name: 'Al-Hajj',         arabicName: 'الحج',       meaning: 'The Pilgrimage',                 ayahCount: 78,  isMeccan: false),
  QuranSurah(number: 23,  name: "Al-Mu'minun",    arabicName: 'المؤمنون',   meaning: 'The Believers',                  ayahCount: 118, isMeccan: true),
  QuranSurah(number: 24,  name: 'An-Nur',          arabicName: 'النور',      meaning: 'The Light',                      ayahCount: 64,  isMeccan: false),
  QuranSurah(number: 25,  name: 'Al-Furqan',       arabicName: 'الفرقان',    meaning: 'The Criterion',                  ayahCount: 77,  isMeccan: true),
  QuranSurah(number: 26,  name: "Ash-Shu'ara",    arabicName: 'الشعراء',    meaning: 'The Poets',                      ayahCount: 227, isMeccan: true),
  QuranSurah(number: 27,  name: 'An-Naml',         arabicName: 'النمل',      meaning: 'The Ant',                        ayahCount: 93,  isMeccan: true),
  QuranSurah(number: 28,  name: 'Al-Qasas',        arabicName: 'القصص',      meaning: 'The Stories',                    ayahCount: 88,  isMeccan: true),
  QuranSurah(number: 29,  name: 'Al-Ankabut',      arabicName: 'العنكبوت',   meaning: 'The Spider',                     ayahCount: 69,  isMeccan: true),
  QuranSurah(number: 30,  name: 'Ar-Rum',          arabicName: 'الروم',      meaning: 'The Romans',                     ayahCount: 60,  isMeccan: true),
  QuranSurah(number: 31,  name: 'Luqman',          arabicName: 'لقمان',      meaning: 'Luqman',                         ayahCount: 34,  isMeccan: true),
  QuranSurah(number: 32,  name: 'As-Sajdah',       arabicName: 'السجدة',     meaning: 'The Prostration',                ayahCount: 30,  isMeccan: true),
  QuranSurah(number: 33,  name: 'Al-Ahzab',        arabicName: 'الأحزاب',    meaning: 'The Combined Forces',            ayahCount: 73,  isMeccan: false),
  QuranSurah(number: 34,  name: 'Saba',            arabicName: 'سبأ',        meaning: 'Sheba',                          ayahCount: 54,  isMeccan: true),
  QuranSurah(number: 35,  name: 'Fatir',           arabicName: 'فاطر',       meaning: 'Originator',                     ayahCount: 45,  isMeccan: true),
  QuranSurah(number: 36,  name: 'Ya-Sin',          arabicName: 'يس',         meaning: 'Ya Sin',                         ayahCount: 83,  isMeccan: true),
  QuranSurah(number: 37,  name: 'As-Saffat',       arabicName: 'الصافات',    meaning: 'Those Drawn Up in Ranks',        ayahCount: 182, isMeccan: true),
  QuranSurah(number: 38,  name: 'Sad',             arabicName: 'ص',          meaning: 'Sad',                            ayahCount: 88,  isMeccan: true),
  QuranSurah(number: 39,  name: 'Az-Zumar',        arabicName: 'الزمر',      meaning: 'The Groups',                     ayahCount: 75,  isMeccan: true),
  QuranSurah(number: 40,  name: 'Ghafir',          arabicName: 'غافر',       meaning: 'The Forgiver',                   ayahCount: 85,  isMeccan: true),
  QuranSurah(number: 41,  name: 'Fussilat',        arabicName: 'فصلت',       meaning: 'Explained in Detail',            ayahCount: 54,  isMeccan: true),
  QuranSurah(number: 42,  name: 'Ash-Shura',       arabicName: 'الشورى',     meaning: 'The Consultation',               ayahCount: 53,  isMeccan: true),
  QuranSurah(number: 43,  name: 'Az-Zukhruf',      arabicName: 'الزخرف',     meaning: 'The Gold Adornments',            ayahCount: 89,  isMeccan: true),
  QuranSurah(number: 44,  name: 'Ad-Dukhan',       arabicName: 'الدخان',     meaning: 'The Smoke',                      ayahCount: 59,  isMeccan: true),
  QuranSurah(number: 45,  name: 'Al-Jathiyah',     arabicName: 'الجاثية',    meaning: 'The Crouching',                  ayahCount: 37,  isMeccan: true),
  QuranSurah(number: 46,  name: 'Al-Ahqaf',        arabicName: 'الأحقاف',    meaning: 'The Wind-Curved Sandhills',      ayahCount: 35,  isMeccan: true),
  QuranSurah(number: 47,  name: 'Muhammad',        arabicName: 'محمد',       meaning: 'Muhammad',                       ayahCount: 38,  isMeccan: false),
  QuranSurah(number: 48,  name: 'Al-Fath',         arabicName: 'الفتح',      meaning: 'The Victory',                    ayahCount: 29,  isMeccan: false),
  QuranSurah(number: 49,  name: 'Al-Hujurat',      arabicName: 'الحجرات',    meaning: 'The Rooms',                      ayahCount: 18,  isMeccan: false),
  QuranSurah(number: 50,  name: 'Qaf',             arabicName: 'ق',          meaning: 'Qaf',                            ayahCount: 45,  isMeccan: true),
  QuranSurah(number: 51,  name: 'Adh-Dhariyat',    arabicName: 'الذاريات',   meaning: 'The Winnowing Winds',            ayahCount: 60,  isMeccan: true),
  QuranSurah(number: 52,  name: 'At-Tur',          arabicName: 'الطور',      meaning: 'The Mount',                      ayahCount: 49,  isMeccan: true),
  QuranSurah(number: 53,  name: 'An-Najm',         arabicName: 'النجم',      meaning: 'The Star',                       ayahCount: 62,  isMeccan: true),
  QuranSurah(number: 54,  name: 'Al-Qamar',        arabicName: 'القمر',      meaning: 'The Moon',                       ayahCount: 55,  isMeccan: true),
  QuranSurah(number: 55,  name: 'Ar-Rahman',       arabicName: 'الرحمن',     meaning: 'The Beneficent',                 ayahCount: 78,  isMeccan: false),
  QuranSurah(number: 56,  name: "Al-Waqi'ah",     arabicName: 'الواقعة',    meaning: 'The Inevitable',                 ayahCount: 96,  isMeccan: true),
  QuranSurah(number: 57,  name: 'Al-Hadid',        arabicName: 'الحديد',     meaning: 'The Iron',                       ayahCount: 29,  isMeccan: false),
  QuranSurah(number: 58,  name: 'Al-Mujadila',     arabicName: 'المجادلة',   meaning: 'The Pleading Woman',             ayahCount: 22,  isMeccan: false),
  QuranSurah(number: 59,  name: 'Al-Hashr',        arabicName: 'الحشر',      meaning: 'The Exile',                      ayahCount: 24,  isMeccan: false),
  QuranSurah(number: 60,  name: 'Al-Mumtahanah',   arabicName: 'الممتحنة',   meaning: 'She That is to be Examined',     ayahCount: 13,  isMeccan: false),
  QuranSurah(number: 61,  name: 'As-Saf',          arabicName: 'الصف',       meaning: 'The Ranks',                      ayahCount: 14,  isMeccan: false),
  QuranSurah(number: 62,  name: "Al-Jumu'ah",     arabicName: 'الجمعة',     meaning: 'The Congregation, Friday',       ayahCount: 11,  isMeccan: false),
  QuranSurah(number: 63,  name: 'Al-Munafiqun',    arabicName: 'المنافقون',  meaning: 'The Hypocrites',                 ayahCount: 11,  isMeccan: false),
  QuranSurah(number: 64,  name: 'At-Taghabun',     arabicName: 'التغابن',    meaning: 'The Mutual Disillusion',         ayahCount: 18,  isMeccan: false),
  QuranSurah(number: 65,  name: 'At-Talaq',        arabicName: 'الطلاق',     meaning: 'The Divorce',                    ayahCount: 12,  isMeccan: false),
  QuranSurah(number: 66,  name: 'At-Tahrim',       arabicName: 'التحريم',    meaning: 'The Prohibition',                ayahCount: 12,  isMeccan: false),
  QuranSurah(number: 67,  name: 'Al-Mulk',         arabicName: 'الملك',      meaning: 'The Sovereignty',                ayahCount: 30,  isMeccan: true),
  QuranSurah(number: 68,  name: 'Al-Qalam',        arabicName: 'القلم',      meaning: 'The Pen',                        ayahCount: 52,  isMeccan: true),
  QuranSurah(number: 69,  name: "Al-Haqqah",      arabicName: 'الحاقة',     meaning: 'The Reality',                    ayahCount: 52,  isMeccan: true),
  QuranSurah(number: 70,  name: "Al-Ma'arij",     arabicName: 'المعارج',    meaning: 'The Ascending Stairways',        ayahCount: 44,  isMeccan: true),
  QuranSurah(number: 71,  name: 'Nuh',             arabicName: 'نوح',        meaning: 'Noah',                           ayahCount: 28,  isMeccan: true),
  QuranSurah(number: 72,  name: 'Al-Jinn',         arabicName: 'الجن',       meaning: 'The Jinn',                       ayahCount: 28,  isMeccan: true),
  QuranSurah(number: 73,  name: 'Al-Muzzammil',    arabicName: 'المزمل',     meaning: 'The Enshrouded One',             ayahCount: 20,  isMeccan: true),
  QuranSurah(number: 74,  name: 'Al-Muddaththir',  arabicName: 'المدثر',     meaning: 'The Cloaked One',                ayahCount: 56,  isMeccan: true),
  QuranSurah(number: 75,  name: 'Al-Qiyamah',      arabicName: 'القيامة',    meaning: 'The Resurrection',               ayahCount: 40,  isMeccan: true),
  QuranSurah(number: 76,  name: 'Al-Insan',        arabicName: 'الإنسان',    meaning: 'The Human',                      ayahCount: 31,  isMeccan: false),
  QuranSurah(number: 77,  name: 'Al-Mursalat',     arabicName: 'المرسلات',   meaning: 'The Emissaries',                 ayahCount: 50,  isMeccan: true),
  QuranSurah(number: 78,  name: "An-Naba'",       arabicName: 'النبأ',      meaning: 'The Tidings',                    ayahCount: 40,  isMeccan: true),
  QuranSurah(number: 79,  name: "An-Nazi'at",     arabicName: 'النازعات',   meaning: 'Those Who Drag Forth',           ayahCount: 46,  isMeccan: true),
  QuranSurah(number: 80,  name: 'Abasa',           arabicName: 'عبس',        meaning: 'He Frowned',                     ayahCount: 42,  isMeccan: true),
  QuranSurah(number: 81,  name: 'At-Takwir',       arabicName: 'التكوير',    meaning: 'The Overthrowing',               ayahCount: 29,  isMeccan: true),
  QuranSurah(number: 82,  name: 'Al-Infitar',      arabicName: 'الانفطار',   meaning: 'The Cleaving',                   ayahCount: 19,  isMeccan: true),
  QuranSurah(number: 83,  name: 'Al-Mutaffifin',   arabicName: 'المطففين',   meaning: 'The Defrauding',                 ayahCount: 36,  isMeccan: true),
  QuranSurah(number: 84,  name: 'Al-Inshiqaq',     arabicName: 'الانشقاق',   meaning: 'The Sundering',                  ayahCount: 25,  isMeccan: true),
  QuranSurah(number: 85,  name: 'Al-Buruj',        arabicName: 'البروج',     meaning: 'The Mansions of the Stars',      ayahCount: 22,  isMeccan: true),
  QuranSurah(number: 86,  name: 'At-Tariq',        arabicName: 'الطارق',     meaning: 'The Morning Star',               ayahCount: 17,  isMeccan: true),
  QuranSurah(number: 87,  name: "Al-A'la",        arabicName: 'الأعلى',     meaning: 'The Most High',                  ayahCount: 19,  isMeccan: true),
  QuranSurah(number: 88,  name: 'Al-Ghashiyah',    arabicName: 'الغاشية',    meaning: 'The Overwhelming',               ayahCount: 26,  isMeccan: true),
  QuranSurah(number: 89,  name: 'Al-Fajr',         arabicName: 'الفجر',      meaning: 'The Dawn',                       ayahCount: 30,  isMeccan: true),
  QuranSurah(number: 90,  name: 'Al-Balad',        arabicName: 'البلد',      meaning: 'The City',                       ayahCount: 20,  isMeccan: true),
  QuranSurah(number: 91,  name: 'Ash-Shams',       arabicName: 'الشمس',      meaning: 'The Sun',                        ayahCount: 15,  isMeccan: true),
  QuranSurah(number: 92,  name: 'Al-Layl',         arabicName: 'الليل',      meaning: 'The Night',                      ayahCount: 21,  isMeccan: true),
  QuranSurah(number: 93,  name: 'Ad-Duha',         arabicName: 'الضحى',      meaning: 'The Morning Hours',              ayahCount: 11,  isMeccan: true),
  QuranSurah(number: 94,  name: 'Ash-Sharh',       arabicName: 'الشرح',      meaning: 'The Relief',                     ayahCount: 8,   isMeccan: true),
  QuranSurah(number: 95,  name: 'At-Tin',          arabicName: 'التين',      meaning: 'The Fig',                        ayahCount: 8,   isMeccan: true),
  QuranSurah(number: 96,  name: 'Al-Alaq',         arabicName: 'العلق',      meaning: 'The Clot',                       ayahCount: 19,  isMeccan: true),
  QuranSurah(number: 97,  name: 'Al-Qadr',         arabicName: 'القدر',      meaning: 'The Power, Fate',                ayahCount: 5,   isMeccan: true),
  QuranSurah(number: 98,  name: 'Al-Bayyinah',     arabicName: 'البينة',     meaning: 'The Clear Proof',                ayahCount: 8,   isMeccan: false),
  QuranSurah(number: 99,  name: 'Az-Zalzalah',     arabicName: 'الزلزلة',    meaning: 'The Earthquake',                 ayahCount: 8,   isMeccan: false),
  QuranSurah(number: 100, name: 'Al-Adiyat',       arabicName: 'العاديات',   meaning: 'The Courser',                    ayahCount: 11,  isMeccan: true),
  QuranSurah(number: 101, name: "Al-Qari'ah",     arabicName: 'القارعة',    meaning: 'The Calamity',                   ayahCount: 11,  isMeccan: true),
  QuranSurah(number: 102, name: 'At-Takathur',     arabicName: 'التكاثر',    meaning: 'The Rivalry in World Increase',  ayahCount: 8,   isMeccan: true),
  QuranSurah(number: 103, name: 'Al-Asr',          arabicName: 'العصر',      meaning: 'The Declining Day',              ayahCount: 3,   isMeccan: true),
  QuranSurah(number: 104, name: 'Al-Humazah',      arabicName: 'الهمزة',     meaning: 'The Traducer',                   ayahCount: 9,   isMeccan: true),
  QuranSurah(number: 105, name: 'Al-Fil',          arabicName: 'الفيل',      meaning: 'The Elephant',                   ayahCount: 5,   isMeccan: true),
  QuranSurah(number: 106, name: 'Quraysh',         arabicName: 'قريش',       meaning: 'Quraysh',                        ayahCount: 4,   isMeccan: true),
  QuranSurah(number: 107, name: "Al-Ma'un",       arabicName: 'الماعون',    meaning: 'The Small Kindnesses',           ayahCount: 7,   isMeccan: true),
  QuranSurah(number: 108, name: 'Al-Kawthar',      arabicName: 'الكوثر',     meaning: 'The Abundance',                  ayahCount: 3,   isMeccan: true),
  QuranSurah(number: 109, name: 'Al-Kafirun',      arabicName: 'الكافرون',   meaning: 'The Disbelievers',               ayahCount: 6,   isMeccan: true),
  QuranSurah(number: 110, name: 'An-Nasr',         arabicName: 'النصر',      meaning: 'The Victory',                    ayahCount: 3,   isMeccan: false),
  QuranSurah(number: 111, name: 'Al-Masad',        arabicName: 'المسد',      meaning: 'The Palm Fibre',                 ayahCount: 5,   isMeccan: true),
  QuranSurah(number: 112, name: 'Al-Ikhlas',       arabicName: 'الإخلاص',    meaning: 'Sincerity',                      ayahCount: 4,   isMeccan: true),
  QuranSurah(number: 113, name: 'Al-Falaq',        arabicName: 'الفلق',      meaning: 'The Daybreak',                   ayahCount: 5,   isMeccan: true),
  QuranSurah(number: 114, name: 'An-Nas',          arabicName: 'الناس',      meaning: 'Mankind',                        ayahCount: 6,   isMeccan: true),
];
