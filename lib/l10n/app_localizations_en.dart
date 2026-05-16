// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Al-Abraar Student';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_save => 'Save Changes';

  @override
  String get common_ok => 'OK';

  @override
  String get common_retry => 'Retry';

  @override
  String get common_done => 'Done';

  @override
  String get common_back => 'Back';

  @override
  String get common_continue => 'Continue';

  @override
  String get common_signIn => 'Sign In';

  @override
  String get common_createAccount => 'Create Account';

  @override
  String get common_register => 'Register';

  @override
  String get common_loading => 'Loading…';

  @override
  String get common_error_noInternet =>
      'Check your internet connection and try again.';

  @override
  String get common_comingSoon => 'Soon';

  @override
  String get common_you => 'You';

  @override
  String get splash_subtitle => 'Quran Learning Academy';

  @override
  String get auth_login_title => 'Student Login';

  @override
  String get auth_login_emailLabel => 'Email Address';

  @override
  String get auth_login_emailEmpty => 'Please enter your email';

  @override
  String get auth_login_emailInvalid => 'Enter a valid email';

  @override
  String get auth_login_passwordLabel => 'Password';

  @override
  String get auth_login_passwordEmpty => 'Please enter your password';

  @override
  String get auth_login_passwordShort =>
      'Password must be at least 6 characters';

  @override
  String get auth_login_forgotPassword => 'Forgot Password?';

  @override
  String get auth_login_demoHint => 'Demo: student@alabraar.com / student123';

  @override
  String get auth_login_button => 'Login';

  @override
  String get auth_login_orDivider => 'or';

  @override
  String get auth_login_continueAsGuest => 'Continue as Guest';

  @override
  String get auth_login_noAccount => 'Don\'t have an account? ';

  @override
  String get auth_register_appBarTitle => 'Create Account';

  @override
  String get auth_register_heading => 'Join Al-Abraar';

  @override
  String get auth_register_subtitle => 'Start your Quran learning journey';

  @override
  String get auth_register_nameLabel => 'Full Name';

  @override
  String get auth_register_nameEmpty => 'Please enter your name';

  @override
  String get auth_register_emailLabel => 'Email Address';

  @override
  String get auth_register_emailEmpty => 'Please enter email';

  @override
  String get auth_register_emailInvalid => 'Enter a valid email';

  @override
  String get auth_register_passwordLabel => 'Password';

  @override
  String get auth_register_passwordHint => 'At least 8 characters';

  @override
  String get auth_register_passwordEmpty => 'Please enter password';

  @override
  String get auth_register_passwordShort =>
      'Password must be at least 8 characters';

  @override
  String get auth_register_confirmLabel => 'Confirm Password';

  @override
  String get auth_register_confirmEmpty => 'Please confirm password';

  @override
  String get auth_register_confirmMismatch => 'Passwords do not match';

  @override
  String get auth_register_regionLabel => 'Region / Country';

  @override
  String get auth_register_regionEmpty => 'Please enter your region';

  @override
  String get auth_register_ageLabel => 'Age';

  @override
  String get auth_register_ageEmpty => 'Please enter your age';

  @override
  String get auth_register_ageInvalid => 'Enter a valid age';

  @override
  String get auth_register_parentToggle => 'I\'m a parent registering my child';

  @override
  String get auth_register_parentApproval =>
      'Account will need parental approval';

  @override
  String get auth_register_button => 'Create Account';

  @override
  String get auth_register_alreadyHaveAccount => 'Already have an account? ';

  @override
  String get auth_forgotPassword_heading => 'Forgot Password?';

  @override
  String get auth_forgotPassword_description =>
      'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get auth_forgotPassword_emailLabel => 'Email Address';

  @override
  String get auth_forgotPassword_emailEmpty => 'Please enter your email';

  @override
  String get auth_forgotPassword_emailInvalid => 'Enter a valid email';

  @override
  String get auth_forgotPassword_sendButton => 'Send Reset Link';

  @override
  String get auth_forgotPassword_backToLogin => 'Back to Login';

  @override
  String get auth_forgotPassword_successHeading => 'Check your email';

  @override
  String auth_forgotPassword_successBody(String email) {
    return 'We\'ve sent a password reset link to\n$email\n\nClick the link to reset your password. It expires in 15 minutes.';
  }

  @override
  String get auth_forgotPassword_spamHint =>
      'Didn\'t receive it? Check your spam folder.';

  @override
  String get auth_forgotPassword_genericError =>
      'Something went wrong. Please try again.';

  @override
  String get nav_home => 'Home';

  @override
  String get nav_practice => 'Practice';

  @override
  String get nav_quran => 'Quran';

  @override
  String get nav_messages => 'Messages';

  @override
  String get nav_profile => 'Profile';

  @override
  String get nav_guestBanner => 'Guest mode — sign in to save your progress';

  @override
  String get guest_featureName_default => 'This Feature';

  @override
  String get dashboard_greeting => 'السلام عليكم';

  @override
  String get dashboard_streak => 'Streak';

  @override
  String dashboard_streakDays(int count) {
    return '$count Day';
  }

  @override
  String get dashboard_points => 'Points';

  @override
  String get dashboard_todaysClass => 'Today\'s Class';

  @override
  String get dashboard_startsIn => 'Starts in 2 hours';

  @override
  String get dashboard_join => 'Join';

  @override
  String get dashboard_quickActions => 'Quick Actions';

  @override
  String get dashboard_action_aiPractice => 'AI Practice';

  @override
  String get dashboard_action_mySchedule => 'My Schedule';

  @override
  String get dashboard_action_myProgress => 'My Progress';

  @override
  String get dashboard_action_attendance => 'Attendance';

  @override
  String get dashboard_action_messages => 'Messages';

  @override
  String get dashboard_action_leaderboard => 'Leaderboard';

  @override
  String get dashboard_live_subject => 'Quran Recitation — Level 2';

  @override
  String get practice_appBarTitle => 'Quran Practice';

  @override
  String get practice_chooseModeHeader => 'Choose Practice Mode';

  @override
  String get practice_recentHeader => 'Recent Practice';

  @override
  String practice_sessionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions',
      one: '1 session',
    );
    return '$_temp0';
  }

  @override
  String get practice_guestModalTitle => 'Sign in to Practice';

  @override
  String get practice_guestModalBody =>
      'Create a free account to start AI-powered Quran practice sessions.';

  @override
  String get practice_emptyTitle => 'No sessions yet';

  @override
  String get practice_emptyGuest => 'Sign in to track your practice history';

  @override
  String get practice_emptyUser =>
      'Complete a session above to see your history here';

  @override
  String get practice_orderQuizTitle => 'Order Quiz';

  @override
  String get practice_orderQuizDesc => 'Arrange the ayahs in the correct order';

  @override
  String get practice_mode_listenRepeatTitle => 'Listen & Repeat';

  @override
  String get practice_mode_listenRepeatDesc =>
      'AI recites each ayah, then you repeat after it';

  @override
  String get practice_mode_memorisationTitle => 'Memorisation Test';

  @override
  String get practice_mode_memorisationDesc =>
      'Recite from memory — text is revealed only after you speak';

  @override
  String get practice_mode_turnTakingTitle => 'Turn Taking';

  @override
  String get practice_mode_turnTakingDesc =>
      'You and the AI alternate ayahs together';

  @override
  String get setup_appBarTitle => 'Set Up Practice';

  @override
  String get setup_step1 => 'Choose a Surah';

  @override
  String get setup_step2 => 'Choose Practice Mode';

  @override
  String setup_ayahCount(int count) {
    return '$count ayahs';
  }

  @override
  String get setup_difficultyBeginner => 'Beginner';

  @override
  String get setup_difficultyIntermediate => 'Intermediate';

  @override
  String setup_startButton(String surahName) {
    return 'Start — $surahName';
  }

  @override
  String get setup_startButtonDisabled => 'Select Surah & Mode to Begin';

  @override
  String session_ayahProgress(int current, int total) {
    return 'Ayah $current of $total';
  }

  @override
  String get session_reciteFromMemory => 'Recite from memory';

  @override
  String get session_showTransliteration => 'Show transliteration';

  @override
  String get session_showTranslation => 'Show translation';

  @override
  String get session_yourRecitation => 'Your recitation:';

  @override
  String get session_noSpeechDetected => 'No speech detected';

  @override
  String get session_aiReciting => 'Listen carefully…';

  @override
  String get session_aiTurnReciting => 'AI is reciting its turn…';

  @override
  String get session_loadingRecitation => 'Loading recitation…';

  @override
  String get session_myTurnButton => 'My Turn — Recite Now';

  @override
  String get session_getReady => 'Get ready to recite…';

  @override
  String get session_go => 'Go!';

  @override
  String get session_recording => 'Recording — recite now';

  @override
  String get session_tapToStop => 'Tap ■ when you finish';

  @override
  String session_aiSuggestion(String label) {
    return 'AI suggests: $label — tap to confirm or choose differently';
  }

  @override
  String get session_correct => 'Correct';

  @override
  String get session_smallMistake => 'Mistake';

  @override
  String get session_wrong => 'Wrong';

  @override
  String get session_skipped => 'Skipped';

  @override
  String get session_hearAgain => 'Hear Again';

  @override
  String get session_skip => 'Skip';

  @override
  String get session_finish => 'Finish';

  @override
  String get session_endSessionTitle => 'End Session?';

  @override
  String session_endSessionBody(int completed, int total) {
    return 'You\'ve completed $completed of $total ayahs.';
  }

  @override
  String get session_end => 'End';

  @override
  String get session_endSessionButton => 'End Session';

  @override
  String get session_completionTitle => 'Session Complete';

  @override
  String get session_scoreLabel => 'Score';

  @override
  String get session_accuracyLabel => 'Accuracy';

  @override
  String get session_livesLeftLabel => 'Lives Left';

  @override
  String session_ayahNumber(int number) {
    return 'Ayah $number';
  }

  @override
  String get session_ayahBreakdown => 'Ayah Breakdown';

  @override
  String get session_mistakes => 'Mistakes';

  @override
  String get session_retryMistakes => 'Retry Mistakes';

  @override
  String get session_practiceAgain => 'Practice Again';

  @override
  String get session_backToPractice => 'Back to Practice';

  @override
  String get session_matchScore => 'Match score';

  @override
  String get session_completionGradeA =>
      'Excellent recitation! MashaAllah, you did beautifully. 🌟';

  @override
  String get session_completionGradeB =>
      'Good work! A little more practice and you\'ll be perfect. 💪';

  @override
  String get session_completionGradeC =>
      'Keep going! Regular practice makes perfect. You\'re improving. 📖';

  @override
  String get session_completionGradeD =>
      'Don\'t give up! Review the ayahs and try again. Every attempt counts. 🤲';

  @override
  String get schedule_appBarTitle => 'My Schedule';

  @override
  String get schedule_mon => 'Mon';

  @override
  String get schedule_tue => 'Tue';

  @override
  String get schedule_wed => 'Wed';

  @override
  String get schedule_thu => 'Thu';

  @override
  String get schedule_fri => 'Fri';

  @override
  String get schedule_sat => 'Sat';

  @override
  String get schedule_sun => 'Sun';

  @override
  String get schedule_statusUpcoming => 'Upcoming';

  @override
  String get schedule_statusCompleted => 'Completed';

  @override
  String get schedule_emptyTitle => 'No classes today';

  @override
  String get schedule_emptyBody =>
      'Enjoy your day off or use\nthis time for self-practice!';

  @override
  String get schedule_joinDialogTitle => 'Join Class';

  @override
  String get schedule_connecting => 'Connecting to class...';

  @override
  String get schedule_joinNow => 'Join Now';

  @override
  String schedule_demoSnackbar(String subject) {
    return 'Live class for $subject is not yet available in demo mode.';
  }

  @override
  String get schedule_requestTitle => 'Request a Session';

  @override
  String get schedule_requestSubtitle =>
      'Ask your teacher for an extra session';

  @override
  String get schedule_requestTeacherLabel => 'Teacher';

  @override
  String get schedule_requestSubjectLabel => 'Subject / Topic';

  @override
  String get schedule_requestNotesLabel => 'Additional notes (optional)';

  @override
  String get schedule_requestSent => 'Session request sent to your teacher.';

  @override
  String get schedule_sendRequest => 'Send Request';

  @override
  String get messages_appBarTitle => 'Messages';

  @override
  String get messages_searchHint => 'Search messages...';

  @override
  String get messages_emptyTitle => 'No messages yet';

  @override
  String get messages_emptyBody =>
      'Your conversations with teachers\nwill appear here';

  @override
  String get messages_newMessageTitle => 'New Message';

  @override
  String get messages_sendToLabel => 'Send to';

  @override
  String get messages_messageLabel => 'Message';

  @override
  String get messages_send => 'Send';

  @override
  String get messages_guestFeatureName => 'Your Messages';

  @override
  String get messages_guestDesc =>
      'Sign in to message your teachers and\nview class announcements.';

  @override
  String get chat_online => 'Online';

  @override
  String get chat_muteNotifications => 'Mute notifications';

  @override
  String get chat_clearChat => 'Clear chat';

  @override
  String get chat_report => 'Report';

  @override
  String get chat_today => 'Today';

  @override
  String get chat_inputHint => 'Type a message...';

  @override
  String get chat_fileSharingComingSoon => 'File sharing coming soon';

  @override
  String get live_leaveTitle => 'Leave Session?';

  @override
  String get live_leaveBody =>
      'Are you sure you want to leave the live session?';

  @override
  String get live_stay => 'Stay';

  @override
  String get live_leave => 'Leave';

  @override
  String get live_badge => 'LIVE';

  @override
  String get live_chatHeader => 'Questions & Chat';

  @override
  String get live_inputHint => 'Ask a question…';

  @override
  String get live_muted => 'Muted';

  @override
  String get live_unmute => 'Unmute';

  @override
  String get live_raiseHand => 'Raise';

  @override
  String get live_lowerHand => 'Lower';

  @override
  String get live_handRaised => 'Hand raised ✋';

  @override
  String get live_handLowered => 'Hand lowered';

  @override
  String live_messages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count messages',
      one: '1 message',
    );
    return '$_temp0';
  }

  @override
  String get profile_appBarTitle => 'My Profile';

  @override
  String get profile_guestName => 'Guest User';

  @override
  String get profile_guestMessage =>
      'Sign in to access your profile,\ntrack progress, and connect with teachers.';

  @override
  String get profile_studentRole => 'Student';

  @override
  String get profile_pointsLabel => 'Points';

  @override
  String profile_streakLabel(int count) {
    return '$count days';
  }

  @override
  String get profile_streakStatLabel => 'Streak';

  @override
  String get profile_badgesLabel => 'Badges';

  @override
  String get profile_sectionLearning => 'Learning';

  @override
  String get profile_menuProgress => 'My Progress';

  @override
  String get profile_menuBadges => 'My Badges';

  @override
  String get profile_menuLeaderboard => 'Leaderboard';

  @override
  String get profile_sectionAcademic => 'Academic';

  @override
  String get profile_menuAttendance => 'Attendance';

  @override
  String get profile_menuMarks => 'Marks';

  @override
  String get profile_menuReportCard => 'Report Card';

  @override
  String get profile_sectionAccount => 'Account';

  @override
  String get profile_menuHelp => 'Help & Support';

  @override
  String get profile_menuLogout => 'Logout';

  @override
  String get profile_logoutTitle => 'Logout';

  @override
  String get profile_logoutBody => 'Are you sure you want to log out?';

  @override
  String get notifications_appBarTitle => 'Notifications';

  @override
  String get notifications_markAllRead => 'Mark all read';

  @override
  String get notifications_groupToday => 'Today';

  @override
  String get notifications_groupYesterday => 'Yesterday';

  @override
  String get notifications_groupEarlier => 'Earlier';

  @override
  String get notifications_emptyTitle => 'All caught up!';

  @override
  String get notifications_emptyBody => 'No new notifications';

  @override
  String get settings_appBarTitle => 'Settings';

  @override
  String get settings_editButton => 'Edit';

  @override
  String get settings_sectionNotifications => 'Notifications';

  @override
  String get settings_classRemindersTitle => 'Class Reminders';

  @override
  String get settings_classRemindersSubtitle =>
      'Get notified 30 minutes before class';

  @override
  String get settings_achievementAlertsTitle => 'Achievement Alerts';

  @override
  String get settings_achievementAlertsSubtitle =>
      'Notify when you earn a badge';

  @override
  String get settings_teacherMessagesTitle => 'Teacher Messages';

  @override
  String get settings_teacherMessagesSubtitle =>
      'Notify on new messages from teachers';

  @override
  String get settings_practiceRemindersTitle => 'Practice Reminders';

  @override
  String get settings_practiceRemindersSubtitle =>
      'Daily reminder to maintain your streak';

  @override
  String get settings_sectionAccount => 'Account';

  @override
  String get settings_changePassword => 'Change Password';

  @override
  String get settings_language => 'Language';

  @override
  String get settings_sectionAbout => 'About';

  @override
  String get settings_appVersion => 'App Version';

  @override
  String get settings_privacyPolicy => 'Privacy Policy';

  @override
  String get settings_termsOfService => 'Terms of Service';

  @override
  String get settings_sectionAccountActions => 'Account Actions';

  @override
  String get settings_signOut => 'Sign Out';

  @override
  String get settings_selectLanguage => 'Select Language';

  @override
  String get settings_editProfileTitle => 'Edit Profile';

  @override
  String get settings_fullNameLabel => 'Full Name';

  @override
  String get settings_emailLabel => 'Email Address';

  @override
  String get settings_changePasswordTitle => 'Change Password';

  @override
  String get settings_currentPasswordLabel => 'Current Password';

  @override
  String get settings_newPasswordLabel => 'New Password';

  @override
  String get settings_confirmNewPasswordLabel => 'Confirm New Password';

  @override
  String get settings_updatePassword => 'Update Password';

  @override
  String get settings_signOutTitle => 'Sign Out';

  @override
  String get settings_signOutBody => 'Are you sure you want to sign out?';

  @override
  String get settings_privacyBody =>
      'Al-Abraar collects only the information needed to provide your learning experience: your name, email address, and usage data such as attendance and practice scores.\n\nWe do not sell or share your personal data with third parties. All data is encrypted in transit and at rest.\n\nYou may request deletion of your account and data at any time by contacting support@alabraar.com.\n\nThis policy was last updated: May 2026.';

  @override
  String get settings_termsBody =>
      'By using Al-Abraar you agree to use the app solely for lawful educational purposes.\n\nYou must not share your login credentials or attempt to access another student\'s account.\n\nAll course materials, recordings, and content within the app are the intellectual property of Al-Abraar Academy and may not be reproduced without written permission.\n\nAl-Abraar reserves the right to suspend accounts that violate these terms.\n\nLast updated: May 2026.';

  @override
  String get progress_appBarTitle => 'My Progress';

  @override
  String get progress_guestFeatureName => 'Your Progress';

  @override
  String get progress_guestDesc =>
      'Sign in to track your Quran memorisation,\nskills and weekly activity.';

  @override
  String get progress_overallTitle => 'Overall Progress';

  @override
  String get progress_surahsMemorised => 'Surahs Memorised';

  @override
  String get progress_ayahsRecited => 'Ayahs Recited';

  @override
  String get progress_practiceSessions => 'Practice Sessions';

  @override
  String get progress_thisWeek => 'This Week';

  @override
  String get progress_skillsBreakdown => 'Skills Breakdown';

  @override
  String get progress_skill_tajweed => 'Tajweed';

  @override
  String get progress_skill_memorisation => 'Memorisation';

  @override
  String get progress_skill_recitation => 'Recitation';

  @override
  String get progress_skill_arabic => 'Arabic';

  @override
  String get progress_surahProgress => 'Surah Progress';

  @override
  String get progress_surahComplete => 'Complete';

  @override
  String get progress_quranPercent => 'Quran';

  @override
  String get attendance_appBarTitle => 'Attendance';

  @override
  String get attendance_guestFeatureName => 'Your Attendance';

  @override
  String get attendance_guestDesc =>
      'Sign in to view your class attendance\nrecord and monthly calendar.';

  @override
  String get attendance_present => 'Present';

  @override
  String get attendance_absent => 'Absent';

  @override
  String get attendance_rate => 'Rate';

  @override
  String get attendance_legendPresent => 'Present';

  @override
  String get attendance_legendAbsent => 'Absent';

  @override
  String get attendance_legendExcused => 'Excused';

  @override
  String get attendance_legendNoClass => 'No Class';

  @override
  String get badges_appBarTitle => 'My Badges';

  @override
  String badges_earnedCount(int count) {
    return '$count badges earned';
  }

  @override
  String badges_remaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more to unlock',
      one: '1 more to unlock',
    );
    return '$_temp0';
  }

  @override
  String get badges_sectionEarned => 'Earned';

  @override
  String get badges_sectionLocked => 'Locked';

  @override
  String get badges_statusEarned => 'Earned';

  @override
  String get badges_statusLocked => 'Not yet unlocked';

  @override
  String get badges_firstStepName => 'First Step';

  @override
  String get badges_firstStepDesc => 'Completed your first session';

  @override
  String get badges_streakName => '7-Day Streak';

  @override
  String get badges_streakDesc => 'Practiced 7 days in a row';

  @override
  String get badges_alfatihaName => 'Al-Fatiha';

  @override
  String get badges_alfatihaDesc => 'Memorised Al-Fatiha perfectly';

  @override
  String get badges_tajweedStarName => 'Tajweed Star';

  @override
  String get badges_tajweedStarDesc => 'Scored 90%+ on Tajweed';

  @override
  String get badges_earlyBirdName => 'Early Bird';

  @override
  String get badges_earlyBirdDesc => 'Attended 5 morning sessions';

  @override
  String get badges_consistentName => 'Consistent';

  @override
  String get badges_consistentDesc => 'Attended 10 classes in a row';

  @override
  String get badges_quickLearnerName => 'Quick Learner';

  @override
  String get badges_quickLearnerDesc => 'Memorised 3 surahs in a week';

  @override
  String get badges_teamPlayerName => 'Team Player';

  @override
  String get badges_teamPlayerDesc => 'Participated in group recitation';

  @override
  String get badges_streak30Name => '30-Day Streak';

  @override
  String get badges_streak30Desc => 'Practice 30 days in a row';

  @override
  String get badges_juzAmmaName => 'Juz Amma';

  @override
  String get badges_juzAmmaDesc => 'Memorise the entire Juz Amma';

  @override
  String get badges_hafizPathName => 'Hafiz Path';

  @override
  String get badges_hafizPathDesc => 'Complete 50% of the Quran';

  @override
  String get badges_perfectScoreName => 'Perfect Score';

  @override
  String get badges_perfectScoreDesc => 'Get 100% on 5 sessions';

  @override
  String get badges_nightOwlName => 'Night Owl';

  @override
  String get badges_nightOwlDesc => 'Complete 10 evening sessions';

  @override
  String get badges_scholarName => 'Scholar';

  @override
  String get badges_scholarDesc => 'Complete all Arabic modules';

  @override
  String get leaderboard_appBarTitle => 'Leaderboard';

  @override
  String get leaderboard_periodWeekly => 'Weekly';

  @override
  String get leaderboard_periodMonthly => 'Monthly';

  @override
  String get leaderboard_periodAllTime => 'All Time';

  @override
  String get leaderboard_podiumTitle => 'Top Recitors';

  @override
  String get leaderboard_youSuffix => '(You)';

  @override
  String get marks_appBarTitle => 'My Marks';

  @override
  String get marks_guestFeatureName => 'Your Marks';

  @override
  String get marks_guestDesc =>
      'Sign in to view your assessment\nresults and subject grades.';

  @override
  String get marks_tabRecent => 'Recent';

  @override
  String get marks_tabBySubject => 'By Subject';

  @override
  String get marks_statAverage => 'Average';

  @override
  String get marks_statBest => 'Best';

  @override
  String get marks_statTests => 'Tests';

  @override
  String marks_testCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tests',
      one: '1 test',
    );
    return '$_temp0';
  }

  @override
  String get reportCard_appBarTitle => 'Report Card';

  @override
  String get reportCard_guestFeatureName => 'Your Report Card';

  @override
  String get reportCard_guestDesc =>
      'Sign in to view your term grades,\nteacher comments, and subject results.';

  @override
  String get reportCard_downloadTooltip => 'Download PDF';

  @override
  String get reportCard_downloadComingSoon => 'PDF download coming soon';

  @override
  String get reportCard_term1 => 'Term 1';

  @override
  String get reportCard_term2 => 'Term 2';

  @override
  String get reportCard_term3 => 'Term 3';

  @override
  String get reportCard_overallGrade => 'Overall Grade';

  @override
  String get reportCard_averageSuffix => '% average';

  @override
  String get reportCard_statAttendance => 'Attendance';

  @override
  String get reportCard_statSubjects => 'Subjects';

  @override
  String get reportCard_statTerm => 'Term';

  @override
  String get reportCard_subjectResults => 'Subject Results';

  @override
  String get reportCard_teacherComment => 'Teacher\'s Comment';

  @override
  String get help_appBarTitle => 'Help & Support';

  @override
  String get help_heroTitle => 'How can we help?';

  @override
  String get help_heroBody =>
      'Find answers below or contact our\nsupport team.';

  @override
  String get help_faqHeader => 'Frequently Asked Questions';

  @override
  String get help_contactHeader => 'Contact Us';

  @override
  String help_copiedSnackbar(String label) {
    return '$label copied';
  }

  @override
  String get help_faq1Q => 'How do I join a live class?';

  @override
  String get help_faq1A =>
      'Go to My Schedule and tap the \'Join\' button on your upcoming session card. Make sure you\'re on time — the button becomes active 5 minutes before the class starts.';

  @override
  String get help_faq2Q => 'How is my AI practice session scored?';

  @override
  String get help_faq2A =>
      'The AI listens to your recitation and compares it to the reference text. You can also self-assess using the Correct / Small Mistake / Wrong buttons. Your score and accuracy are saved to your progress.';

  @override
  String get help_faq3Q => 'How do I message my teacher?';

  @override
  String get help_faq3A =>
      'Open the Messages tab from the bottom navigation. Tap on your teacher\'s name to open the conversation. All your teachers are listed there.';

  @override
  String get help_faq4Q => 'What are badges and how do I earn them?';

  @override
  String get help_faq4A =>
      'Badges are rewards for achieving milestones — like completing a surah, maintaining a streak, or getting a high score. Visit My Badges from your Profile to see what you can earn next.';

  @override
  String get help_faq5Q => 'My attendance is marked incorrectly. What do I do?';

  @override
  String get help_faq5A =>
      'Please contact your teacher directly via the Messages tab. They can update your attendance record. You can also raise it in class.';

  @override
  String get help_faq6Q => 'How do I reset my password?';

  @override
  String get help_faq6A =>
      'Go to Profile → Settings → Change Password. If you have forgotten your password, use the Forgot Password option on the login screen.';

  @override
  String get help_faq7Q => 'Can I use the app without an internet connection?';

  @override
  String get help_faq7A =>
      'Some features like your schedule and recent progress are available offline. However, live classes, AI practice, and messaging require an internet connection.';

  @override
  String get help_contact_email => 'Email Support';

  @override
  String get help_contact_chat => 'Live Chat';

  @override
  String get help_contact_phone => 'Phone';

  @override
  String get help_contact_chatHours => 'Available Mon–Fri, 9 AM – 6 PM';

  @override
  String get quran_arabicTitle => 'القرآن الكريم';

  @override
  String get quran_englishTitle => 'The Holy Quran';

  @override
  String get quran_searchHint => 'Search surahs…';

  @override
  String get quran_translationLanguage => 'Translation Language';

  @override
  String get quran_filterAll => 'All';

  @override
  String get quran_filterMeccan => 'Meccan';

  @override
  String get quran_filterMedinan => 'Medinan';

  @override
  String get quran_typeMeccan => 'Meccan';

  @override
  String get quran_typeMedinan => 'Medinan';

  @override
  String get quran_noSurahsFound => 'No surahs found';

  @override
  String get quran_difficultyBeginner => 'Beginner';

  @override
  String get quran_difficultyIntermediate => 'Intermediate';

  @override
  String get quran_player_chooseReciter => 'Choose Reciter';

  @override
  String get quran_player_repetitionsTitle => 'Repetitions per Ayah';

  @override
  String get quran_player_repetitionsDesc =>
      'Each ayah will play this many times before advancing';

  @override
  String quran_player_time(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'times',
      one: 'time',
    );
    return '$_temp0';
  }

  @override
  String get quran_player_loadingError => 'Could not load ayahs.';

  @override
  String quran_player_ayahCounter(int current, int total) {
    return 'Ayah $current / $total';
  }

  @override
  String quran_player_completionTitle(String surahName) {
    return '$surahName Complete!';
  }

  @override
  String get quran_player_completionMessage =>
      'JazakAllah khair for listening.';

  @override
  String get quran_player_listenAgain => 'Listen Again';
}
