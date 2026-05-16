import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  int? _expanded;

  static const _faqs = [
    _FAQ(
      q: 'How do I join a live class?',
      a: "Go to My Schedule and tap the 'Join' button on your upcoming session card. Make sure you're on time — the button becomes active 5 minutes before the class starts.",
    ),
    _FAQ(
      q: 'How is my AI practice session scored?',
      a: 'The AI listens to your recitation and compares it to the reference text. You can also self-assess using the Correct / Small Mistake / Wrong buttons. Your score and accuracy are saved to your progress.',
    ),
    _FAQ(
      q: 'How do I message my teacher?',
      a: "Open the Messages tab from the bottom navigation. Tap on your teacher's name to open the conversation. All your teachers are listed there.",
    ),
    _FAQ(
      q: 'What are badges and how do I earn them?',
      a: 'Badges are rewards for achieving milestones — like completing a surah, maintaining a streak, or getting a high score. Visit My Badges from your Profile to see what you can earn next.',
    ),
    _FAQ(
      q: 'My attendance is marked incorrectly. What do I do?',
      a: 'Please contact your teacher directly via the Messages tab. They can update your attendance record. You can also raise it in class.',
    ),
    _FAQ(
      q: 'How do I reset my password?',
      a: 'Go to Profile → Settings → Change Password. If you have forgotten your password, use the Forgot Password option on the login screen.',
    ),
    _FAQ(
      q: 'Can I use the app without an internet connection?',
      a: 'Some features like your schedule and recent progress are available offline. However, live classes, AI practice, and messaging require an internet connection.',
    ),
  ];

  static const _contacts = [
    _Contact(Icons.email_outlined, 'Email Support',
        'support@alabraar.com', Color(0xFF6366F1)),
    _Contact(Icons.chat_bubble_outlined, 'Live Chat',
        'Available Mon–Fri, 9 AM – 6 PM', AppTheme.primaryGreen),
    _Contact(Icons.phone_outlined, 'Phone',
        '+44 20 1234 5678', AppTheme.goldAccent),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hero
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryGreen, Color(0xFF14532D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('How can we help?',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800)),
                      SizedBox(height: 4),
                      Text(
                        'Find answers below or contact our\nsupport team.',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 13, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const Text('🤝',
                    style: TextStyle(fontSize: 48)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // FAQ
          const Text('Frequently Asked Questions',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark)),
          const SizedBox(height: 12),
          ...List.generate(_faqs.length, (i) {
            final open = _expanded == i;
            return GestureDetector(
              onTap: () =>
                  setState(() => _expanded = open ? null : i),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: open
                      ? Border.all(
                          color: AppTheme.primaryGreen
                              .withValues(alpha: 0.3))
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _faqs[i].q,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: open
                                    ? AppTheme.primaryGreen
                                    : AppTheme.textDark,
                              ),
                            ),
                          ),
                          Icon(
                            open
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            color: open
                                ? AppTheme.primaryGreen
                                : AppTheme.textSecondary,
                          ),
                        ],
                      ),
                    ),
                    if (open)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            16, 0, 16, 16),
                        child: Text(
                          _faqs[i].a,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                            height: 1.6,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 24),

          // Contact options
          const Text('Contact Us',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark)),
          const SizedBox(height: 12),
          ..._contacts.map((c) => GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: c.detail));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${c.label} copied'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppTheme.primaryGreen,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceWhite,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: c.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(c.icon, color: c.color, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.label,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textDark)),
                            const SizedBox(height: 2),
                            Text(c.detail,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary)),
                          ],
                        ),
                      ),
                      const Icon(Icons.copy_rounded,
                          size: 16, color: AppTheme.textSecondary),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _FAQ {
  final String q;
  final String a;
  const _FAQ({required this.q, required this.a});
}

class _Contact {
  final IconData icon;
  final String label;
  final String detail;
  final Color color;
  const _Contact(this.icon, this.label, this.detail, this.color);
}
