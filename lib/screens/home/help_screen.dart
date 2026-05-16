import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  int? _expanded;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    final faqs = [
      _FAQ(q: l.help_faq1Q, a: l.help_faq1A),
      _FAQ(q: l.help_faq2Q, a: l.help_faq2A),
      _FAQ(q: l.help_faq3Q, a: l.help_faq3A),
      _FAQ(q: l.help_faq4Q, a: l.help_faq4A),
      _FAQ(q: l.help_faq5Q, a: l.help_faq5A),
      _FAQ(q: l.help_faq6Q, a: l.help_faq6A),
      _FAQ(q: l.help_faq7Q, a: l.help_faq7A),
    ];

    final contacts = [
      _Contact(Icons.email_outlined, l.help_contact_email,
          'support@alabraar.com', const Color(0xFF6366F1)),
      _Contact(Icons.chat_bubble_outlined, l.help_contact_chat,
          l.help_contact_chatHours, AppTheme.primaryGreen),
      _Contact(Icons.phone_outlined, l.help_contact_phone,
          '+44 20 1234 5678', AppTheme.goldAccent),
    ];

    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      appBar: AppBar(title: Text(l.help_appBarTitle)),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.help_heroTitle,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(
                        l.help_heroBody,
                        style: const TextStyle(
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
          Text(l.help_faqHeader,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark)),
          const SizedBox(height: 12),
          ...List.generate(faqs.length, (i) {
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
                              faqs[i].q,
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
                          faqs[i].a,
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
          Text(l.help_contactHeader,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark)),
          const SizedBox(height: 12),
          ...contacts.map((c) => GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: c.detail));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l.help_copiedSnackbar(c.label)),
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
