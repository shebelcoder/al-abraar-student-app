import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';

class LiveViewerScreen extends StatefulWidget {
  final String teacherName;
  final String subject;
  final String teacherInitials;
  final Color teacherColor;

  const LiveViewerScreen({
    super.key,
    required this.teacherName,
    required this.subject,
    required this.teacherInitials,
    required this.teacherColor,
  });

  @override
  State<LiveViewerScreen> createState() => _LiveViewerScreenState();
}

class _LiveViewerScreenState extends State<LiveViewerScreen>
    with TickerProviderStateMixin {
  final _questionCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _focusNode = FocusNode();

  late Timer _timer;
  int _seconds = 0;
  int _viewerCount = 8;
  bool _handRaised = false;
  bool _isMuted = false;

  final _random = Random();
  final List<_ChatMessage> _messages = [];

  static final _seedMessages = [
    _ChatMessage(name: 'Fatima Hassan', initials: 'FH',
        color: const Color(0xFF8B5CF6), text: 'Assalamu alaikum ustadh!', isMe: false),
    _ChatMessage(name: 'Ahmed Al-Rashid', initials: 'AR',
        color: const Color(0xFF166534), text: 'JazakAllah khair for the lesson', isMe: false),
    _ChatMessage(name: 'Omar Khalid', initials: 'OK',
        color: const Color(0xFFF97316), text: 'Can you repeat the makharij for ض please?', isMe: false),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _messages.addAll(_seedMessages);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _seconds++;
        if (_seconds % 15 == 0) {
          _viewerCount = max(4, _viewerCount + _random.nextInt(3) - 1);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _questionCtrl.dispose();
    _scrollCtrl.dispose();
    _focusNode.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  String get _elapsed {
    final m = _seconds ~/ 60;
    final s = _seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _sendQuestion(AppLocalizations l) {
    final text = _questionCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(
        name: l.common_you,
        initials: 'ME',
        color: AppTheme.primaryGreen,
        text: text,
        isMe: true,
      ));
    });
    _questionCtrl.clear();
    _focusNode.unfocus();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _toggleHand(AppLocalizations l) {
    setState(() => _handRaised = !_handRaised);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(_handRaised ? l.live_handRaised : l.live_handLowered),
      backgroundColor: _handRaised ? AppTheme.goldAccent : AppTheme.textSecondary,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  Future<bool> _onLeave(AppLocalizations l) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l.live_leaveTitle),
        content: Text(l.live_leaveBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.live_stay),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.live_leave,
                style: const TextStyle(color: AppTheme.errorRed)),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _onLeave(l) && context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              // ── Video area ──────────────────────────────────────────────
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: const Color(0xFF111827),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: widget.teacherColor.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: widget.teacherColor, width: 3),
                            ),
                            child: Center(
                              child: Text(
                                widget.teacherInitials,
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  color: widget.teacherColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.teacherName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.subject,
                            style: const TextStyle(
                                color: Colors.white60, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    // Top bar
                    Positioned(
                      top: 12,
                      left: 12,
                      right: 12,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(l.live_badge,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1)),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(_elapsed,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.visibility_rounded,
                                    size: 13, color: Colors.white70),
                                const SizedBox(width: 4),
                                Text('$_viewerCount',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () async {
                              if (await _onLeave(l) && context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.errorRed,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(l.live_leave,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Bottom controls
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _ControlButton(
                            icon: _isMuted
                                ? Icons.mic_off_rounded
                                : Icons.mic_rounded,
                            label: _isMuted ? l.live_unmute : l.live_muted,
                            active: !_isMuted,
                            onTap: () => setState(() => _isMuted = !_isMuted),
                          ),
                          const SizedBox(width: 20),
                          _ControlButton(
                            icon: _handRaised
                                ? Icons.back_hand_rounded
                                : Icons.back_hand_outlined,
                            label: _handRaised ? l.live_lowerHand : l.live_raiseHand,
                            active: _handRaised,
                            activeColor: AppTheme.goldAccent,
                            onTap: () => _toggleHand(l),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Chat / Q&A area ─────────────────────────────────────────
              Expanded(
                flex: 4,
                child: Container(
                  color: const Color(0xFF1A1A2E),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                        child: Row(
                          children: [
                            const Icon(Icons.chat_bubble_rounded,
                                size: 14, color: Colors.white54),
                            const SizedBox(width: 6),
                            Text(l.live_chatHeader,
                                style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                            const Spacer(),
                            Text(l.live_messages(_messages.length),
                                style: const TextStyle(
                                    color: Colors.white38, fontSize: 11)),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Colors.white10),
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollCtrl,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          itemCount: _messages.length,
                          itemBuilder: (_, i) =>
                              _MessageBubble(msg: _messages[i], l: l),
                        ),
                      ),
                      Container(
                        color: const Color(0xFF111124),
                        padding: EdgeInsets.fromLTRB(
                            12,
                            8,
                            12,
                            8 + MediaQuery.of(context).viewInsets.bottom),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _questionCtrl,
                                focusNode: _focusNode,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                                textInputAction: TextInputAction.send,
                                onSubmitted: (_) => _sendQuestion(l),
                                decoration: InputDecoration(
                                  hintText: l.live_inputHint,
                                  hintStyle: const TextStyle(
                                      color: Colors.white38, fontSize: 13),
                                  filled: true,
                                  fillColor: Colors.white10,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: const BorderSide(
                                        color: AppTheme.primaryGreen, width: 1),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _sendQuestion(l),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: AppTheme.primaryGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.send_rounded,
                                    color: Colors.white, size: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final Color? activeColor;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? (activeColor ?? Colors.white) : Colors.white38;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: active
                  ? (activeColor ?? Colors.white).withValues(alpha: 0.15)
                  : Colors.white10,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage msg;
  final AppLocalizations l;
  const _MessageBubble({required this.msg, required this.l});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: msg.color.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                msg.initials,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: msg.color),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  msg.isMe ? l.common_you : msg.name,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: msg.isMe ? AppTheme.primaryGreen : msg.color),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: msg.isMe
                        ? AppTheme.primaryGreen.withValues(alpha: 0.2)
                        : Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    msg.text,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 13, height: 1.4),
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

class _ChatMessage {
  final String name;
  final String initials;
  final Color color;
  final String text;
  final bool isMe;
  const _ChatMessage({
    required this.name,
    required this.initials,
    required this.color,
    required this.text,
    required this.isMe,
  });
}
