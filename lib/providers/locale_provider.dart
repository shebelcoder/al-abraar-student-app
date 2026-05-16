import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => const Locale('en');

  void setLocale(Locale locale) => state = locale;
}

final localeProvider =
    NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

/// Native display names for the supported locales.
/// Keys are locale language codes; values are displayed in their own script.
const Map<String, Locale> supportedLocaleNames = {
  'English': Locale('en'),
  'العربية': Locale('ar'),
  'Français': Locale('fr'),
  'Soomaali': Locale('so'),
};
