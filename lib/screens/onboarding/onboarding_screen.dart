import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/onboarding_provider.dart';
import '../../services/onboarding_prefs.dart';
import '../../theme/app_theme.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _ctrl = PageController();
  int _page = 0;
  String? _selectedType; // 'child' | 'adult'

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _goTo(int page) {
    _ctrl.animateToPage(
      page,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finish(BuildContext context, String route) async {
    await OnboardingPrefs.markSeen();
    // Update the in-memory provider so the router redirect re-evaluates immediately.
    ref.read(onboardingSeenProvider.notifier).state = true;
    if (_selectedType != null) {
      await OnboardingPrefs.saveUserType(_selectedType!);
      ref.read(userTypeProvider.notifier).state = _selectedType;
    }
    if (route == '/home/dashboard') {
      // "Browse first" — enter guest mode so the auth guard lets us through.
      await ref.read(authStateProvider.notifier).loginAsGuest();
    }
    if (context.mounted) context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      body: Stack(
        children: [
          PageView(
            controller: _ctrl,
            onPageChanged: (i) => setState(() => _page = i),
            children: [
              _HeroPage(l: l),
              _WhoPage(
                l: l,
                selected: _selectedType,
                onSelect: (t) => setState(() => _selectedType = t),
              ),
              _FeaturesPage(l: l),
              _AuthPage(l: l, onChoice: (route) => _finish(context, route)),
            ],
          ),
          // Skip button (pages 0-2)
          if (_page < 3)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 16,
              child: TextButton(
                onPressed: () => _goTo(3),
                child: Text(
                  l.onboarding_skip,
                  style: TextStyle(
                    color: _page == 0 ? Colors.white70 : AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          // Dot indicator + Next button (pages 0-2)
          if (_page < 3)
            Positioned(
              left: 24,
              right: 24,
              bottom: MediaQuery.of(context).padding.bottom + 32,
              child: Row(
                children: [
                  // Dots
                  Row(
                    children: List.generate(4, (i) {
                      final active = i == _page;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 6),
                        width: active ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _page == 0
                              ? (active
                                  ? Colors.white
                                  : Colors.white38)
                              : (active
                                  ? AppTheme.primaryGreen
                                  : const Color(0xFFD1D5DB)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const Spacer(),
                  // Next / Get Started
                  _page == 0
                      ? ElevatedButton(
                          onPressed: () => _goTo(1),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppTheme.primaryGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 14),
                          ),
                          child: Text(
                            l.onboarding_getStarted,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: _page == 1 && _selectedType == null
                              ? null
                              : () => _goTo(_page + 1),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryGreen,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                const Color(0xFFD1D5DB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 14),
                          ),
                          child: Text(
                            l.onboarding_next,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page 1 — Hero
// ---------------------------------------------------------------------------

class _HeroPage extends StatelessWidget {
  final AppLocalizations l;
  const _HeroPage({required this.l});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryGreen, Color(0xFF14532D)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('📖', style: TextStyle(fontSize: 52)),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              l.onboarding_heroTitle,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l.onboarding_heroArabic,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l.onboarding_heroTagline,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white60,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page 2 — Who is learning?
// ---------------------------------------------------------------------------

class _WhoPage extends StatelessWidget {
  final AppLocalizations l;
  final String? selected;
  final ValueChanged<String> onSelect;

  const _WhoPage({
    required this.l,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 64),
            Text(
              l.onboarding_whoTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: _TypeCard(
                    emoji: '🧒',
                    label: l.onboarding_childLabel,
                    sub: l.onboarding_childSub,
                    selected: selected == 'child',
                    onTap: () => onSelect('child'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _TypeCard(
                    emoji: '👤',
                    label: l.onboarding_adultLabel,
                    sub: l.onboarding_adultSub,
                    selected: selected == 'adult',
                    onTap: () => onSelect('adult'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String sub;
  final bool selected;
  final VoidCallback onTap;

  const _TypeCard({
    required this.emoji,
    required this.label,
    required this.sub,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primaryGreen.withValues(alpha: 0.06)
              : AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppTheme.primaryGreen
                : const Color(0xFFE5E7EB),
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: selected ? AppTheme.primaryGreen : AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              sub,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page 3 — Feature highlights
// ---------------------------------------------------------------------------

class _FeaturesPage extends StatefulWidget {
  final AppLocalizations l;
  const _FeaturesPage({required this.l});

  @override
  State<_FeaturesPage> createState() => _FeaturesPageState();
}

class _FeaturesPageState extends State<_FeaturesPage> {
  final _featureCtrl = PageController();
  int _featureIndex = 0;

  @override
  void dispose() {
    _featureCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.l;
    final features = [
      _FeatureData(
        emoji: '📖',
        color: AppTheme.primaryGreen,
        title: l.onboarding_feat1Title,
        desc: l.onboarding_feat1Desc,
      ),
      _FeatureData(
        emoji: '🎯',
        color: const Color(0xFF0EA5E9),
        title: l.onboarding_feat2Title,
        desc: l.onboarding_feat2Desc,
      ),
      _FeatureData(
        emoji: '🏆',
        color: AppTheme.goldAccent,
        title: l.onboarding_feat3Title,
        desc: l.onboarding_feat3Desc,
      ),
    ];

    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 48),
          Expanded(
            child: PageView.builder(
              controller: _featureCtrl,
              itemCount: features.length,
              onPageChanged: (i) => setState(() => _featureIndex = i),
              itemBuilder: (_, i) => _FeatureSlide(feature: features[i]),
            ),
          ),
          // Feature dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(features.length, (i) {
              final active = i == _featureIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active
                      ? AppTheme.primaryGreen
                      : const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          // Spacer so outer Next button doesn't overlap
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _FeatureData {
  final String emoji;
  final Color color;
  final String title;
  final String desc;
  const _FeatureData(
      {required this.emoji,
      required this.color,
      required this.title,
      required this.desc});
}

class _FeatureSlide extends StatelessWidget {
  final _FeatureData feature;
  const _FeatureSlide({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: feature.color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(feature.emoji,
                  style: const TextStyle(fontSize: 48)),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            feature.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            feature.desc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: AppTheme.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page 4 — Auth choice
// ---------------------------------------------------------------------------

class _AuthPage extends StatelessWidget {
  final AppLocalizations l;
  final ValueChanged<String> onChoice;

  const _AuthPage({required this.l, required this.onChoice});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🌟', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 24),
            Text(
              l.onboarding_authTitle,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => onChoice('/register'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  l.onboarding_createAccount,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton(
                onPressed: () => onChoice('/login'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryGreen,
                  side: const BorderSide(
                      color: AppTheme.primaryGreen, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  l.onboarding_signIn,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => onChoice('/home/dashboard'),
              child: Text(
                l.onboarding_browseFirst,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
