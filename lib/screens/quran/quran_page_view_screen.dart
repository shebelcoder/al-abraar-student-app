import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Quran has 604 pages (Hafs / Uthmani script, standard mushaf)
const _kTotalPages = 604;

// High-quality Uthmanic page images from the Islamic Network CDN
String _pageImageUrl(int page) {
  final p = page.toString().padLeft(3, '0');
  return 'https://cdn.islamic.network/quran/images/high-resolution/$p.png';
}

class QuranPageViewScreen extends StatefulWidget {
  /// The mushaf page to open first (1-based, 1–604).
  final int initialPage;

  const QuranPageViewScreen({super.key, this.initialPage = 1});

  @override
  State<QuranPageViewScreen> createState() => _QuranPageViewScreenState();
}

class _QuranPageViewScreenState extends State<QuranPageViewScreen> {
  late final PageController _pageCtrl;
  late int _currentPage;
  bool _showOverlay = true;
  double _brightness = 1.0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage.clamp(1, _kTotalPages);
    _pageCtrl = PageController(initialPage: _currentPage - 1);

    // Full-screen immersive: hide status bar for a cleaner mushaf look.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _toggleOverlay() => setState(() => _showOverlay = !_showOverlay);

  void _showControls() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ControlsSheet(
        brightness: _brightness,
        onBrightnessChanged: (v) => setState(() => _brightness = v),
      ),
    );
  }

  void _goToPage(int page) {
    final clamped = page.clamp(1, _kTotalPages);
    _pageCtrl.animateToPage(
      clamped - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleOverlay,
        child: Stack(
          children: [
            // ── Page images ──────────────────────────────────────────────
            PageView.builder(
              controller: _pageCtrl,
              itemCount: _kTotalPages,
              onPageChanged: (i) => setState(() => _currentPage = i + 1),
              itemBuilder: (_, index) {
                final page = index + 1;
                return ColorFiltered(
                  colorFilter: ColorFilter.matrix(_brightnessMatrix(_brightness)),
                  child: CachedNetworkImage(
                    imageUrl: _pageImageUrl(page),
                    fit: BoxFit.contain,
                    placeholder: (_, __) => const Center(
                      child: CircularProgressIndicator(
                          color: Color(0xFF166534), strokeWidth: 2),
                    ),
                    errorWidget: (_, __, ___) => _ErrorPage(page: page),
                  ),
                );
              },
            ),

            // ── Top overlay: back + page number ─────────────────────────
            if (_showOverlay)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _TopBar(
                  page: _currentPage,
                  total: _kTotalPages,
                  onBack: () => Navigator.of(context).pop(),
                  onGoTo: _goToPage,
                ),
              ),

            // ── Bottom overlay: Controls button ──────────────────────────
            if (_showOverlay)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _BottomBar(onControls: _showControls),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Top bar
// ---------------------------------------------------------------------------

class _TopBar extends StatelessWidget {
  final int page;
  final int total;
  final VoidCallback onBack;
  final void Function(int) onGoTo;

  const _TopBar({
    required this.page,
    required this.total,
    required this.onBack,
    required this.onGoTo,
  });

  void _showGoToDialog(BuildContext context) {
    final ctrl = TextEditingController(text: '$page');
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Go to page',
            style: TextStyle(color: Colors.white, fontSize: 16)),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: '1 – $total',
            hintStyle: const TextStyle(color: Colors.white38),
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF166534))),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF166534), width: 2)),
          ),
          autofocus: true,
          onSubmitted: (v) {
            Navigator.pop(ctx);
            onGoTo(int.tryParse(v) ?? page);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onGoTo(int.tryParse(ctrl.text) ?? page);
            },
            child: const Text('Go',
                style: TextStyle(color: Color(0xFF166534))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black87, Colors.transparent],
        ),
      ),
      padding: EdgeInsets.fromLTRB(
          8, MediaQuery.of(context).padding.top + 4, 8, 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white),
            onPressed: onBack,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _showGoToDialog(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
              ),
              child: Text(
                'Page $page / $total',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48), // balance the back button
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom bar
// ---------------------------------------------------------------------------

class _BottomBar extends StatelessWidget {
  final VoidCallback onControls;
  const _BottomBar({required this.onControls});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black87, Colors.transparent],
        ),
      ),
      padding: EdgeInsets.fromLTRB(
          0, 16, 0, MediaQuery.of(context).padding.bottom + 8),
      child: Center(
        child: GestureDetector(
          onTap: onControls,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF166534),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF166534).withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.tune_rounded, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'Controls',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Controls sheet
// ---------------------------------------------------------------------------

class _ControlsSheet extends StatefulWidget {
  final double brightness;
  final ValueChanged<double> onBrightnessChanged;

  const _ControlsSheet({
    required this.brightness,
    required this.onBrightnessChanged,
  });

  @override
  State<_ControlsSheet> createState() => _ControlsSheetState();
}

class _ControlsSheetState extends State<_ControlsSheet> {
  late double _brightness;

  @override
  void initState() {
    super.initState();
    _brightness = widget.brightness;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          const Text(
            'Controls',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          // Brightness row
          Row(
            children: [
              const Icon(Icons.brightness_low_rounded,
                  color: Colors.white54, size: 20),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFF166534),
                    inactiveTrackColor: Colors.white24,
                    thumbColor: const Color(0xFF166534),
                    overlayColor:
                        const Color(0xFF166534).withValues(alpha: 0.2),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: _brightness,
                    min: 0.2,
                    max: 1.0,
                    onChanged: (v) {
                      setState(() => _brightness = v);
                      widget.onBrightnessChanged(v);
                    },
                  ),
                ),
              ),
              const Icon(Icons.brightness_high_rounded,
                  color: Colors.white, size: 20),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Brightness',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error fallback
// ---------------------------------------------------------------------------

class _ErrorPage extends StatelessWidget {
  final int page;
  const _ErrorPage({required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F0E8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.image_not_supported_outlined,
                size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text('Page $page unavailable',
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Brightness matrix helper
// ---------------------------------------------------------------------------

List<double> _brightnessMatrix(double brightness) {
  return [
    brightness, 0, 0, 0, 0,
    0, brightness, 0, 0, 0,
    0, 0, brightness, 0, 0,
    0, 0, 0, 1, 0,
  ];
}
