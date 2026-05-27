// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Al-Abraar Étudiant';

  @override
  String get common_cancel => 'Annuler';

  @override
  String get common_save => 'Enregistrer';

  @override
  String get common_ok => 'OK';

  @override
  String get common_retry => 'Réessayer';

  @override
  String get common_done => 'Terminé';

  @override
  String get common_back => 'Retour';

  @override
  String get common_continue => 'Continuer';

  @override
  String get common_signIn => 'Se connecter';

  @override
  String get common_createAccount => 'Créer un compte';

  @override
  String get common_register => 'S\'inscrire';

  @override
  String get common_loading => 'Chargement…';

  @override
  String get common_error_noInternet =>
      'Vérifiez votre connexion Internet et réessayez.';

  @override
  String get common_comingSoon => 'Bientôt';

  @override
  String get common_you => 'Vous';

  @override
  String get splash_subtitle => 'Académie d\'apprentissage du Coran';

  @override
  String get auth_login_title => 'Connexion étudiant';

  @override
  String get auth_login_emailLabel => 'Adresse e-mail';

  @override
  String get auth_login_emailEmpty => 'Veuillez saisir votre e-mail';

  @override
  String get auth_login_emailInvalid => 'Saisissez un e-mail valide';

  @override
  String get auth_login_passwordLabel => 'Mot de passe';

  @override
  String get auth_login_passwordEmpty => 'Veuillez saisir votre mot de passe';

  @override
  String get auth_login_passwordShort =>
      'Le mot de passe doit comporter au moins 6 caractères';

  @override
  String get auth_login_forgotPassword => 'Mot de passe oublié ?';

  @override
  String get auth_login_demoHint => 'Démo : student@alabraar.com / student123';

  @override
  String get auth_login_button => 'Connexion';

  @override
  String get auth_login_orDivider => 'ou';

  @override
  String get auth_login_continueAsGuest => 'Continuer en tant qu\'invité';

  @override
  String get auth_login_noAccount => 'Pas encore de compte ? ';

  @override
  String get auth_register_appBarTitle => 'Créer un compte';

  @override
  String get auth_register_heading => 'Rejoindre Al-Abraar';

  @override
  String get auth_register_subtitle => 'Commencez votre apprentissage du Coran';

  @override
  String get auth_register_nameLabel => 'Nom complet';

  @override
  String get auth_register_nameEmpty => 'Veuillez saisir votre nom';

  @override
  String get auth_register_emailLabel => 'Adresse e-mail';

  @override
  String get auth_register_emailEmpty => 'Veuillez saisir votre e-mail';

  @override
  String get auth_register_emailInvalid => 'Saisissez un e-mail valide';

  @override
  String get auth_register_passwordLabel => 'Mot de passe';

  @override
  String get auth_register_passwordHint => 'Au moins 8 caractères';

  @override
  String get auth_register_passwordEmpty => 'Veuillez saisir un mot de passe';

  @override
  String get auth_register_passwordShort =>
      'Le mot de passe doit comporter au moins 8 caractères';

  @override
  String get auth_register_confirmLabel => 'Confirmer le mot de passe';

  @override
  String get auth_register_confirmEmpty => 'Veuillez confirmer le mot de passe';

  @override
  String get auth_register_confirmMismatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get auth_register_regionLabel => 'Région / Pays';

  @override
  String get auth_register_regionEmpty => 'Veuillez saisir votre région';

  @override
  String get auth_register_ageLabel => 'Âge';

  @override
  String get auth_register_ageEmpty => 'Veuillez saisir votre âge';

  @override
  String get auth_register_ageInvalid => 'Saisissez un âge valide';

  @override
  String get auth_register_parentToggle =>
      'Je suis un parent inscrivant mon enfant';

  @override
  String get auth_register_parentApproval =>
      'Le compte nécessitera l\'approbation parentale';

  @override
  String get auth_register_button => 'Créer un compte';

  @override
  String get auth_register_alreadyHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get auth_forgotPassword_heading => 'Mot de passe oublié ?';

  @override
  String get auth_forgotPassword_description =>
      'Saisissez votre e-mail et nous vous enverrons un lien pour réinitialiser votre mot de passe.';

  @override
  String get auth_forgotPassword_emailLabel => 'Adresse e-mail';

  @override
  String get auth_forgotPassword_emailEmpty => 'Veuillez saisir votre e-mail';

  @override
  String get auth_forgotPassword_emailInvalid => 'Saisissez un e-mail valide';

  @override
  String get auth_forgotPassword_sendButton =>
      'Envoyer le lien de réinitialisation';

  @override
  String get auth_forgotPassword_backToLogin => 'Retour à la connexion';

  @override
  String get auth_forgotPassword_successHeading => 'Vérifiez votre e-mail';

  @override
  String auth_forgotPassword_successBody(String email) {
    return 'Nous avons envoyé un lien de réinitialisation à\n$email\n\nCliquez sur le lien pour réinitialiser votre mot de passe. Il expire dans 15 minutes.';
  }

  @override
  String get auth_forgotPassword_spamHint =>
      'Vous ne l\'avez pas reçu ? Vérifiez vos spams.';

  @override
  String get auth_forgotPassword_genericError =>
      'Une erreur s\'est produite. Veuillez réessayer.';

  @override
  String get nav_home => 'Accueil';

  @override
  String get nav_practice => 'Pratique';

  @override
  String get nav_quran => 'Coran';

  @override
  String get nav_messages => 'Messages';

  @override
  String get nav_profile => 'Profil';

  @override
  String get nav_guestBanner =>
      'Mode invité — connectez-vous pour sauvegarder vos progrès';

  @override
  String get guest_featureName_default => 'Cette fonctionnalité';

  @override
  String get dashboard_greeting => 'السلام عليكم';

  @override
  String get dashboard_streak => 'Série';

  @override
  String dashboard_streakDays(int count) {
    return '$count jour';
  }

  @override
  String get dashboard_points => 'Points';

  @override
  String get dashboard_todaysClass => 'Cours du jour';

  @override
  String get dashboard_startsIn => 'Commence dans 2 heures';

  @override
  String get dashboard_join => 'Rejoindre';

  @override
  String get dashboard_quickActions => 'Actions rapides';

  @override
  String get dashboard_action_aiPractice => 'Pratique IA';

  @override
  String get dashboard_action_mySchedule => 'Mon planning';

  @override
  String get dashboard_action_myProgress => 'Mes progrès';

  @override
  String get dashboard_action_attendance => 'Présence';

  @override
  String get dashboard_action_messages => 'Messages';

  @override
  String get dashboard_action_leaderboard => 'Classement';

  @override
  String get dashboard_live_subject => 'Récitation du Coran — Niveau 2';

  @override
  String get practice_appBarTitle => 'Pratique du Coran';

  @override
  String get practice_chooseModeHeader => 'Choisissez un mode de pratique';

  @override
  String get practice_recentHeader => 'Pratique récente';

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
  String get practice_guestModalTitle => 'Connectez-vous pour pratiquer';

  @override
  String get practice_guestModalBody =>
      'Créez un compte gratuit pour commencer les sessions de pratique du Coran avec l\'IA.';

  @override
  String get practice_emptyTitle => 'Aucune session pour l\'instant';

  @override
  String get practice_emptyGuest =>
      'Connectez-vous pour suivre votre historique de pratique';

  @override
  String get practice_emptyUser =>
      'Complétez une session ci-dessus pour la voir ici';

  @override
  String get practice_orderQuizTitle => 'Quiz d\'ordre';

  @override
  String get practice_orderQuizDesc => 'Arrangez les ayahs dans le bon ordre';

  @override
  String get practice_mode_listenRepeatTitle => 'Écouter & répéter';

  @override
  String get practice_mode_listenRepeatDesc =>
      'L\'IA récite chaque ayah, puis vous répétez';

  @override
  String get practice_mode_memorisationTitle => 'Test de mémorisation';

  @override
  String get practice_mode_memorisationDesc =>
      'Récitez de mémoire — le texte est révélé après votre récitation';

  @override
  String get practice_mode_turnTakingTitle => 'À tour de rôle';

  @override
  String get practice_mode_turnTakingDesc =>
      'Vous et l\'IA alternez les ayahs ensemble';

  @override
  String get setup_appBarTitle => 'Préparer la pratique';

  @override
  String get setup_step1 => 'Choisissez une sourate';

  @override
  String get setup_step2 => 'Choisissez le mode de pratique';

  @override
  String setup_ayahCount(int count) {
    return '$count ayahs';
  }

  @override
  String get setup_difficultyBeginner => 'Débutant';

  @override
  String get setup_difficultyIntermediate => 'Intermédiaire';

  @override
  String setup_startButton(String surahName) {
    return 'Commencer — $surahName';
  }

  @override
  String get setup_startButtonDisabled =>
      'Sélectionnez une sourate et un mode pour commencer';

  @override
  String session_ayahProgress(int current, int total) {
    return 'Ayah $current sur $total';
  }

  @override
  String get session_reciteFromMemory => 'Récitez de mémoire';

  @override
  String get session_showTransliteration => 'Afficher la translittération';

  @override
  String get session_showTranslation => 'Afficher la traduction';

  @override
  String get session_yourRecitation => 'Votre récitation :';

  @override
  String get session_noSpeechDetected => 'Aucune parole détectée';

  @override
  String get session_aiReciting => 'Écoutez attentivement…';

  @override
  String get session_aiTurnReciting => 'L\'IA récite son tour…';

  @override
  String get session_loadingRecitation => 'Chargement de la récitation…';

  @override
  String get session_myTurnButton => 'Mon tour — Réciter maintenant';

  @override
  String get session_getReady => 'Préparez-vous à réciter…';

  @override
  String get session_go => 'Partez !';

  @override
  String get session_recording => 'Enregistrement — récitez maintenant';

  @override
  String get session_tapToStop => 'Appuyez sur ■ quand vous avez terminé';

  @override
  String session_aiSuggestion(String label) {
    return 'L\'IA suggère : $label — appuyez pour confirmer ou choisissez autrement';
  }

  @override
  String get session_correct => 'Correct';

  @override
  String get session_smallMistake => 'Petite erreur';

  @override
  String get session_wrong => 'Incorrect';

  @override
  String get session_skipped => 'Ignoré';

  @override
  String get session_hearAgain => 'Réécouter';

  @override
  String get session_skip => 'Passer';

  @override
  String get session_finish => 'Terminer';

  @override
  String get session_endSessionTitle => 'Terminer la session ?';

  @override
  String session_endSessionBody(int completed, int total) {
    return 'Vous avez complété $completed sur $total ayahs.';
  }

  @override
  String get session_end => 'Terminer';

  @override
  String get session_endSessionButton => 'Terminer la session';

  @override
  String get session_completionTitle => 'Session terminée';

  @override
  String get session_scoreLabel => 'Score';

  @override
  String get session_accuracyLabel => 'Précision';

  @override
  String get session_livesLeftLabel => 'Vies restantes';

  @override
  String session_ayahNumber(int number) {
    return 'Ayah $number';
  }

  @override
  String get session_ayahBreakdown => 'Détail par ayah';

  @override
  String get session_mistakes => 'Erreurs';

  @override
  String get session_retryMistakes => 'Recommencer les erreurs';

  @override
  String get session_practiceAgain => 'Pratiquer à nouveau';

  @override
  String get session_backToPractice => 'Retour à la pratique';

  @override
  String get session_matchScore => 'Score de correspondance';

  @override
  String get session_completionGradeA =>
      'Excellente récitation ! MashaAllah, vous avez brillé. 🌟';

  @override
  String get session_completionGradeB =>
      'Bon travail ! Un peu plus de pratique et ce sera parfait. 💪';

  @override
  String get session_completionGradeC =>
      'Continuez ! La pratique régulière mène à la perfection. Vous progressez. 📖';

  @override
  String get session_completionGradeD =>
      'Ne vous découragez pas ! Révisez les ayahs et réessayez. Chaque tentative compte. 🤲';

  @override
  String get schedule_appBarTitle => 'Mon planning';

  @override
  String get schedule_mon => 'Lun';

  @override
  String get schedule_tue => 'Mar';

  @override
  String get schedule_wed => 'Mer';

  @override
  String get schedule_thu => 'Jeu';

  @override
  String get schedule_fri => 'Ven';

  @override
  String get schedule_sat => 'Sam';

  @override
  String get schedule_sun => 'Dim';

  @override
  String get schedule_statusUpcoming => 'À venir';

  @override
  String get schedule_statusCompleted => 'Terminé';

  @override
  String get schedule_emptyTitle => 'Pas de cours aujourd\'hui';

  @override
  String get schedule_emptyBody =>
      'Profitez de votre journée ou utilisez\nce temps pour vous entraîner !';

  @override
  String get schedule_joinDialogTitle => 'Rejoindre le cours';

  @override
  String get schedule_connecting => 'Connexion au cours...';

  @override
  String get schedule_joinNow => 'Rejoindre maintenant';

  @override
  String schedule_demoSnackbar(String subject) {
    return 'Le cours en direct pour $subject n\'est pas encore disponible en mode démo.';
  }

  @override
  String get schedule_requestTitle => 'Demander une session';

  @override
  String get schedule_requestSubtitle =>
      'Demandez à votre enseignant une session supplémentaire';

  @override
  String get schedule_requestTeacherLabel => 'Enseignant';

  @override
  String get schedule_requestSubjectLabel => 'Matière / Sujet';

  @override
  String get schedule_requestNotesLabel => 'Notes supplémentaires (facultatif)';

  @override
  String get schedule_requestSent =>
      'Demande de session envoyée à votre enseignant.';

  @override
  String get schedule_sendRequest => 'Envoyer la demande';

  @override
  String get messages_appBarTitle => 'Messages';

  @override
  String get messages_searchHint => 'Rechercher des messages...';

  @override
  String get messages_emptyTitle => 'Aucun message pour l\'instant';

  @override
  String get messages_emptyBody =>
      'Vos conversations avec les enseignants\napparaîtront ici';

  @override
  String get messages_newMessageTitle => 'Nouveau message';

  @override
  String get messages_sendToLabel => 'Envoyer à';

  @override
  String get messages_messageLabel => 'Message';

  @override
  String get messages_send => 'Envoyer';

  @override
  String get messages_guestFeatureName => 'Vos messages';

  @override
  String get messages_guestDesc =>
      'Connectez-vous pour envoyer des messages\nà vos enseignants et consulter les annonces.';

  @override
  String get chat_online => 'En ligne';

  @override
  String get chat_muteNotifications => 'Désactiver les notifications';

  @override
  String get chat_clearChat => 'Effacer la conversation';

  @override
  String get chat_report => 'Signaler';

  @override
  String get chat_today => 'Aujourd\'hui';

  @override
  String get chat_inputHint => 'Tapez un message...';

  @override
  String get chat_fileSharingComingSoon =>
      'Partage de fichiers bientôt disponible';

  @override
  String get live_leaveTitle => 'Quitter la session ?';

  @override
  String get live_leaveBody =>
      'Êtes-vous sûr de vouloir quitter la session en direct ?';

  @override
  String get live_stay => 'Rester';

  @override
  String get live_leave => 'Quitter';

  @override
  String get live_badge => 'EN DIRECT';

  @override
  String get live_chatHeader => 'Questions & Chat';

  @override
  String get live_inputHint => 'Posez une question…';

  @override
  String get live_muted => 'Muet';

  @override
  String get live_unmute => 'Activer le son';

  @override
  String get live_raiseHand => 'Lever';

  @override
  String get live_lowerHand => 'Baisser';

  @override
  String get live_handRaised => 'Main levée ✋';

  @override
  String get live_handLowered => 'Main baissée';

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
  String get profile_appBarTitle => 'Mon profil';

  @override
  String get profile_guestName => 'Utilisateur invité';

  @override
  String get profile_guestMessage =>
      'Connectez-vous pour accéder à votre profil,\nsuivre vos progrès et interagir avec les enseignants.';

  @override
  String get profile_studentRole => 'Étudiant';

  @override
  String get profile_pointsLabel => 'Points';

  @override
  String profile_streakLabel(int count) {
    return '$count jours';
  }

  @override
  String get profile_streakStatLabel => 'Série';

  @override
  String get profile_badgesLabel => 'Badges';

  @override
  String get profile_sectionLearning => 'Apprentissage';

  @override
  String get profile_menuProgress => 'Mes progrès';

  @override
  String get profile_menuBadges => 'Mes badges';

  @override
  String get profile_menuLeaderboard => 'Classement';

  @override
  String get profile_sectionAcademic => 'Académique';

  @override
  String get profile_menuAttendance => 'Présence';

  @override
  String get profile_menuMarks => 'Notes';

  @override
  String get profile_menuReportCard => 'Bulletin scolaire';

  @override
  String get profile_sectionAccount => 'Compte';

  @override
  String get profile_menuHelp => 'Aide & support';

  @override
  String get profile_menuLogout => 'Déconnexion';

  @override
  String get profile_logoutTitle => 'Déconnexion';

  @override
  String get profile_logoutBody =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get notifications_appBarTitle => 'Notifications';

  @override
  String get notifications_markAllRead => 'Tout marquer comme lu';

  @override
  String get notifications_groupToday => 'Aujourd\'hui';

  @override
  String get notifications_groupYesterday => 'Hier';

  @override
  String get notifications_groupEarlier => 'Plus tôt';

  @override
  String get notifications_emptyTitle => 'Tout est à jour !';

  @override
  String get notifications_emptyBody => 'Pas de nouvelles notifications';

  @override
  String get settings_appBarTitle => 'Paramètres';

  @override
  String get settings_editButton => 'Modifier';

  @override
  String get settings_sectionNotifications => 'Notifications';

  @override
  String get settings_classRemindersTitle => 'Rappels de cours';

  @override
  String get settings_classRemindersSubtitle =>
      'Soyez notifié 30 minutes avant le cours';

  @override
  String get settings_achievementAlertsTitle => 'Alertes de réussite';

  @override
  String get settings_achievementAlertsSubtitle =>
      'Notification lors de l\'obtention d\'un badge';

  @override
  String get settings_teacherMessagesTitle => 'Messages des enseignants';

  @override
  String get settings_teacherMessagesSubtitle =>
      'Notification lors de nouveaux messages';

  @override
  String get settings_practiceRemindersTitle => 'Rappels de pratique';

  @override
  String get settings_practiceRemindersSubtitle =>
      'Rappel quotidien pour maintenir votre série';

  @override
  String get settings_sectionAccount => 'Compte';

  @override
  String get settings_changePassword => 'Changer le mot de passe';

  @override
  String get settings_language => 'Langue';

  @override
  String get settings_sectionAbout => 'À propos';

  @override
  String get settings_appVersion => 'Version de l\'application';

  @override
  String get settings_privacyPolicy => 'Politique de confidentialité';

  @override
  String get settings_termsOfService => 'Conditions d\'utilisation';

  @override
  String get settings_sectionAccountActions => 'Actions du compte';

  @override
  String get settings_signOut => 'Se déconnecter';

  @override
  String get settings_selectLanguage => 'Choisir la langue';

  @override
  String get settings_editProfileTitle => 'Modifier le profil';

  @override
  String get settings_fullNameLabel => 'Nom complet';

  @override
  String get settings_emailLabel => 'Adresse e-mail';

  @override
  String get settings_changePasswordTitle => 'Changer le mot de passe';

  @override
  String get settings_currentPasswordLabel => 'Mot de passe actuel';

  @override
  String get settings_newPasswordLabel => 'Nouveau mot de passe';

  @override
  String get settings_confirmNewPasswordLabel =>
      'Confirmer le nouveau mot de passe';

  @override
  String get settings_updatePassword => 'Mettre à jour le mot de passe';

  @override
  String get settings_signOutTitle => 'Se déconnecter';

  @override
  String get settings_signOutBody =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get settings_privacyBody =>
      'Al-Abraar collecte uniquement les informations nécessaires à votre expérience d\'apprentissage : votre nom, adresse e-mail et données d\'utilisation comme la présence et les scores de pratique.\n\nNous ne vendons ni ne partageons vos données personnelles avec des tiers. Toutes les données sont chiffrées en transit et au repos.\n\nVous pouvez demander la suppression de votre compte et de vos données à tout moment en contactant support@alabraar.com.\n\nCette politique a été mise à jour en mai 2026.';

  @override
  String get settings_termsBody =>
      'En utilisant Al-Abraar, vous acceptez d\'utiliser l\'application uniquement à des fins éducatives légales.\n\nVous ne devez pas partager vos identifiants de connexion ni tenter d\'accéder au compte d\'un autre étudiant.\n\nTous les cours, enregistrements et contenus de l\'application sont la propriété intellectuelle d\'Al-Abraar Academy et ne peuvent être reproduits sans autorisation écrite.\n\nAl-Abraar se réserve le droit de suspendre les comptes qui enfreignent ces conditions.\n\nDernière mise à jour : mai 2026.';

  @override
  String get progress_appBarTitle => 'Mes progrès';

  @override
  String get progress_guestFeatureName => 'Vos progrès';

  @override
  String get progress_guestDesc =>
      'Connectez-vous pour suivre votre mémorisation du Coran,\nvos compétences et votre activité hebdomadaire.';

  @override
  String get progress_overallTitle => 'Progrès global';

  @override
  String get progress_surahsMemorised => 'Sourates mémorisées';

  @override
  String get progress_ayahsRecited => 'Ayahs récités';

  @override
  String get progress_practiceSessions => 'Sessions de pratique';

  @override
  String get progress_thisWeek => 'Cette semaine';

  @override
  String get progress_skillsBreakdown => 'Détail des compétences';

  @override
  String get progress_skill_tajweed => 'Tajweed';

  @override
  String get progress_skill_memorisation => 'Mémorisation';

  @override
  String get progress_skill_recitation => 'Récitation';

  @override
  String get progress_skill_arabic => 'Arabe';

  @override
  String get progress_surahProgress => 'Progression des sourates';

  @override
  String get progress_surahComplete => 'Complet';

  @override
  String get progress_quranPercent => 'Coran';

  @override
  String get attendance_appBarTitle => 'Présence';

  @override
  String get attendance_guestFeatureName => 'Votre présence';

  @override
  String get attendance_guestDesc =>
      'Connectez-vous pour consulter votre relevé de\nprésence et le calendrier mensuel.';

  @override
  String get attendance_present => 'Présent';

  @override
  String get attendance_absent => 'Absent';

  @override
  String get attendance_rate => 'Taux';

  @override
  String get attendance_legendPresent => 'Présent';

  @override
  String get attendance_legendAbsent => 'Absent';

  @override
  String get attendance_legendExcused => 'Justifié';

  @override
  String get attendance_legendNoClass => 'Pas de cours';

  @override
  String get badges_appBarTitle => 'Mes badges';

  @override
  String badges_earnedCount(int count) {
    return '$count badges obtenus';
  }

  @override
  String badges_remaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de plus à débloquer',
      one: '1 de plus à débloquer',
    );
    return '$_temp0';
  }

  @override
  String get badges_sectionEarned => 'Obtenus';

  @override
  String get badges_sectionLocked => 'Verrouillés';

  @override
  String get badges_statusEarned => 'Obtenu';

  @override
  String get badges_statusLocked => 'Pas encore débloqué';

  @override
  String get badges_firstStepName => 'Premier pas';

  @override
  String get badges_firstStepDesc => 'Complété votre première session';

  @override
  String get badges_streakName => 'Série de 7 jours';

  @override
  String get badges_streakDesc => 'Pratiqué 7 jours d\'affilée';

  @override
  String get badges_alfatihaName => 'Al-Fatiha';

  @override
  String get badges_alfatihaDesc => 'Mémorisé Al-Fatiha parfaitement';

  @override
  String get badges_tajweedStarName => 'Étoile du Tajweed';

  @override
  String get badges_tajweedStarDesc => 'Score 90%+ en Tajweed';

  @override
  String get badges_earlyBirdName => 'Lève-tôt';

  @override
  String get badges_earlyBirdDesc => 'Assisté à 5 sessions matinales';

  @override
  String get badges_consistentName => 'Régulier';

  @override
  String get badges_consistentDesc => 'Assisté à 10 cours d\'affilée';

  @override
  String get badges_quickLearnerName => 'Apprenez vite';

  @override
  String get badges_quickLearnerDesc => 'Mémorisé 3 sourates en une semaine';

  @override
  String get badges_teamPlayerName => 'Esprit d\'équipe';

  @override
  String get badges_teamPlayerDesc => 'Participé à la récitation collective';

  @override
  String get badges_streak30Name => 'Série de 30 jours';

  @override
  String get badges_streak30Desc => 'Pratiquer 30 jours d\'affilée';

  @override
  String get badges_juzAmmaName => 'Juz Amma';

  @override
  String get badges_juzAmmaDesc => 'Mémoriser tout le Juz Amma';

  @override
  String get badges_hafizPathName => 'Voie du Hafiz';

  @override
  String get badges_hafizPathDesc => 'Compléter 50% du Coran';

  @override
  String get badges_perfectScoreName => 'Score parfait';

  @override
  String get badges_perfectScoreDesc => 'Obtenir 100% sur 5 sessions';

  @override
  String get badges_nightOwlName => 'Noctambule';

  @override
  String get badges_nightOwlDesc => 'Compléter 10 sessions du soir';

  @override
  String get badges_scholarName => 'Érudit';

  @override
  String get badges_scholarDesc => 'Compléter tous les modules d\'arabe';

  @override
  String get leaderboard_appBarTitle => 'Classement';

  @override
  String get leaderboard_periodWeekly => 'Hebdomadaire';

  @override
  String get leaderboard_periodMonthly => 'Mensuel';

  @override
  String get leaderboard_periodAllTime => 'Tout temps';

  @override
  String get leaderboard_podiumTitle => 'Meilleurs récitants';

  @override
  String get leaderboard_youSuffix => '(Vous)';

  @override
  String get marks_appBarTitle => 'Mes notes';

  @override
  String get marks_guestFeatureName => 'Vos notes';

  @override
  String get marks_guestDesc =>
      'Connectez-vous pour consulter vos\nrésultats et notes par matière.';

  @override
  String get marks_tabRecent => 'Récentes';

  @override
  String get marks_tabBySubject => 'Par matière';

  @override
  String get marks_statAverage => 'Moyenne';

  @override
  String get marks_statBest => 'Meilleur';

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
  String get reportCard_appBarTitle => 'Bulletin scolaire';

  @override
  String get reportCard_guestFeatureName => 'Votre bulletin';

  @override
  String get reportCard_guestDesc =>
      'Connectez-vous pour consulter vos notes\ntrimestrielles et les commentaires de vos enseignants.';

  @override
  String get reportCard_downloadTooltip => 'Télécharger PDF';

  @override
  String get reportCard_downloadComingSoon =>
      'Téléchargement PDF bientôt disponible';

  @override
  String get reportCard_term1 => 'Trimestre 1';

  @override
  String get reportCard_term2 => 'Trimestre 2';

  @override
  String get reportCard_term3 => 'Trimestre 3';

  @override
  String get reportCard_overallGrade => 'Note globale';

  @override
  String get reportCard_averageSuffix => '% de moyenne';

  @override
  String get reportCard_statAttendance => 'Présence';

  @override
  String get reportCard_statSubjects => 'Matières';

  @override
  String get reportCard_statTerm => 'Trimestre';

  @override
  String get reportCard_subjectResults => 'Résultats par matière';

  @override
  String get reportCard_teacherComment => 'Commentaire de l\'enseignant';

  @override
  String get help_appBarTitle => 'Aide & support';

  @override
  String get help_heroTitle => 'Comment pouvons-nous vous aider ?';

  @override
  String get help_heroBody =>
      'Trouvez des réponses ci-dessous ou contactez\nnotre équipe d\'assistance.';

  @override
  String get help_faqHeader => 'Foire aux questions';

  @override
  String get help_contactHeader => 'Nous contacter';

  @override
  String help_copiedSnackbar(String label) {
    return '$label copié';
  }

  @override
  String get help_faq1Q => 'Comment rejoindre un cours en direct ?';

  @override
  String get help_faq1A =>
      'Allez dans Mon planning et appuyez sur le bouton «Rejoindre» de la session à venir. Soyez à l\'heure — le bouton s\'active 5 minutes avant le début du cours.';

  @override
  String get help_faq2Q => 'Comment ma session de pratique IA est-elle notée ?';

  @override
  String get help_faq2A =>
      'L\'IA écoute votre récitation et la compare au texte de référence. Vous pouvez également vous auto-évaluer avec les boutons Correct / Petite erreur / Incorrect. Votre score et votre précision sont enregistrés dans vos progrès.';

  @override
  String get help_faq3Q => 'Comment envoyer un message à mon enseignant ?';

  @override
  String get help_faq3A =>
      'Ouvrez l\'onglet Messages depuis la barre de navigation. Appuyez sur le nom de votre enseignant pour ouvrir la conversation. Tous vos enseignants y sont listés.';

  @override
  String get help_faq4Q => 'Que sont les badges et comment les obtenir ?';

  @override
  String get help_faq4A =>
      'Les badges sont des récompenses pour avoir atteint des étapes — compléter une sourate, maintenir une série ou obtenir un score élevé. Visitez Mes badges depuis votre Profil pour voir ce que vous pouvez obtenir.';

  @override
  String get help_faq5Q => 'Ma présence est mal enregistrée. Que faire ?';

  @override
  String get help_faq5A =>
      'Contactez votre enseignant directement via l\'onglet Messages. Il peut mettre à jour votre relevé de présence. Vous pouvez aussi en discuter en classe.';

  @override
  String get help_faq6Q => 'Comment réinitialiser mon mot de passe ?';

  @override
  String get help_faq6A =>
      'Allez dans Profil → Paramètres → Changer le mot de passe. Si vous l\'avez oublié, utilisez l\'option Mot de passe oublié sur l\'écran de connexion.';

  @override
  String get help_faq7Q =>
      'Puis-je utiliser l\'application sans connexion Internet ?';

  @override
  String get help_faq7A =>
      'Certaines fonctionnalités comme le planning et les progrès récents sont disponibles hors ligne. Cependant, les cours en direct, la pratique IA et la messagerie nécessitent une connexion Internet.';

  @override
  String get help_contact_email => 'Support par e-mail';

  @override
  String get help_contact_chat => 'Chat en direct';

  @override
  String get help_contact_phone => 'Téléphone';

  @override
  String get help_contact_chatHours => 'Disponible lun–ven, 9h–18h';

  @override
  String get quran_arabicTitle => 'القرآن الكريم';

  @override
  String get quran_englishTitle => 'Le Saint Coran';

  @override
  String get quran_searchHint => 'Rechercher des sourates…';

  @override
  String get quran_translationLanguage => 'Langue de traduction';

  @override
  String get quran_filterAll => 'Toutes';

  @override
  String get quran_filterMeccan => 'Mecquoises';

  @override
  String get quran_filterMedinan => 'Médinoises';

  @override
  String get quran_typeMeccan => 'Mecquoise';

  @override
  String get quran_typeMedinan => 'Médinoise';

  @override
  String get quran_noSurahsFound => 'Aucune sourate trouvée';

  @override
  String get quran_difficultyBeginner => 'Débutant';

  @override
  String get quran_difficultyIntermediate => 'Intermédiaire';

  @override
  String get quran_player_chooseReciter => 'Choisir un récitant';

  @override
  String get quran_player_repetitionsTitle => 'Répétitions par ayah';

  @override
  String get quran_player_repetitionsDesc =>
      'Chaque ayah sera joué ce nombre de fois avant de passer au suivant';

  @override
  String quran_player_time(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'fois',
      one: 'fois',
    );
    return '$_temp0';
  }

  @override
  String get quran_player_loadingError => 'Impossible de charger les ayahs.';

  @override
  String quran_player_ayahCounter(int current, int total) {
    return 'Ayah $current / $total';
  }

  @override
  String quran_player_completionTitle(String surahName) {
    return '$surahName terminée !';
  }

  @override
  String get quran_player_completionMessage =>
      'JazakAllah khair pour votre écoute.';

  @override
  String get quran_player_listenAgain => 'Réécouter';

  @override
  String get onboarding_skip => 'Passer';

  @override
  String get onboarding_next => 'Suivant';

  @override
  String get onboarding_getStarted => 'Commencer';

  @override
  String get onboarding_heroTitle => 'Al-Abraar';

  @override
  String get onboarding_heroArabic => 'الأبرار';

  @override
  String get onboarding_heroTagline => 'Apprendre · Réciter · Progresser';

  @override
  String get onboarding_whoTitle => 'Qui va utiliser l\'application ?';

  @override
  String get onboarding_childLabel => 'Enfant / Élève';

  @override
  String get onboarding_childSub => '5 à 17 ans';

  @override
  String get onboarding_adultLabel => 'Adulte / Parent';

  @override
  String get onboarding_adultSub => '18 ans et plus';

  @override
  String get onboarding_feat1Title => 'Apprendre le Coran';

  @override
  String get onboarding_feat1Desc =>
      'Leçons progressives avec des enseignants certifiés.';

  @override
  String get onboarding_feat2Title => 'Sessions en direct';

  @override
  String get onboarding_feat2Desc =>
      'Rejoignez des classes interactives de partout.';

  @override
  String get onboarding_feat3Title => 'Suivre les progrès';

  @override
  String get onboarding_feat3Desc =>
      'Badges, classements et bulletins détaillés.';

  @override
  String get onboarding_authTitle => 'Prêt à commencer ?';

  @override
  String get onboarding_createAccount => 'Créer un compte';

  @override
  String get onboarding_signIn => 'Se connecter';

  @override
  String get onboarding_browseFirst => 'Explorer d\'abord';

  @override
  String get settings_replayIntro => 'Introduction de l\'app';
}
