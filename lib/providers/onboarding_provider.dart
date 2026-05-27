import 'package:flutter_riverpod/flutter_riverpod.dart';

// Pre-loaded in main() before runApp() — same pattern as appCookieJar.
late final bool onboardingSeen;

// StateProvider so the router redirect re-evaluates when clearSeen() or markSeen() is called.
final onboardingSeenProvider =
    StateProvider<bool>((ref) => onboardingSeen);

// Set when the user picks Child or Adult on Page 2.
// 'child' | 'adult' | null (skipped)
final userTypeProvider = StateProvider<String?>((ref) => null);
