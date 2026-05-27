import 'package:flutter_riverpod/flutter_riverpod.dart';

// Pre-loaded in main() before runApp() — same pattern as appCookieJar.
late final bool onboardingSeen;

final onboardingSeenProvider = Provider<bool>((ref) => onboardingSeen);

// Set when the user picks Child or Adult on Page 2.
// 'child' | 'adult' | null (skipped)
final userTypeProvider = StateProvider<String?>((ref) => null);
