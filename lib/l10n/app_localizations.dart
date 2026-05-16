import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_so.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
    Locale('so'),
  ];

  /// App title
  ///
  /// In en, this message translates to:
  /// **'Al-Abraar Student'**
  String get appTitle;

  /// Generic cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_cancel;

  /// Generic save button
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get common_save;

  /// Generic OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get common_ok;

  /// Generic retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get common_retry;

  /// Generic done button
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get common_done;

  /// Generic back button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get common_back;

  /// Generic continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get common_continue;

  /// Sign in button
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get common_signIn;

  /// Create account button
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get common_createAccount;

  /// Register button
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get common_register;

  /// Generic loading text
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get common_loading;

  /// No internet connection error
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection and try again.'**
  String get common_error_noInternet;

  /// Coming soon badge
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get common_comingSoon;

  /// Label for the current user in chat
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get common_you;

  /// Splash screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Quran Learning Academy'**
  String get splash_subtitle;

  /// Login screen title
  ///
  /// In en, this message translates to:
  /// **'Student Login'**
  String get auth_login_title;

  /// Email input label
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get auth_login_emailLabel;

  /// Email empty validation
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get auth_login_emailEmpty;

  /// Email invalid validation
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get auth_login_emailInvalid;

  /// Password input label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get auth_login_passwordLabel;

  /// Password empty validation
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get auth_login_passwordEmpty;

  /// Password too short validation
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get auth_login_passwordShort;

  /// Forgot password link
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get auth_login_forgotPassword;

  /// Demo credentials hint
  ///
  /// In en, this message translates to:
  /// **'Demo: student@alabraar.com / student123'**
  String get auth_login_demoHint;

  /// Login button
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get auth_login_button;

  /// Or divider between login and guest
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get auth_login_orDivider;

  /// Continue as guest button
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get auth_login_continueAsGuest;

  /// No account prompt
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get auth_login_noAccount;

  /// Register screen app bar title
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get auth_register_appBarTitle;

  /// Register heading
  ///
  /// In en, this message translates to:
  /// **'Join Al-Abraar'**
  String get auth_register_heading;

  /// Register subtitle
  ///
  /// In en, this message translates to:
  /// **'Start your Quran learning journey'**
  String get auth_register_subtitle;

  /// Name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get auth_register_nameLabel;

  /// Name empty validation
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get auth_register_nameEmpty;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get auth_register_emailLabel;

  /// Email empty validation
  ///
  /// In en, this message translates to:
  /// **'Please enter email'**
  String get auth_register_emailEmpty;

  /// Email invalid validation
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get auth_register_emailInvalid;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get auth_register_passwordLabel;

  /// Password hint
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get auth_register_passwordHint;

  /// Password empty validation
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get auth_register_passwordEmpty;

  /// Password too short validation
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get auth_register_passwordShort;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get auth_register_confirmLabel;

  /// Confirm password empty validation
  ///
  /// In en, this message translates to:
  /// **'Please confirm password'**
  String get auth_register_confirmEmpty;

  /// Password mismatch validation
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get auth_register_confirmMismatch;

  /// Region field label
  ///
  /// In en, this message translates to:
  /// **'Region / Country'**
  String get auth_register_regionLabel;

  /// Region empty validation
  ///
  /// In en, this message translates to:
  /// **'Please enter your region'**
  String get auth_register_regionEmpty;

  /// Age field label
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get auth_register_ageLabel;

  /// Age empty validation
  ///
  /// In en, this message translates to:
  /// **'Please enter your age'**
  String get auth_register_ageEmpty;

  /// Age invalid validation
  ///
  /// In en, this message translates to:
  /// **'Enter a valid age'**
  String get auth_register_ageInvalid;

  /// Parent toggle label
  ///
  /// In en, this message translates to:
  /// **'I\'m a parent registering my child'**
  String get auth_register_parentToggle;

  /// Parental approval note
  ///
  /// In en, this message translates to:
  /// **'Account will need parental approval'**
  String get auth_register_parentApproval;

  /// Register button
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get auth_register_button;

  /// Already have account prompt
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get auth_register_alreadyHaveAccount;

  /// Forgot password heading
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get auth_forgotPassword_heading;

  /// Forgot password description
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get auth_forgotPassword_description;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get auth_forgotPassword_emailLabel;

  /// Email empty validation
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get auth_forgotPassword_emailEmpty;

  /// Email invalid validation
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get auth_forgotPassword_emailInvalid;

  /// Send reset link button
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get auth_forgotPassword_sendButton;

  /// Back to login link
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get auth_forgotPassword_backToLogin;

  /// Success heading
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get auth_forgotPassword_successHeading;

  /// Success body text
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a password reset link to\n{email}\n\nClick the link to reset your password. It expires in 15 minutes.'**
  String auth_forgotPassword_successBody(String email);

  /// Spam folder hint
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive it? Check your spam folder.'**
  String get auth_forgotPassword_spamHint;

  /// Generic error fallback
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get auth_forgotPassword_genericError;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get nav_home;

  /// Practice tab label
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get nav_practice;

  /// Quran tab label
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get nav_quran;

  /// Messages tab label
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get nav_messages;

  /// Profile tab label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get nav_profile;

  /// Guest mode banner text
  ///
  /// In en, this message translates to:
  /// **'Guest mode — sign in to save your progress'**
  String get nav_guestBanner;

  /// Default guest lock feature name
  ///
  /// In en, this message translates to:
  /// **'This Feature'**
  String get guest_featureName_default;

  /// Arabic greeting on dashboard
  ///
  /// In en, this message translates to:
  /// **'السلام عليكم'**
  String get dashboard_greeting;

  /// Streak label
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get dashboard_streak;

  /// Streak days value
  ///
  /// In en, this message translates to:
  /// **'{count} Day'**
  String dashboard_streakDays(int count);

  /// Points label
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get dashboard_points;

  /// Today's class badge label
  ///
  /// In en, this message translates to:
  /// **'Today\'s Class'**
  String get dashboard_todaysClass;

  /// Class start time label
  ///
  /// In en, this message translates to:
  /// **'Starts in 2 hours'**
  String get dashboard_startsIn;

  /// Join button
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get dashboard_join;

  /// Quick actions section header
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get dashboard_quickActions;

  /// AI Practice quick action
  ///
  /// In en, this message translates to:
  /// **'AI Practice'**
  String get dashboard_action_aiPractice;

  /// My Schedule quick action
  ///
  /// In en, this message translates to:
  /// **'My Schedule'**
  String get dashboard_action_mySchedule;

  /// My Progress quick action
  ///
  /// In en, this message translates to:
  /// **'My Progress'**
  String get dashboard_action_myProgress;

  /// Attendance quick action
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get dashboard_action_attendance;

  /// Messages quick action
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get dashboard_action_messages;

  /// Leaderboard quick action
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get dashboard_action_leaderboard;

  /// Live session subject (demo)
  ///
  /// In en, this message translates to:
  /// **'Quran Recitation — Level 2'**
  String get dashboard_live_subject;

  /// Practice screen title
  ///
  /// In en, this message translates to:
  /// **'Quran Practice'**
  String get practice_appBarTitle;

  /// Choose mode section header
  ///
  /// In en, this message translates to:
  /// **'Choose Practice Mode'**
  String get practice_chooseModeHeader;

  /// Recent practice section header
  ///
  /// In en, this message translates to:
  /// **'Recent Practice'**
  String get practice_recentHeader;

  /// Session count label
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 session} other{{count} sessions}}'**
  String practice_sessionCount(int count);

  /// Guest modal title
  ///
  /// In en, this message translates to:
  /// **'Sign in to Practice'**
  String get practice_guestModalTitle;

  /// Guest modal body
  ///
  /// In en, this message translates to:
  /// **'Create a free account to start AI-powered Quran practice sessions.'**
  String get practice_guestModalBody;

  /// Empty practice history title
  ///
  /// In en, this message translates to:
  /// **'No sessions yet'**
  String get practice_emptyTitle;

  /// Empty state for guests
  ///
  /// In en, this message translates to:
  /// **'Sign in to track your practice history'**
  String get practice_emptyGuest;

  /// Empty state for signed-in users
  ///
  /// In en, this message translates to:
  /// **'Complete a session above to see your history here'**
  String get practice_emptyUser;

  /// Order Quiz mode title
  ///
  /// In en, this message translates to:
  /// **'Order Quiz'**
  String get practice_orderQuizTitle;

  /// Order Quiz mode description
  ///
  /// In en, this message translates to:
  /// **'Arrange the ayahs in the correct order'**
  String get practice_orderQuizDesc;

  /// Listen & Repeat mode title
  ///
  /// In en, this message translates to:
  /// **'Listen & Repeat'**
  String get practice_mode_listenRepeatTitle;

  /// Listen & Repeat mode description
  ///
  /// In en, this message translates to:
  /// **'AI recites each ayah, then you repeat after it'**
  String get practice_mode_listenRepeatDesc;

  /// Memorisation Test mode title
  ///
  /// In en, this message translates to:
  /// **'Memorisation Test'**
  String get practice_mode_memorisationTitle;

  /// Memorisation Test mode description
  ///
  /// In en, this message translates to:
  /// **'Recite from memory — text is revealed only after you speak'**
  String get practice_mode_memorisationDesc;

  /// Turn Taking mode title
  ///
  /// In en, this message translates to:
  /// **'Turn Taking'**
  String get practice_mode_turnTakingTitle;

  /// Turn Taking mode description
  ///
  /// In en, this message translates to:
  /// **'You and the AI alternate ayahs together'**
  String get practice_mode_turnTakingDesc;

  /// Session setup screen title
  ///
  /// In en, this message translates to:
  /// **'Set Up Practice'**
  String get setup_appBarTitle;

  /// Step 1 header
  ///
  /// In en, this message translates to:
  /// **'Choose a Surah'**
  String get setup_step1;

  /// Step 2 header
  ///
  /// In en, this message translates to:
  /// **'Choose Practice Mode'**
  String get setup_step2;

  /// Ayah count label
  ///
  /// In en, this message translates to:
  /// **'{count} ayahs'**
  String setup_ayahCount(int count);

  /// Beginner difficulty label
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get setup_difficultyBeginner;

  /// Intermediate difficulty label
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get setup_difficultyIntermediate;

  /// Start button with surah name
  ///
  /// In en, this message translates to:
  /// **'Start — {surahName}'**
  String setup_startButton(String surahName);

  /// Disabled start button text
  ///
  /// In en, this message translates to:
  /// **'Select Surah & Mode to Begin'**
  String get setup_startButtonDisabled;

  /// Ayah progress indicator
  ///
  /// In en, this message translates to:
  /// **'Ayah {current} of {total}'**
  String session_ayahProgress(int current, int total);

  /// Memorisation test instruction
  ///
  /// In en, this message translates to:
  /// **'Recite from memory'**
  String get session_reciteFromMemory;

  /// Show transliteration toggle
  ///
  /// In en, this message translates to:
  /// **'Show transliteration'**
  String get session_showTransliteration;

  /// Show translation toggle
  ///
  /// In en, this message translates to:
  /// **'Show translation'**
  String get session_showTranslation;

  /// Your recitation label
  ///
  /// In en, this message translates to:
  /// **'Your recitation:'**
  String get session_yourRecitation;

  /// No speech detected error
  ///
  /// In en, this message translates to:
  /// **'No speech detected'**
  String get session_noSpeechDetected;

  /// AI reciting status
  ///
  /// In en, this message translates to:
  /// **'Listen carefully…'**
  String get session_aiReciting;

  /// AI reciting its turn in turn-taking mode
  ///
  /// In en, this message translates to:
  /// **'AI is reciting its turn…'**
  String get session_aiTurnReciting;

  /// Loading recitation status
  ///
  /// In en, this message translates to:
  /// **'Loading recitation…'**
  String get session_loadingRecitation;

  /// My Turn button
  ///
  /// In en, this message translates to:
  /// **'My Turn — Recite Now'**
  String get session_myTurnButton;

  /// Countdown get ready text
  ///
  /// In en, this message translates to:
  /// **'Get ready to recite…'**
  String get session_getReady;

  /// Countdown go text
  ///
  /// In en, this message translates to:
  /// **'Go!'**
  String get session_go;

  /// Recording status
  ///
  /// In en, this message translates to:
  /// **'Recording — recite now'**
  String get session_recording;

  /// Tap to stop instruction
  ///
  /// In en, this message translates to:
  /// **'Tap ■ when you finish'**
  String get session_tapToStop;

  /// AI assessment suggestion
  ///
  /// In en, this message translates to:
  /// **'AI suggests: {label} — tap to confirm or choose differently'**
  String session_aiSuggestion(String label);

  /// Correct assessment label
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get session_correct;

  /// Small mistake assessment label
  ///
  /// In en, this message translates to:
  /// **'Mistake'**
  String get session_smallMistake;

  /// Wrong assessment label
  ///
  /// In en, this message translates to:
  /// **'Wrong'**
  String get session_wrong;

  /// Skipped result label
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get session_skipped;

  /// Hear again button
  ///
  /// In en, this message translates to:
  /// **'Hear Again'**
  String get session_hearAgain;

  /// Skip button
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get session_skip;

  /// Finish button
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get session_finish;

  /// End session dialog title
  ///
  /// In en, this message translates to:
  /// **'End Session?'**
  String get session_endSessionTitle;

  /// End session dialog body
  ///
  /// In en, this message translates to:
  /// **'You\'ve completed {completed} of {total} ayahs.'**
  String session_endSessionBody(int completed, int total);

  /// End button in dialog
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get session_end;

  /// End session text button
  ///
  /// In en, this message translates to:
  /// **'End Session'**
  String get session_endSessionButton;

  /// Completion screen app bar title
  ///
  /// In en, this message translates to:
  /// **'Session Complete'**
  String get session_completionTitle;

  /// Score label
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get session_scoreLabel;

  /// Accuracy label
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get session_accuracyLabel;

  /// Lives left label
  ///
  /// In en, this message translates to:
  /// **'Lives Left'**
  String get session_livesLeftLabel;

  /// Ayah number badge label
  ///
  /// In en, this message translates to:
  /// **'Ayah {number}'**
  String session_ayahNumber(int number);

  /// Ayah breakdown section header
  ///
  /// In en, this message translates to:
  /// **'Ayah Breakdown'**
  String get session_ayahBreakdown;

  /// Mistakes count label in summary
  ///
  /// In en, this message translates to:
  /// **'Mistakes'**
  String get session_mistakes;

  /// Retry mistakes button
  ///
  /// In en, this message translates to:
  /// **'Retry Mistakes'**
  String get session_retryMistakes;

  /// Practice again button
  ///
  /// In en, this message translates to:
  /// **'Practice Again'**
  String get session_practiceAgain;

  /// Back to practice button
  ///
  /// In en, this message translates to:
  /// **'Back to Practice'**
  String get session_backToPractice;

  /// Match score label
  ///
  /// In en, this message translates to:
  /// **'Match score'**
  String get session_matchScore;

  /// Completion message for grade A (≥90%)
  ///
  /// In en, this message translates to:
  /// **'Excellent recitation! MashaAllah, you did beautifully. 🌟'**
  String get session_completionGradeA;

  /// Completion message for grade B (75-89%)
  ///
  /// In en, this message translates to:
  /// **'Good work! A little more practice and you\'ll be perfect. 💪'**
  String get session_completionGradeB;

  /// Completion message for grade C (60-74%)
  ///
  /// In en, this message translates to:
  /// **'Keep going! Regular practice makes perfect. You\'re improving. 📖'**
  String get session_completionGradeC;

  /// Completion message for grade D (<60%)
  ///
  /// In en, this message translates to:
  /// **'Don\'t give up! Review the ayahs and try again. Every attempt counts. 🤲'**
  String get session_completionGradeD;

  /// Schedule screen title
  ///
  /// In en, this message translates to:
  /// **'My Schedule'**
  String get schedule_appBarTitle;

  /// Monday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get schedule_mon;

  /// Tuesday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get schedule_tue;

  /// Wednesday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get schedule_wed;

  /// Thursday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get schedule_thu;

  /// Friday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get schedule_fri;

  /// Saturday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get schedule_sat;

  /// Sunday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get schedule_sun;

  /// Upcoming status label
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get schedule_statusUpcoming;

  /// Completed status label
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get schedule_statusCompleted;

  /// Empty schedule title
  ///
  /// In en, this message translates to:
  /// **'No classes today'**
  String get schedule_emptyTitle;

  /// Empty schedule body
  ///
  /// In en, this message translates to:
  /// **'Enjoy your day off or use\nthis time for self-practice!'**
  String get schedule_emptyBody;

  /// Join class dialog title
  ///
  /// In en, this message translates to:
  /// **'Join Class'**
  String get schedule_joinDialogTitle;

  /// Connecting to class progress message
  ///
  /// In en, this message translates to:
  /// **'Connecting to class...'**
  String get schedule_connecting;

  /// Join now button
  ///
  /// In en, this message translates to:
  /// **'Join Now'**
  String get schedule_joinNow;

  /// Demo mode snackbar
  ///
  /// In en, this message translates to:
  /// **'Live class for {subject} is not yet available in demo mode.'**
  String schedule_demoSnackbar(String subject);

  /// Request session modal title
  ///
  /// In en, this message translates to:
  /// **'Request a Session'**
  String get schedule_requestTitle;

  /// Request session modal subtitle
  ///
  /// In en, this message translates to:
  /// **'Ask your teacher for an extra session'**
  String get schedule_requestSubtitle;

  /// Teacher dropdown label
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get schedule_requestTeacherLabel;

  /// Subject field label
  ///
  /// In en, this message translates to:
  /// **'Subject / Topic'**
  String get schedule_requestSubjectLabel;

  /// Notes field label
  ///
  /// In en, this message translates to:
  /// **'Additional notes (optional)'**
  String get schedule_requestNotesLabel;

  /// Request sent snackbar
  ///
  /// In en, this message translates to:
  /// **'Session request sent to your teacher.'**
  String get schedule_requestSent;

  /// Send request button
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get schedule_sendRequest;

  /// Messages screen title
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages_appBarTitle;

  /// Messages search hint
  ///
  /// In en, this message translates to:
  /// **'Search messages...'**
  String get messages_searchHint;

  /// Empty messages title
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get messages_emptyTitle;

  /// Empty messages body
  ///
  /// In en, this message translates to:
  /// **'Your conversations with teachers\nwill appear here'**
  String get messages_emptyBody;

  /// New message modal title
  ///
  /// In en, this message translates to:
  /// **'New Message'**
  String get messages_newMessageTitle;

  /// Send to dropdown label
  ///
  /// In en, this message translates to:
  /// **'Send to'**
  String get messages_sendToLabel;

  /// Message field label
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messages_messageLabel;

  /// Send button
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get messages_send;

  /// Guest lock feature name for messages
  ///
  /// In en, this message translates to:
  /// **'Your Messages'**
  String get messages_guestFeatureName;

  /// Guest lock description for messages
  ///
  /// In en, this message translates to:
  /// **'Sign in to message your teachers and\nview class announcements.'**
  String get messages_guestDesc;

  /// Online status indicator
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get chat_online;

  /// Mute notifications option
  ///
  /// In en, this message translates to:
  /// **'Mute notifications'**
  String get chat_muteNotifications;

  /// Clear chat option
  ///
  /// In en, this message translates to:
  /// **'Clear chat'**
  String get chat_clearChat;

  /// Report option
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get chat_report;

  /// Date divider: Today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get chat_today;

  /// Chat input hint
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get chat_inputHint;

  /// File sharing coming soon snackbar
  ///
  /// In en, this message translates to:
  /// **'File sharing coming soon'**
  String get chat_fileSharingComingSoon;

  /// Leave session dialog title
  ///
  /// In en, this message translates to:
  /// **'Leave Session?'**
  String get live_leaveTitle;

  /// Leave session dialog body
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave the live session?'**
  String get live_leaveBody;

  /// Stay button
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get live_stay;

  /// Leave button
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get live_leave;

  /// Live badge text
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get live_badge;

  /// Chat section header
  ///
  /// In en, this message translates to:
  /// **'Questions & Chat'**
  String get live_chatHeader;

  /// Live chat input hint
  ///
  /// In en, this message translates to:
  /// **'Ask a question…'**
  String get live_inputHint;

  /// Muted mic label
  ///
  /// In en, this message translates to:
  /// **'Muted'**
  String get live_muted;

  /// Unmute mic label
  ///
  /// In en, this message translates to:
  /// **'Unmute'**
  String get live_unmute;

  /// Raise hand label
  ///
  /// In en, this message translates to:
  /// **'Raise'**
  String get live_raiseHand;

  /// Lower hand label
  ///
  /// In en, this message translates to:
  /// **'Lower'**
  String get live_lowerHand;

  /// Hand raised snackbar
  ///
  /// In en, this message translates to:
  /// **'Hand raised ✋'**
  String get live_handRaised;

  /// Hand lowered snackbar
  ///
  /// In en, this message translates to:
  /// **'Hand lowered'**
  String get live_handLowered;

  /// Message count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 message} other{{count} messages}}'**
  String live_messages(int count);

  /// Profile screen title
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profile_appBarTitle;

  /// Guest user name
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get profile_guestName;

  /// Guest profile message
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your profile,\ntrack progress, and connect with teachers.'**
  String get profile_guestMessage;

  /// Student role badge
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get profile_studentRole;

  /// Points stat label
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get profile_pointsLabel;

  /// Streak stat label
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String profile_streakLabel(int count);

  /// Streak stat header label
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get profile_streakStatLabel;

  /// Badges stat label
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get profile_badgesLabel;

  /// Learning section header
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get profile_sectionLearning;

  /// My Progress menu item
  ///
  /// In en, this message translates to:
  /// **'My Progress'**
  String get profile_menuProgress;

  /// My Badges menu item
  ///
  /// In en, this message translates to:
  /// **'My Badges'**
  String get profile_menuBadges;

  /// Leaderboard menu item
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get profile_menuLeaderboard;

  /// Academic section header
  ///
  /// In en, this message translates to:
  /// **'Academic'**
  String get profile_sectionAcademic;

  /// Attendance menu item
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get profile_menuAttendance;

  /// Marks menu item
  ///
  /// In en, this message translates to:
  /// **'Marks'**
  String get profile_menuMarks;

  /// Report Card menu item
  ///
  /// In en, this message translates to:
  /// **'Report Card'**
  String get profile_menuReportCard;

  /// Account section header
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profile_sectionAccount;

  /// Help & Support menu item
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get profile_menuHelp;

  /// Logout menu item
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profile_menuLogout;

  /// Logout dialog title
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profile_logoutTitle;

  /// Logout dialog body
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get profile_logoutBody;

  /// Notifications screen title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications_appBarTitle;

  /// Mark all read button
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notifications_markAllRead;

  /// Today group header
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get notifications_groupToday;

  /// Yesterday group header
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get notifications_groupYesterday;

  /// Earlier group header
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get notifications_groupEarlier;

  /// Empty notifications title
  ///
  /// In en, this message translates to:
  /// **'All caught up!'**
  String get notifications_emptyTitle;

  /// Empty notifications body
  ///
  /// In en, this message translates to:
  /// **'No new notifications'**
  String get notifications_emptyBody;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_appBarTitle;

  /// Edit profile button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get settings_editButton;

  /// Notifications section label
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settings_sectionNotifications;

  /// Class reminders toggle title
  ///
  /// In en, this message translates to:
  /// **'Class Reminders'**
  String get settings_classRemindersTitle;

  /// Class reminders toggle subtitle
  ///
  /// In en, this message translates to:
  /// **'Get notified 30 minutes before class'**
  String get settings_classRemindersSubtitle;

  /// Achievement alerts toggle title
  ///
  /// In en, this message translates to:
  /// **'Achievement Alerts'**
  String get settings_achievementAlertsTitle;

  /// Achievement alerts toggle subtitle
  ///
  /// In en, this message translates to:
  /// **'Notify when you earn a badge'**
  String get settings_achievementAlertsSubtitle;

  /// Teacher messages toggle title
  ///
  /// In en, this message translates to:
  /// **'Teacher Messages'**
  String get settings_teacherMessagesTitle;

  /// Teacher messages toggle subtitle
  ///
  /// In en, this message translates to:
  /// **'Notify on new messages from teachers'**
  String get settings_teacherMessagesSubtitle;

  /// Practice reminders toggle title
  ///
  /// In en, this message translates to:
  /// **'Practice Reminders'**
  String get settings_practiceRemindersTitle;

  /// Practice reminders toggle subtitle
  ///
  /// In en, this message translates to:
  /// **'Daily reminder to maintain your streak'**
  String get settings_practiceRemindersSubtitle;

  /// Account section label
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settings_sectionAccount;

  /// Change password action
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get settings_changePassword;

  /// Language action
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language;

  /// About section label
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settings_sectionAbout;

  /// App version action
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get settings_appVersion;

  /// Privacy policy action
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settings_privacyPolicy;

  /// Terms of service action
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settings_termsOfService;

  /// Account actions section label
  ///
  /// In en, this message translates to:
  /// **'Account Actions'**
  String get settings_sectionAccountActions;

  /// Sign out action
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get settings_signOut;

  /// Language picker title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get settings_selectLanguage;

  /// Edit profile modal title
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get settings_editProfileTitle;

  /// Full name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get settings_fullNameLabel;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get settings_emailLabel;

  /// Change password modal title
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get settings_changePasswordTitle;

  /// Current password label
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get settings_currentPasswordLabel;

  /// New password label
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get settings_newPasswordLabel;

  /// Confirm new password label
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get settings_confirmNewPasswordLabel;

  /// Update password button
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get settings_updatePassword;

  /// Sign out dialog title
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get settings_signOutTitle;

  /// Sign out dialog body
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get settings_signOutBody;

  /// Privacy policy body text
  ///
  /// In en, this message translates to:
  /// **'Al-Abraar collects only the information needed to provide your learning experience: your name, email address, and usage data such as attendance and practice scores.\n\nWe do not sell or share your personal data with third parties. All data is encrypted in transit and at rest.\n\nYou may request deletion of your account and data at any time by contacting support@alabraar.com.\n\nThis policy was last updated: May 2026.'**
  String get settings_privacyBody;

  /// Terms of service body text
  ///
  /// In en, this message translates to:
  /// **'By using Al-Abraar you agree to use the app solely for lawful educational purposes.\n\nYou must not share your login credentials or attempt to access another student\'s account.\n\nAll course materials, recordings, and content within the app are the intellectual property of Al-Abraar Academy and may not be reproduced without written permission.\n\nAl-Abraar reserves the right to suspend accounts that violate these terms.\n\nLast updated: May 2026.'**
  String get settings_termsBody;

  /// Progress screen title
  ///
  /// In en, this message translates to:
  /// **'My Progress'**
  String get progress_appBarTitle;

  /// Guest lock feature name
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get progress_guestFeatureName;

  /// Guest lock description
  ///
  /// In en, this message translates to:
  /// **'Sign in to track your Quran memorisation,\nskills and weekly activity.'**
  String get progress_guestDesc;

  /// Overall progress card title
  ///
  /// In en, this message translates to:
  /// **'Overall Progress'**
  String get progress_overallTitle;

  /// Surahs memorised stat label
  ///
  /// In en, this message translates to:
  /// **'Surahs Memorised'**
  String get progress_surahsMemorised;

  /// Ayahs recited stat label
  ///
  /// In en, this message translates to:
  /// **'Ayahs Recited'**
  String get progress_ayahsRecited;

  /// Practice sessions stat label
  ///
  /// In en, this message translates to:
  /// **'Practice Sessions'**
  String get progress_practiceSessions;

  /// This week section header
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get progress_thisWeek;

  /// Skills breakdown section header
  ///
  /// In en, this message translates to:
  /// **'Skills Breakdown'**
  String get progress_skillsBreakdown;

  /// Tajweed skill name
  ///
  /// In en, this message translates to:
  /// **'Tajweed'**
  String get progress_skill_tajweed;

  /// Memorisation skill name
  ///
  /// In en, this message translates to:
  /// **'Memorisation'**
  String get progress_skill_memorisation;

  /// Recitation skill name
  ///
  /// In en, this message translates to:
  /// **'Recitation'**
  String get progress_skill_recitation;

  /// Arabic skill name
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get progress_skill_arabic;

  /// Surah progress section header
  ///
  /// In en, this message translates to:
  /// **'Surah Progress'**
  String get progress_surahProgress;

  /// Surah complete label
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get progress_surahComplete;

  /// Quran ring label
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get progress_quranPercent;

  /// Attendance screen title
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendance_appBarTitle;

  /// Guest lock feature name
  ///
  /// In en, this message translates to:
  /// **'Your Attendance'**
  String get attendance_guestFeatureName;

  /// Guest lock description
  ///
  /// In en, this message translates to:
  /// **'Sign in to view your class attendance\nrecord and monthly calendar.'**
  String get attendance_guestDesc;

  /// Present stat label
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get attendance_present;

  /// Absent stat label
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get attendance_absent;

  /// Attendance rate label
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get attendance_rate;

  /// Present legend
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get attendance_legendPresent;

  /// Absent legend
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get attendance_legendAbsent;

  /// Excused legend
  ///
  /// In en, this message translates to:
  /// **'Excused'**
  String get attendance_legendExcused;

  /// No class legend
  ///
  /// In en, this message translates to:
  /// **'No Class'**
  String get attendance_legendNoClass;

  /// Badges screen title
  ///
  /// In en, this message translates to:
  /// **'My Badges'**
  String get badges_appBarTitle;

  /// Earned badge count
  ///
  /// In en, this message translates to:
  /// **'{count} badges earned'**
  String badges_earnedCount(int count);

  /// Remaining badges
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 more to unlock} other{{count} more to unlock}}'**
  String badges_remaining(int count);

  /// Earned section header
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get badges_sectionEarned;

  /// Locked section header
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get badges_sectionLocked;

  /// Earned status in modal
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get badges_statusEarned;

  /// Locked status in modal
  ///
  /// In en, this message translates to:
  /// **'Not yet unlocked'**
  String get badges_statusLocked;

  /// Badge name
  ///
  /// In en, this message translates to:
  /// **'First Step'**
  String get badges_firstStepName;

  /// Badge description
  ///
  /// In en, this message translates to:
  /// **'Completed your first session'**
  String get badges_firstStepDesc;

  /// Badge name
  ///
  /// In en, this message translates to:
  /// **'7-Day Streak'**
  String get badges_streakName;

  /// Badge description
  ///
  /// In en, this message translates to:
  /// **'Practiced 7 days in a row'**
  String get badges_streakDesc;

  /// Badge name
  ///
  /// In en, this message translates to:
  /// **'Al-Fatiha'**
  String get badges_alfatihaName;

  /// Badge description
  ///
  /// In en, this message translates to:
  /// **'Memorised Al-Fatiha perfectly'**
  String get badges_alfatihaDesc;

  /// Badge name
  ///
  /// In en, this message translates to:
  /// **'Tajweed Star'**
  String get badges_tajweedStarName;

  /// Badge description
  ///
  /// In en, this message translates to:
  /// **'Scored 90%+ on Tajweed'**
  String get badges_tajweedStarDesc;

  /// Badge name
  ///
  /// In en, this message translates to:
  /// **'Early Bird'**
  String get badges_earlyBirdName;

  /// Badge description
  ///
  /// In en, this message translates to:
  /// **'Attended 5 morning sessions'**
  String get badges_earlyBirdDesc;

  /// Badge name
  ///
  /// In en, this message translates to:
  /// **'Consistent'**
  String get badges_consistentName;

  /// Badge description
  ///
  /// In en, this message translates to:
  /// **'Attended 10 classes in a row'**
  String get badges_consistentDesc;

  /// Badge name
  ///
  /// In en, this message translates to:
  /// **'Quick Learner'**
  String get badges_quickLearnerName;

  /// Badge description
  ///
  /// In en, this message translates to:
  /// **'Memorised 3 surahs in a week'**
  String get badges_quickLearnerDesc;

  /// Badge name
  ///
  /// In en, this message translates to:
  /// **'Team Player'**
  String get badges_teamPlayerName;

  /// Badge description
  ///
  /// In en, this message translates to:
  /// **'Participated in group recitation'**
  String get badges_teamPlayerDesc;

  /// Badge name
  ///
  /// In en, this message translates to:
  /// **'30-Day Streak'**
  String get badges_streak30Name;

  /// Badge description
  ///
  /// In en, this message translates to:
  /// **'Practice 30 days in a row'**
  String get badges_streak30Desc;

  /// Badge name
  ///
  /// In en, this message translates to:
  /// **'Juz Amma'**
  String get badges_juzAmmaName;

  /// Badge description
  ///
  /// In en, this message translates to:
  /// **'Memorise the entire Juz Amma'**
  String get badges_juzAmmaDesc;

  /// Badge name
  ///
  /// In en, this message translates to:
  /// **'Hafiz Path'**
  String get badges_hafizPathName;

  /// Badge description
  ///
  /// In en, this message translates to:
  /// **'Complete 50% of the Quran'**
  String get badges_hafizPathDesc;

  /// Badge name
  ///
  /// In en, this message translates to:
  /// **'Perfect Score'**
  String get badges_perfectScoreName;

  /// Badge description
  ///
  /// In en, this message translates to:
  /// **'Get 100% on 5 sessions'**
  String get badges_perfectScoreDesc;

  /// Badge name
  ///
  /// In en, this message translates to:
  /// **'Night Owl'**
  String get badges_nightOwlName;

  /// Badge description
  ///
  /// In en, this message translates to:
  /// **'Complete 10 evening sessions'**
  String get badges_nightOwlDesc;

  /// Badge name
  ///
  /// In en, this message translates to:
  /// **'Scholar'**
  String get badges_scholarName;

  /// Badge description
  ///
  /// In en, this message translates to:
  /// **'Complete all Arabic modules'**
  String get badges_scholarDesc;

  /// Leaderboard screen title
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboard_appBarTitle;

  /// Weekly period tab
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get leaderboard_periodWeekly;

  /// Monthly period tab
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get leaderboard_periodMonthly;

  /// All Time period tab
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get leaderboard_periodAllTime;

  /// Podium section title
  ///
  /// In en, this message translates to:
  /// **'Top Recitors'**
  String get leaderboard_podiumTitle;

  /// You suffix for current user row
  ///
  /// In en, this message translates to:
  /// **'(You)'**
  String get leaderboard_youSuffix;

  /// Marks screen title
  ///
  /// In en, this message translates to:
  /// **'My Marks'**
  String get marks_appBarTitle;

  /// Guest lock feature name
  ///
  /// In en, this message translates to:
  /// **'Your Marks'**
  String get marks_guestFeatureName;

  /// Guest lock description
  ///
  /// In en, this message translates to:
  /// **'Sign in to view your assessment\nresults and subject grades.'**
  String get marks_guestDesc;

  /// Recent tab label
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get marks_tabRecent;

  /// By Subject tab label
  ///
  /// In en, this message translates to:
  /// **'By Subject'**
  String get marks_tabBySubject;

  /// Average stat label
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get marks_statAverage;

  /// Best stat label
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get marks_statBest;

  /// Tests stat label
  ///
  /// In en, this message translates to:
  /// **'Tests'**
  String get marks_statTests;

  /// Test count label
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 test} other{{count} tests}}'**
  String marks_testCount(int count);

  /// Report card screen title
  ///
  /// In en, this message translates to:
  /// **'Report Card'**
  String get reportCard_appBarTitle;

  /// Guest lock feature name
  ///
  /// In en, this message translates to:
  /// **'Your Report Card'**
  String get reportCard_guestFeatureName;

  /// Guest lock description
  ///
  /// In en, this message translates to:
  /// **'Sign in to view your term grades,\nteacher comments, and subject results.'**
  String get reportCard_guestDesc;

  /// Download PDF tooltip
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get reportCard_downloadTooltip;

  /// Download coming soon snackbar
  ///
  /// In en, this message translates to:
  /// **'PDF download coming soon'**
  String get reportCard_downloadComingSoon;

  /// Term 1 label
  ///
  /// In en, this message translates to:
  /// **'Term 1'**
  String get reportCard_term1;

  /// Term 2 label
  ///
  /// In en, this message translates to:
  /// **'Term 2'**
  String get reportCard_term2;

  /// Term 3 label
  ///
  /// In en, this message translates to:
  /// **'Term 3'**
  String get reportCard_term3;

  /// Overall grade label
  ///
  /// In en, this message translates to:
  /// **'Overall Grade'**
  String get reportCard_overallGrade;

  /// Average percentage suffix
  ///
  /// In en, this message translates to:
  /// **'% average'**
  String get reportCard_averageSuffix;

  /// Attendance stat label
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get reportCard_statAttendance;

  /// Subjects stat label
  ///
  /// In en, this message translates to:
  /// **'Subjects'**
  String get reportCard_statSubjects;

  /// Term stat label
  ///
  /// In en, this message translates to:
  /// **'Term'**
  String get reportCard_statTerm;

  /// Subject results section header
  ///
  /// In en, this message translates to:
  /// **'Subject Results'**
  String get reportCard_subjectResults;

  /// Teacher comment section header
  ///
  /// In en, this message translates to:
  /// **'Teacher\'s Comment'**
  String get reportCard_teacherComment;

  /// Help screen title
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get help_appBarTitle;

  /// Help hero title
  ///
  /// In en, this message translates to:
  /// **'How can we help?'**
  String get help_heroTitle;

  /// Help hero body
  ///
  /// In en, this message translates to:
  /// **'Find answers below or contact our\nsupport team.'**
  String get help_heroBody;

  /// FAQ section header
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get help_faqHeader;

  /// Contact section header
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get help_contactHeader;

  /// Copied to clipboard snackbar
  ///
  /// In en, this message translates to:
  /// **'{label} copied'**
  String help_copiedSnackbar(String label);

  /// FAQ 1 question
  ///
  /// In en, this message translates to:
  /// **'How do I join a live class?'**
  String get help_faq1Q;

  /// FAQ 1 answer
  ///
  /// In en, this message translates to:
  /// **'Go to My Schedule and tap the \'Join\' button on your upcoming session card. Make sure you\'re on time — the button becomes active 5 minutes before the class starts.'**
  String get help_faq1A;

  /// FAQ 2 question
  ///
  /// In en, this message translates to:
  /// **'How is my AI practice session scored?'**
  String get help_faq2Q;

  /// FAQ 2 answer
  ///
  /// In en, this message translates to:
  /// **'The AI listens to your recitation and compares it to the reference text. You can also self-assess using the Correct / Small Mistake / Wrong buttons. Your score and accuracy are saved to your progress.'**
  String get help_faq2A;

  /// FAQ 3 question
  ///
  /// In en, this message translates to:
  /// **'How do I message my teacher?'**
  String get help_faq3Q;

  /// FAQ 3 answer
  ///
  /// In en, this message translates to:
  /// **'Open the Messages tab from the bottom navigation. Tap on your teacher\'s name to open the conversation. All your teachers are listed there.'**
  String get help_faq3A;

  /// FAQ 4 question
  ///
  /// In en, this message translates to:
  /// **'What are badges and how do I earn them?'**
  String get help_faq4Q;

  /// FAQ 4 answer
  ///
  /// In en, this message translates to:
  /// **'Badges are rewards for achieving milestones — like completing a surah, maintaining a streak, or getting a high score. Visit My Badges from your Profile to see what you can earn next.'**
  String get help_faq4A;

  /// FAQ 5 question
  ///
  /// In en, this message translates to:
  /// **'My attendance is marked incorrectly. What do I do?'**
  String get help_faq5Q;

  /// FAQ 5 answer
  ///
  /// In en, this message translates to:
  /// **'Please contact your teacher directly via the Messages tab. They can update your attendance record. You can also raise it in class.'**
  String get help_faq5A;

  /// FAQ 6 question
  ///
  /// In en, this message translates to:
  /// **'How do I reset my password?'**
  String get help_faq6Q;

  /// FAQ 6 answer
  ///
  /// In en, this message translates to:
  /// **'Go to Profile → Settings → Change Password. If you have forgotten your password, use the Forgot Password option on the login screen.'**
  String get help_faq6A;

  /// FAQ 7 question
  ///
  /// In en, this message translates to:
  /// **'Can I use the app without an internet connection?'**
  String get help_faq7Q;

  /// FAQ 7 answer
  ///
  /// In en, this message translates to:
  /// **'Some features like your schedule and recent progress are available offline. However, live classes, AI practice, and messaging require an internet connection.'**
  String get help_faq7A;

  /// Email support contact label
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get help_contact_email;

  /// Live chat contact label
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get help_contact_chat;

  /// Phone contact label
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get help_contact_phone;

  /// Live chat hours
  ///
  /// In en, this message translates to:
  /// **'Available Mon–Fri, 9 AM – 6 PM'**
  String get help_contact_chatHours;

  /// Quran Arabic title
  ///
  /// In en, this message translates to:
  /// **'القرآن الكريم'**
  String get quran_arabicTitle;

  /// Quran English title
  ///
  /// In en, this message translates to:
  /// **'The Holy Quran'**
  String get quran_englishTitle;

  /// Quran search hint
  ///
  /// In en, this message translates to:
  /// **'Search surahs…'**
  String get quran_searchHint;

  /// Translation language picker title
  ///
  /// In en, this message translates to:
  /// **'Translation Language'**
  String get quran_translationLanguage;

  /// All surahs filter
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get quran_filterAll;

  /// Meccan filter
  ///
  /// In en, this message translates to:
  /// **'Meccan'**
  String get quran_filterMeccan;

  /// Medinan filter
  ///
  /// In en, this message translates to:
  /// **'Medinan'**
  String get quran_filterMedinan;

  /// Meccan type label on card
  ///
  /// In en, this message translates to:
  /// **'Meccan'**
  String get quran_typeMeccan;

  /// Medinan type label on card
  ///
  /// In en, this message translates to:
  /// **'Medinan'**
  String get quran_typeMedinan;

  /// Empty surah list
  ///
  /// In en, this message translates to:
  /// **'No surahs found'**
  String get quran_noSurahsFound;

  /// Beginner difficulty badge in Quran
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get quran_difficultyBeginner;

  /// Intermediate difficulty badge in Quran
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get quran_difficultyIntermediate;

  /// Choose reciter picker title
  ///
  /// In en, this message translates to:
  /// **'Choose Reciter'**
  String get quran_player_chooseReciter;

  /// Repetitions picker title
  ///
  /// In en, this message translates to:
  /// **'Repetitions per Ayah'**
  String get quran_player_repetitionsTitle;

  /// Repetitions picker description
  ///
  /// In en, this message translates to:
  /// **'Each ayah will play this many times before advancing'**
  String get quran_player_repetitionsDesc;

  /// Singular/plural for repetition count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{time} other{times}}'**
  String quran_player_time(int count);

  /// Loading error title
  ///
  /// In en, this message translates to:
  /// **'Could not load ayahs.'**
  String get quran_player_loadingError;

  /// Ayah counter in controls bar
  ///
  /// In en, this message translates to:
  /// **'Ayah {current} / {total}'**
  String quran_player_ayahCounter(int current, int total);

  /// Completion dialog title
  ///
  /// In en, this message translates to:
  /// **'{surahName} Complete!'**
  String quran_player_completionTitle(String surahName);

  /// Completion dialog message
  ///
  /// In en, this message translates to:
  /// **'JazakAllah khair for listening.'**
  String get quran_player_completionMessage;

  /// Listen again button
  ///
  /// In en, this message translates to:
  /// **'Listen Again'**
  String get quran_player_listenAgain;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr', 'so'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'so':
      return AppLocalizationsSo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
