// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'طالب الأبرار';

  @override
  String get common_cancel => 'إلغاء';

  @override
  String get common_save => 'حفظ التغييرات';

  @override
  String get common_ok => 'موافق';

  @override
  String get common_retry => 'إعادة المحاولة';

  @override
  String get common_done => 'تم';

  @override
  String get common_back => 'رجوع';

  @override
  String get common_continue => 'متابعة';

  @override
  String get common_signIn => 'تسجيل الدخول';

  @override
  String get common_createAccount => 'إنشاء حساب';

  @override
  String get common_register => 'تسجيل';

  @override
  String get common_loading => 'جاري التحميل…';

  @override
  String get common_error_noInternet =>
      'تحقق من اتصالك بالإنترنت وحاول مجدداً.';

  @override
  String get common_comingSoon => 'قريباً';

  @override
  String get common_you => 'أنت';

  @override
  String get splash_subtitle => 'أكاديمية تعليم القرآن الكريم';

  @override
  String get auth_login_title => 'تسجيل دخول الطالب';

  @override
  String get auth_login_emailLabel => 'البريد الإلكتروني';

  @override
  String get auth_login_emailEmpty => 'الرجاء إدخال بريدك الإلكتروني';

  @override
  String get auth_login_emailInvalid => 'أدخل بريداً إلكترونياً صحيحاً';

  @override
  String get auth_login_passwordLabel => 'كلمة المرور';

  @override
  String get auth_login_passwordEmpty => 'الرجاء إدخال كلمة المرور';

  @override
  String get auth_login_passwordShort =>
      'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';

  @override
  String get auth_login_forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get auth_login_demoHint => 'تجريبي: student@alabraar.com / student123';

  @override
  String get auth_login_button => 'تسجيل الدخول';

  @override
  String get auth_login_orDivider => 'أو';

  @override
  String get auth_login_continueAsGuest => 'المتابعة كضيف';

  @override
  String get auth_login_noAccount => 'ليس لديك حساب؟ ';

  @override
  String get auth_register_appBarTitle => 'إنشاء حساب';

  @override
  String get auth_register_heading => 'انضم إلى الأبرار';

  @override
  String get auth_register_subtitle => 'ابدأ رحلة تعلم القرآن الكريم';

  @override
  String get auth_register_nameLabel => 'الاسم الكامل';

  @override
  String get auth_register_nameEmpty => 'الرجاء إدخال اسمك';

  @override
  String get auth_register_emailLabel => 'البريد الإلكتروني';

  @override
  String get auth_register_emailEmpty => 'الرجاء إدخال البريد الإلكتروني';

  @override
  String get auth_register_emailInvalid => 'أدخل بريداً إلكترونياً صحيحاً';

  @override
  String get auth_register_passwordLabel => 'كلمة المرور';

  @override
  String get auth_register_passwordHint => '8 أحرف على الأقل';

  @override
  String get auth_register_passwordEmpty => 'الرجاء إدخال كلمة المرور';

  @override
  String get auth_register_passwordShort =>
      'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';

  @override
  String get auth_register_confirmLabel => 'تأكيد كلمة المرور';

  @override
  String get auth_register_confirmEmpty => 'الرجاء تأكيد كلمة المرور';

  @override
  String get auth_register_confirmMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get auth_register_regionLabel => 'المنطقة / الدولة';

  @override
  String get auth_register_regionEmpty => 'الرجاء إدخال منطقتك';

  @override
  String get auth_register_ageLabel => 'العمر';

  @override
  String get auth_register_ageEmpty => 'الرجاء إدخال عمرك';

  @override
  String get auth_register_ageInvalid => 'أدخل عمراً صحيحاً';

  @override
  String get auth_register_parentToggle => 'أنا ولي أمر أسجّل طفلي';

  @override
  String get auth_register_parentApproval => 'يستلزم الحساب موافقة ولي الأمر';

  @override
  String get auth_register_button => 'إنشاء حساب';

  @override
  String get auth_register_alreadyHaveAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get auth_forgotPassword_heading => 'نسيت كلمة المرور؟';

  @override
  String get auth_forgotPassword_description =>
      'أدخل بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور.';

  @override
  String get auth_forgotPassword_emailLabel => 'البريد الإلكتروني';

  @override
  String get auth_forgotPassword_emailEmpty => 'الرجاء إدخال بريدك الإلكتروني';

  @override
  String get auth_forgotPassword_emailInvalid =>
      'أدخل بريداً إلكترونياً صحيحاً';

  @override
  String get auth_forgotPassword_sendButton => 'إرسال رابط إعادة التعيين';

  @override
  String get auth_forgotPassword_backToLogin => 'العودة إلى تسجيل الدخول';

  @override
  String get auth_forgotPassword_successHeading => 'تفقد بريدك الإلكتروني';

  @override
  String auth_forgotPassword_successBody(String email) {
    return 'لقد أرسلنا رابط إعادة تعيين كلمة المرور إلى\n$email\n\nانقر الرابط لإعادة تعيين كلمة مرورك. ينتهي صلاحيته خلال 15 دقيقة.';
  }

  @override
  String get auth_forgotPassword_spamHint =>
      'لم تستلمه؟ تحقق من مجلد الرسائل غير المرغوب فيها.';

  @override
  String get auth_forgotPassword_genericError =>
      'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get nav_home => 'الرئيسية';

  @override
  String get nav_practice => 'التدريب';

  @override
  String get nav_quran => 'القرآن';

  @override
  String get nav_messages => 'الرسائل';

  @override
  String get nav_profile => 'الملف الشخصي';

  @override
  String get nav_guestBanner => 'وضع الضيف — سجّل دخولك لحفظ تقدمك';

  @override
  String get guest_featureName_default => 'هذه الميزة';

  @override
  String get dashboard_greeting => 'السلام عليكم';

  @override
  String get dashboard_streak => 'سلسلة';

  @override
  String dashboard_streakDays(int count) {
    return '$count يوم';
  }

  @override
  String get dashboard_points => 'النقاط';

  @override
  String get dashboard_todaysClass => 'درس اليوم';

  @override
  String get dashboard_startsIn => 'يبدأ خلال ساعتين';

  @override
  String get dashboard_join => 'انضم';

  @override
  String get dashboard_quickActions => 'الإجراءات السريعة';

  @override
  String get dashboard_action_aiPractice => 'تدريب الذكاء الاصطناعي';

  @override
  String get dashboard_action_mySchedule => 'جدولي';

  @override
  String get dashboard_action_myProgress => 'تقدمي';

  @override
  String get dashboard_action_attendance => 'الحضور';

  @override
  String get dashboard_action_messages => 'الرسائل';

  @override
  String get dashboard_action_leaderboard => 'لوحة المتصدرين';

  @override
  String get dashboard_live_subject => 'تلاوة القرآن — المستوى الثاني';

  @override
  String get practice_appBarTitle => 'تدريب القرآن';

  @override
  String get practice_chooseModeHeader => 'اختر طريقة التدريب';

  @override
  String get practice_recentHeader => 'التدريب الأخير';

  @override
  String practice_sessionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count جلسة',
      few: '$count جلسات',
      two: 'جلستان',
      one: 'جلسة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get practice_guestModalTitle => 'سجّل الدخول للتدريب';

  @override
  String get practice_guestModalBody =>
      'أنشئ حساباً مجانياً لبدء جلسات تدريب القرآن بالذكاء الاصطناعي.';

  @override
  String get practice_emptyTitle => 'لا توجد جلسات بعد';

  @override
  String get practice_emptyGuest => 'سجّل دخولك لتتبع سجل تدريبك';

  @override
  String get practice_emptyUser => 'أكمل جلسة أعلاه لتراها هنا';

  @override
  String get practice_orderQuizTitle => 'اختبار الترتيب';

  @override
  String get practice_orderQuizDesc => 'رتّب الآيات بالترتيب الصحيح';

  @override
  String get practice_mode_listenRepeatTitle => 'استمع وكرر';

  @override
  String get practice_mode_listenRepeatDesc =>
      'يتلو الذكاء الاصطناعي كل آية ثم تكررها أنت';

  @override
  String get practice_mode_memorisationTitle => 'اختبار الحفظ';

  @override
  String get practice_mode_memorisationDesc =>
      'اتلُ من حفظك — يُكشف النص بعد أن تتحدث فقط';

  @override
  String get practice_mode_turnTakingTitle => 'بالتناوب';

  @override
  String get practice_mode_turnTakingDesc =>
      'تتناوب أنت والذكاء الاصطناعي في تلاوة الآيات';

  @override
  String get setup_appBarTitle => 'إعداد التدريب';

  @override
  String get setup_step1 => 'اختر سورة';

  @override
  String get setup_step2 => 'اختر طريقة التدريب';

  @override
  String setup_ayahCount(int count) {
    return '$count آية';
  }

  @override
  String get setup_difficultyBeginner => 'مبتدئ';

  @override
  String get setup_difficultyIntermediate => 'متوسط';

  @override
  String setup_startButton(String surahName) {
    return 'ابدأ — $surahName';
  }

  @override
  String get setup_startButtonDisabled => 'اختر سورة وطريقة للبدء';

  @override
  String session_ayahProgress(int current, int total) {
    return 'الآية $current من $total';
  }

  @override
  String get session_reciteFromMemory => 'اتلُ من حفظك';

  @override
  String get session_showTransliteration => 'أظهر النقحرة';

  @override
  String get session_showTranslation => 'أظهر الترجمة';

  @override
  String get session_yourRecitation => 'تلاوتك:';

  @override
  String get session_noSpeechDetected => 'لم يُكتشف صوت';

  @override
  String get session_aiReciting => 'استمع جيداً…';

  @override
  String get session_aiTurnReciting => 'الذكاء الاصطناعي يتلو دوره…';

  @override
  String get session_loadingRecitation => 'جارٍ تحميل التلاوة…';

  @override
  String get session_myTurnButton => 'دوري — اتلُ الآن';

  @override
  String get session_getReady => 'استعد للتلاوة…';

  @override
  String get session_go => 'ابدأ!';

  @override
  String get session_recording => 'جارٍ التسجيل — اتلُ الآن';

  @override
  String get session_tapToStop => 'اضغط ■ عند الانتهاء';

  @override
  String session_aiSuggestion(String label) {
    return 'اقتراح الذكاء الاصطناعي: $label — اضغط للتأكيد أو اختر خلاف ذلك';
  }

  @override
  String get session_correct => 'صحيح';

  @override
  String get session_smallMistake => 'خطأ بسيط';

  @override
  String get session_wrong => 'خطأ';

  @override
  String get session_skipped => 'تم التخطي';

  @override
  String get session_hearAgain => 'استمع مجدداً';

  @override
  String get session_skip => 'تخطي';

  @override
  String get session_finish => 'إنهاء';

  @override
  String get session_endSessionTitle => 'إنهاء الجلسة؟';

  @override
  String session_endSessionBody(int completed, int total) {
    return 'أكملت $completed من $total آية.';
  }

  @override
  String get session_end => 'إنهاء';

  @override
  String get session_endSessionButton => 'إنهاء الجلسة';

  @override
  String get session_completionTitle => 'اكتملت الجلسة';

  @override
  String get session_scoreLabel => 'النتيجة';

  @override
  String get session_accuracyLabel => 'الدقة';

  @override
  String get session_livesLeftLabel => 'المحاولات المتبقية';

  @override
  String session_ayahNumber(int number) {
    return 'الآية $number';
  }

  @override
  String get session_ayahBreakdown => 'تفصيل الآيات';

  @override
  String get session_mistakes => 'الأخطاء';

  @override
  String get session_retryMistakes => 'إعادة الأخطاء';

  @override
  String get session_practiceAgain => 'تدرب مجدداً';

  @override
  String get session_backToPractice => 'العودة للتدريب';

  @override
  String get session_matchScore => 'درجة التطابق';

  @override
  String get session_completionGradeA =>
      'تلاوة رائعة! ماشاء الله، أبليت بلاءً حسناً. 🌟';

  @override
  String get session_completionGradeB =>
      'أحسنت! مزيد من التدريب وستصل إلى الكمال. 💪';

  @override
  String get session_completionGradeC =>
      'واصل! التدريب المنتظم يصنع الكمال. أنت تتحسن. 📖';

  @override
  String get session_completionGradeD =>
      'لا تستسلم! راجع الآيات وحاول مجدداً. كل محاولة لها قيمة. 🤲';

  @override
  String get schedule_appBarTitle => 'جدولي';

  @override
  String get schedule_mon => 'الإث';

  @override
  String get schedule_tue => 'الثل';

  @override
  String get schedule_wed => 'الأر';

  @override
  String get schedule_thu => 'الخم';

  @override
  String get schedule_fri => 'الجم';

  @override
  String get schedule_sat => 'السب';

  @override
  String get schedule_sun => 'الأح';

  @override
  String get schedule_statusUpcoming => 'قادم';

  @override
  String get schedule_statusCompleted => 'مكتمل';

  @override
  String get schedule_emptyTitle => 'لا دروس اليوم';

  @override
  String get schedule_emptyBody =>
      'استمتع بيومك أو استخدم هذا الوقت للتدريب الذاتي!';

  @override
  String get schedule_joinDialogTitle => 'الانضمام للدرس';

  @override
  String get schedule_connecting => 'جارٍ الاتصال بالدرس...';

  @override
  String get schedule_joinNow => 'انضم الآن';

  @override
  String schedule_demoSnackbar(String subject) {
    return 'الدرس المباشر لـ$subject غير متاح في الوضع التجريبي.';
  }

  @override
  String get schedule_requestTitle => 'طلب جلسة';

  @override
  String get schedule_requestSubtitle => 'اطلب من معلمك جلسة إضافية';

  @override
  String get schedule_requestTeacherLabel => 'المعلم';

  @override
  String get schedule_requestSubjectLabel => 'المادة / الموضوع';

  @override
  String get schedule_requestNotesLabel => 'ملاحظات إضافية (اختياري)';

  @override
  String get schedule_requestSent => 'تم إرسال طلب الجلسة إلى معلمك.';

  @override
  String get schedule_sendRequest => 'إرسال الطلب';

  @override
  String get messages_appBarTitle => 'الرسائل';

  @override
  String get messages_searchHint => 'البحث في الرسائل...';

  @override
  String get messages_emptyTitle => 'لا رسائل بعد';

  @override
  String get messages_emptyBody => 'ستظهر هنا محادثاتك مع المعلمين';

  @override
  String get messages_newMessageTitle => 'رسالة جديدة';

  @override
  String get messages_sendToLabel => 'إرسال إلى';

  @override
  String get messages_messageLabel => 'الرسالة';

  @override
  String get messages_send => 'إرسال';

  @override
  String get messages_guestFeatureName => 'رسائلك';

  @override
  String get messages_guestDesc =>
      'سجّل دخولك لمراسلة معلميك\nوعرض إعلانات الفصل.';

  @override
  String get chat_online => 'متصل';

  @override
  String get chat_muteNotifications => 'كتم الإشعارات';

  @override
  String get chat_clearChat => 'مسح المحادثة';

  @override
  String get chat_report => 'إبلاغ';

  @override
  String get chat_today => 'اليوم';

  @override
  String get chat_inputHint => 'اكتب رسالة...';

  @override
  String get chat_fileSharingComingSoon => 'مشاركة الملفات قريباً';

  @override
  String get live_leaveTitle => 'مغادرة الجلسة؟';

  @override
  String get live_leaveBody =>
      'هل أنت متأكد من رغبتك في مغادرة الجلسة المباشرة؟';

  @override
  String get live_stay => 'البقاء';

  @override
  String get live_leave => 'مغادرة';

  @override
  String get live_badge => 'مباشر';

  @override
  String get live_chatHeader => 'أسئلة ومحادثة';

  @override
  String get live_inputHint => 'اطرح سؤالاً…';

  @override
  String get live_muted => 'مكتوم';

  @override
  String get live_unmute => 'إلغاء الكتم';

  @override
  String get live_raiseHand => 'رفع';

  @override
  String get live_lowerHand => 'خفض';

  @override
  String get live_handRaised => 'تم رفع يدك ✋';

  @override
  String get live_handLowered => 'تم خفض يدك';

  @override
  String live_messages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count رسالة',
      few: '$count رسائل',
      two: 'رسالتان',
      one: 'رسالة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get profile_appBarTitle => 'ملفي الشخصي';

  @override
  String get profile_guestName => 'مستخدم ضيف';

  @override
  String get profile_guestMessage =>
      'سجّل دخولك للوصول إلى ملفك الشخصي\nوتتبع تقدمك والتواصل مع المعلمين.';

  @override
  String get profile_studentRole => 'طالب';

  @override
  String get profile_pointsLabel => 'النقاط';

  @override
  String profile_streakLabel(int count) {
    return '$count أيام';
  }

  @override
  String get profile_streakStatLabel => 'السلسلة';

  @override
  String get profile_badgesLabel => 'الشارات';

  @override
  String get profile_sectionLearning => 'التعلم';

  @override
  String get profile_menuProgress => 'تقدمي';

  @override
  String get profile_menuBadges => 'شاراتي';

  @override
  String get profile_menuLeaderboard => 'لوحة المتصدرين';

  @override
  String get profile_sectionAcademic => 'الأكاديمي';

  @override
  String get profile_menuAttendance => 'الحضور';

  @override
  String get profile_menuMarks => 'الدرجات';

  @override
  String get profile_menuReportCard => 'كشف الدرجات';

  @override
  String get profile_sectionAccount => 'الحساب';

  @override
  String get profile_menuHelp => 'المساعدة والدعم';

  @override
  String get profile_menuLogout => 'تسجيل الخروج';

  @override
  String get profile_logoutTitle => 'تسجيل الخروج';

  @override
  String get profile_logoutBody => 'هل أنت متأكد من رغبتك في تسجيل الخروج؟';

  @override
  String get notifications_appBarTitle => 'الإشعارات';

  @override
  String get notifications_markAllRead => 'تحديد الكل كمقروء';

  @override
  String get notifications_groupToday => 'اليوم';

  @override
  String get notifications_groupYesterday => 'أمس';

  @override
  String get notifications_groupEarlier => 'سابقاً';

  @override
  String get notifications_emptyTitle => 'أنت على اطلاع بكل شيء!';

  @override
  String get notifications_emptyBody => 'لا إشعارات جديدة';

  @override
  String get settings_appBarTitle => 'الإعدادات';

  @override
  String get settings_editButton => 'تعديل';

  @override
  String get settings_sectionNotifications => 'الإشعارات';

  @override
  String get settings_classRemindersTitle => 'تذكيرات الدروس';

  @override
  String get settings_classRemindersSubtitle =>
      'تلقّ إشعاراً قبل 30 دقيقة من الدرس';

  @override
  String get settings_achievementAlertsTitle => 'تنبيهات الإنجازات';

  @override
  String get settings_achievementAlertsSubtitle => 'إشعار عند حصولك على شارة';

  @override
  String get settings_teacherMessagesTitle => 'رسائل المعلمين';

  @override
  String get settings_teacherMessagesSubtitle =>
      'إشعار عند وصول رسالة جديدة من المعلم';

  @override
  String get settings_practiceRemindersTitle => 'تذكيرات التدريب';

  @override
  String get settings_practiceRemindersSubtitle =>
      'تذكير يومي للحفاظ على سلسلتك';

  @override
  String get settings_sectionAccount => 'الحساب';

  @override
  String get settings_changePassword => 'تغيير كلمة المرور';

  @override
  String get settings_language => 'اللغة';

  @override
  String get settings_sectionAbout => 'حول';

  @override
  String get settings_appVersion => 'إصدار التطبيق';

  @override
  String get settings_privacyPolicy => 'سياسة الخصوصية';

  @override
  String get settings_termsOfService => 'شروط الخدمة';

  @override
  String get settings_sectionAccountActions => 'إجراءات الحساب';

  @override
  String get settings_signOut => 'تسجيل الخروج';

  @override
  String get settings_selectLanguage => 'اختر اللغة';

  @override
  String get settings_editProfileTitle => 'تعديل الملف الشخصي';

  @override
  String get settings_fullNameLabel => 'الاسم الكامل';

  @override
  String get settings_emailLabel => 'البريد الإلكتروني';

  @override
  String get settings_changePasswordTitle => 'تغيير كلمة المرور';

  @override
  String get settings_currentPasswordLabel => 'كلمة المرور الحالية';

  @override
  String get settings_newPasswordLabel => 'كلمة المرور الجديدة';

  @override
  String get settings_confirmNewPasswordLabel => 'تأكيد كلمة المرور الجديدة';

  @override
  String get settings_updatePassword => 'تحديث كلمة المرور';

  @override
  String get settings_signOutTitle => 'تسجيل الخروج';

  @override
  String get settings_signOutBody => 'هل أنت متأكد من رغبتك في تسجيل الخروج؟';

  @override
  String get settings_privacyBody =>
      'تجمع الأبرار المعلومات اللازمة فقط لتقديم تجربة تعلمك: اسمك وبريدك الإلكتروني وبيانات الاستخدام كالحضور ودرجات التدريب.\n\nلا نبيع بياناتك الشخصية ولا نشاركها مع أطراف ثالثة. تُشفَّر جميع البيانات أثناء النقل وعند التخزين.\n\nيمكنك طلب حذف حسابك وبياناتك في أي وقت عبر التواصل مع support@alabraar.com.\n\nآخر تحديث لهذه السياسة: مايو 2026.';

  @override
  String get settings_termsBody =>
      'باستخدامك لتطبيق الأبرار، فأنت توافق على استخدامه لأغراض تعليمية مشروعة فقط.\n\nلا يجوز لك مشاركة بيانات تسجيل الدخول أو محاولة الوصول إلى حساب طالب آخر.\n\nجميع المواد الدراسية والتسجيلات والمحتوى داخل التطبيق ملكية فكرية لأكاديمية الأبرار ولا يجوز إعادة إنتاجها دون إذن كتابي.\n\nتحتفظ الأبرار بحق تعليق الحسابات المخالفة لهذه الشروط.\n\nآخر تحديث: مايو 2026.';

  @override
  String get progress_appBarTitle => 'تقدمي';

  @override
  String get progress_guestFeatureName => 'تقدمك';

  @override
  String get progress_guestDesc =>
      'سجّل دخولك لتتبع حفظك للقرآن\nومهاراتك ونشاطك الأسبوعي.';

  @override
  String get progress_overallTitle => 'التقدم الكلي';

  @override
  String get progress_surahsMemorised => 'السور المحفوظة';

  @override
  String get progress_ayahsRecited => 'الآيات المتلوة';

  @override
  String get progress_practiceSessions => 'جلسات التدريب';

  @override
  String get progress_thisWeek => 'هذا الأسبوع';

  @override
  String get progress_skillsBreakdown => 'تفصيل المهارات';

  @override
  String get progress_skill_tajweed => 'التجويد';

  @override
  String get progress_skill_memorisation => 'الحفظ';

  @override
  String get progress_skill_recitation => 'التلاوة';

  @override
  String get progress_skill_arabic => 'العربية';

  @override
  String get progress_surahProgress => 'تقدم السور';

  @override
  String get progress_surahComplete => 'مكتمل';

  @override
  String get progress_quranPercent => 'القرآن';

  @override
  String get attendance_appBarTitle => 'الحضور';

  @override
  String get attendance_guestFeatureName => 'حضورك';

  @override
  String get attendance_guestDesc =>
      'سجّل دخولك لعرض سجل حضورك\nوالتقويم الشهري.';

  @override
  String get attendance_present => 'حاضر';

  @override
  String get attendance_absent => 'غائب';

  @override
  String get attendance_rate => 'النسبة';

  @override
  String get attendance_legendPresent => 'حاضر';

  @override
  String get attendance_legendAbsent => 'غائب';

  @override
  String get attendance_legendExcused => 'بعذر';

  @override
  String get attendance_legendNoClass => 'لا درس';

  @override
  String get badges_appBarTitle => 'شاراتي';

  @override
  String badges_earnedCount(int count) {
    return '$count شارة محققة';
  }

  @override
  String badges_remaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count شارة للفتح',
      few: '$count شارات للفتح',
      two: 'شارتان للفتح',
      one: 'شارة واحدة للفتح',
    );
    return '$_temp0';
  }

  @override
  String get badges_sectionEarned => 'المحققة';

  @override
  String get badges_sectionLocked => 'المقفلة';

  @override
  String get badges_statusEarned => 'محققة';

  @override
  String get badges_statusLocked => 'لم تُفتح بعد';

  @override
  String get badges_firstStepName => 'الخطوة الأولى';

  @override
  String get badges_firstStepDesc => 'أكملت جلستك الأولى';

  @override
  String get badges_streakName => 'سلسلة 7 أيام';

  @override
  String get badges_streakDesc => 'تدربت 7 أيام متواصلة';

  @override
  String get badges_alfatihaName => 'الفاتحة';

  @override
  String get badges_alfatihaDesc => 'حفظت سورة الفاتحة بإتقان';

  @override
  String get badges_tajweedStarName => 'نجم التجويد';

  @override
  String get badges_tajweedStarDesc => 'حصلت على 90%+ في التجويد';

  @override
  String get badges_earlyBirdName => 'الباكر';

  @override
  String get badges_earlyBirdDesc => 'حضرت 5 جلسات صباحية';

  @override
  String get badges_consistentName => 'المثابر';

  @override
  String get badges_consistentDesc => 'حضرت 10 دروس متواصلة';

  @override
  String get badges_quickLearnerName => 'المتعلم السريع';

  @override
  String get badges_quickLearnerDesc => 'حفظت 3 سور في أسبوع';

  @override
  String get badges_teamPlayerName => 'اللاعب الجماعي';

  @override
  String get badges_teamPlayerDesc => 'شاركت في التلاوة الجماعية';

  @override
  String get badges_streak30Name => 'سلسلة 30 يوماً';

  @override
  String get badges_streak30Desc => 'تدرّب 30 يوماً متواصلاً';

  @override
  String get badges_juzAmmaName => 'جزء عم';

  @override
  String get badges_juzAmmaDesc => 'احفظ جزء عم كاملاً';

  @override
  String get badges_hafizPathName => 'درب الحافظ';

  @override
  String get badges_hafizPathDesc => 'أكمل 50% من القرآن';

  @override
  String get badges_perfectScoreName => 'العلامة الكاملة';

  @override
  String get badges_perfectScoreDesc => 'احصل على 100% في 5 جلسات';

  @override
  String get badges_nightOwlName => 'بومة الليل';

  @override
  String get badges_nightOwlDesc => 'أكمل 10 جلسات مسائية';

  @override
  String get badges_scholarName => 'العالم';

  @override
  String get badges_scholarDesc => 'أكمل جميع وحدات العربية';

  @override
  String get leaderboard_appBarTitle => 'لوحة المتصدرين';

  @override
  String get leaderboard_periodWeekly => 'أسبوعي';

  @override
  String get leaderboard_periodMonthly => 'شهري';

  @override
  String get leaderboard_periodAllTime => 'الكل';

  @override
  String get leaderboard_podiumTitle => 'أفضل القراء';

  @override
  String get leaderboard_youSuffix => '(أنت)';

  @override
  String get marks_appBarTitle => 'درجاتي';

  @override
  String get marks_guestFeatureName => 'درجاتك';

  @override
  String get marks_guestDesc =>
      'سجّل دخولك لعرض نتائج\nتقييماتك ودرجات المواد.';

  @override
  String get marks_tabRecent => 'الأخيرة';

  @override
  String get marks_tabBySubject => 'حسب المادة';

  @override
  String get marks_statAverage => 'المتوسط';

  @override
  String get marks_statBest => 'الأفضل';

  @override
  String get marks_statTests => 'الاختبارات';

  @override
  String marks_testCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count اختباراً',
      few: '$count اختبارات',
      two: 'اختباران',
      one: 'اختبار واحد',
    );
    return '$_temp0';
  }

  @override
  String get reportCard_appBarTitle => 'كشف الدرجات';

  @override
  String get reportCard_guestFeatureName => 'كشف درجاتك';

  @override
  String get reportCard_guestDesc =>
      'سجّل دخولك لعرض درجاتك الفصلية\nوتعليقات المعلمين ونتائج المواد.';

  @override
  String get reportCard_downloadTooltip => 'تنزيل PDF';

  @override
  String get reportCard_downloadComingSoon => 'تنزيل PDF قريباً';

  @override
  String get reportCard_term1 => 'الفصل الأول';

  @override
  String get reportCard_term2 => 'الفصل الثاني';

  @override
  String get reportCard_term3 => 'الفصل الثالث';

  @override
  String get reportCard_overallGrade => 'الدرجة الكلية';

  @override
  String get reportCard_averageSuffix => '% متوسط';

  @override
  String get reportCard_statAttendance => 'الحضور';

  @override
  String get reportCard_statSubjects => 'المواد';

  @override
  String get reportCard_statTerm => 'الفصل';

  @override
  String get reportCard_subjectResults => 'نتائج المواد';

  @override
  String get reportCard_teacherComment => 'تعليق المعلم';

  @override
  String get help_appBarTitle => 'المساعدة والدعم';

  @override
  String get help_heroTitle => 'كيف يمكننا مساعدتك؟';

  @override
  String get help_heroBody => 'ابحث عن إجابات أدناه أو تواصل مع\nفريق الدعم.';

  @override
  String get help_faqHeader => 'الأسئلة الشائعة';

  @override
  String get help_contactHeader => 'تواصل معنا';

  @override
  String help_copiedSnackbar(String label) {
    return 'تم نسخ $label';
  }

  @override
  String get help_faq1Q => 'كيف أنضم إلى درس مباشر؟';

  @override
  String get help_faq1A =>
      'اذهب إلى «جدولي» واضغط على زر «انضم» في بطاقة الجلسة القادمة. تأكد من حضورك في الوقت المحدد — يصبح الزر نشطاً قبل 5 دقائق من بدء الدرس.';

  @override
  String get help_faq2Q => 'كيف يُقيَّم أداؤي في التدريب؟';

  @override
  String get help_faq2A =>
      'يستمع الذكاء الاصطناعي لتلاوتك ويقارنها بالنص المرجعي. يمكنك أيضاً تقييم نفسك باستخدام أزرار صحيح / خطأ بسيط / خطأ. تُحفظ نتيجتك ودقتك في تقدمك.';

  @override
  String get help_faq3Q => 'كيف أراسل معلمي؟';

  @override
  String get help_faq3A =>
      'افتح تبويب الرسائل من شريط التنقل السفلي. اضغط على اسم معلمك لفتح المحادثة. جميع معلميك مدرجون هناك.';

  @override
  String get help_faq4Q => 'ما الشارات وكيف أحصل عليها؟';

  @override
  String get help_faq4A =>
      'الشارات مكافآت لتحقيق معالم — كإتمام سورة أو الحفاظ على سلسلة أو الحصول على درجة عالية. زر «شاراتي» من ملفك الشخصي لرؤية ما يمكنك تحقيقه.';

  @override
  String get help_faq5Q => 'سجل حضوري غير صحيح. ماذا أفعل؟';

  @override
  String get help_faq5A =>
      'تواصل مع معلمك مباشرةً عبر تبويب الرسائل. يمكنه تحديث سجل حضورك. يمكنك أيضاً إثارة الأمر في الفصل.';

  @override
  String get help_faq6Q => 'كيف أعيد تعيين كلمة مروري؟';

  @override
  String get help_faq6A =>
      'اذهب إلى الملف الشخصي ← الإعدادات ← تغيير كلمة المرور. إن نسيت كلمة مرورك، استخدم خيار «نسيت كلمة المرور» في شاشة تسجيل الدخول.';

  @override
  String get help_faq7Q => 'هل يمكنني استخدام التطبيق دون إنترنت؟';

  @override
  String get help_faq7A =>
      'بعض الميزات كالجدول والتقدم الأخير متاحة دون إنترنت. لكن الدروس المباشرة والتدريب بالذكاء الاصطناعي والمراسلة تستلزم اتصالاً بالإنترنت.';

  @override
  String get help_contact_email => 'دعم عبر البريد الإلكتروني';

  @override
  String get help_contact_chat => 'المحادثة المباشرة';

  @override
  String get help_contact_phone => 'الهاتف';

  @override
  String get help_contact_chatHours => 'متاح الاثنين–الجمعة، 9 ص – 6 م';

  @override
  String get quran_arabicTitle => 'القرآن الكريم';

  @override
  String get quran_englishTitle => 'القرآن الكريم';

  @override
  String get quran_searchHint => 'ابحث في السور…';

  @override
  String get quran_translationLanguage => 'لغة الترجمة';

  @override
  String get quran_filterAll => 'الكل';

  @override
  String get quran_filterMeccan => 'مكية';

  @override
  String get quran_filterMedinan => 'مدنية';

  @override
  String get quran_typeMeccan => 'مكية';

  @override
  String get quran_typeMedinan => 'مدنية';

  @override
  String get quran_noSurahsFound => 'لا سور مطابقة';

  @override
  String get quran_difficultyBeginner => 'مبتدئ';

  @override
  String get quran_difficultyIntermediate => 'متوسط';

  @override
  String get quran_player_chooseReciter => 'اختر القارئ';

  @override
  String get quran_player_repetitionsTitle => 'التكرار لكل آية';

  @override
  String get quran_player_repetitionsDesc =>
      'ستُشغَّل كل آية هذا العدد من المرات قبل التقدم';

  @override
  String quran_player_time(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'مرات',
      one: 'مرة',
    );
    return '$_temp0';
  }

  @override
  String get quran_player_loadingError => 'تعذّر تحميل الآيات.';

  @override
  String quran_player_ayahCounter(int current, int total) {
    return 'الآية $current / $total';
  }

  @override
  String quran_player_completionTitle(String surahName) {
    return 'اكتملت $surahName!';
  }

  @override
  String get quran_player_completionMessage => 'جزاك الله خيراً على الاستماع.';

  @override
  String get quran_player_listenAgain => 'استمع مجدداً';

  @override
  String get onboarding_skip => 'تخطي';

  @override
  String get onboarding_next => 'التالي';

  @override
  String get onboarding_getStarted => 'ابدأ الآن';

  @override
  String get onboarding_heroTitle => 'Al-Abraar';

  @override
  String get onboarding_heroArabic => 'الأبرار';

  @override
  String get onboarding_heroTagline => 'تعلّم · اقرأ · انمُ';

  @override
  String get onboarding_whoTitle => 'من سيستخدم التطبيق؟';

  @override
  String get onboarding_childLabel => 'طفل / طالب';

  @override
  String get onboarding_childSub => 'من 5 إلى 17 سنة';

  @override
  String get onboarding_adultLabel => 'بالغ / والد';

  @override
  String get onboarding_adultSub => '18 فما فوق';

  @override
  String get onboarding_feat1Title => 'تعلّم القرآن';

  @override
  String get onboarding_feat1Desc => 'دروس منهجية مع معلمين معتمدين.';

  @override
  String get onboarding_feat2Title => 'جلسات مباشرة';

  @override
  String get onboarding_feat2Desc => 'انضم إلى فصول تفاعلية من أي مكان.';

  @override
  String get onboarding_feat3Title => 'تتبع التقدم';

  @override
  String get onboarding_feat3Desc => 'شارات ولوحات صدارة وتقارير مفصلة.';

  @override
  String get onboarding_authTitle => 'هل أنت مستعد للبدء؟';

  @override
  String get onboarding_createAccount => 'إنشاء حساب';

  @override
  String get onboarding_signIn => 'تسجيل الدخول';

  @override
  String get onboarding_browseFirst => 'تصفح أولاً';

  @override
  String get settings_replayIntro => 'مقدمة التطبيق';
}
