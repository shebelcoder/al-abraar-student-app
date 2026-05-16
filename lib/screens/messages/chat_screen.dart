import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String initials;
  final int colorValue;

  const ChatScreen({
    super.key,
    required this.name,
    required this.initials,
    required this.colorValue,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  late List<_Message> _messages;

  Color get _avatarColor => Color(widget.colorValue);

  @override
  void initState() {
    super.initState();
    _messages = _mockMessages(widget.name);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _showOptions(BuildContext context, AppLocalizations l) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.notifications_off_outlined,
                  color: AppTheme.textDark),
              title: Text(l.chat_muteNotifications),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded,
                  color: AppTheme.textDark),
              title: Text(l.chat_clearChat),
              onTap: () {
                Navigator.pop(context);
                setState(() => _messages.clear());
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag_outlined,
                  color: AppTheme.errorRed),
              title: Text(l.chat_report,
                  style: const TextStyle(color: AppTheme.errorRed)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _send() {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Message(text: text, isMe: true, time: _nowTime()));
    });
    _inputCtrl.clear();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollToBottom());
  }

  String _nowTime() {
    final now = DateTime.now();
    final h = now.hour;
    final m = now.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final hour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '$hour:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _avatarColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.initials,
                  style: TextStyle(
                    color: _avatarColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppTheme.successGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l.chat_online,
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.successGreen,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () => _showOptions(context, l),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                const Expanded(
                    child: Divider(color: Color(0xFFE5E7EB))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l.chat_today,
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const Expanded(
                    child: Divider(color: Color(0xFFE5E7EB))),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final msg = _messages[i];
                final showAvatar = !msg.isMe &&
                    (i == 0 || _messages[i - 1].isMe);
                return _Bubble(
                  msg: msg,
                  avatarColor: _avatarColor,
                  initials: widget.initials,
                  showAvatar: showAvatar,
                );
              },
            ),
          ),
          Container(
            color: AppTheme.surfaceWhite,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file_rounded,
                        color: AppTheme.textSecondary),
                    onPressed: () => ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(
                      content: Text(l.chat_fileSharingComingSoon),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppTheme.primaryGreen,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    )),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.warmBackground,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                            color: const Color(0xFFE5E7EB)),
                      ),
                      child: TextField(
                        controller: _inputCtrl,
                        textCapitalization:
                            TextCapitalization.sentences,
                        minLines: 1,
                        maxLines: 4,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _send(),
                        decoration: InputDecoration(
                          hintText: l.chat_inputHint,
                          hintStyle: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          filled: false,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _send,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _Bubble extends StatelessWidget {
  final _Message msg;
  final Color avatarColor;
  final String initials;
  final bool showAvatar;

  const _Bubble({
    required this.msg,
    required this.avatarColor,
    required this.initials,
    required this.showAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: msg.isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!msg.isMe) ...[
            SizedBox(
              width: 28,
              child: showAvatar
                  ? Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color:
                            avatarColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: TextStyle(
                            color: avatarColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: msg.isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: msg.isMe
                        ? AppTheme.primaryGreen
                        : AppTheme.surfaceWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(
                          msg.isMe ? 16 : 4),
                      bottomRight: Radius.circular(
                          msg.isMe ? 4 : 16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  constraints: BoxConstraints(
                    maxWidth:
                        MediaQuery.of(context).size.width * 0.70,
                  ),
                  child: Text(
                    msg.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: msg.isMe
                          ? Colors.white
                          : AppTheme.textDark,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  msg.time,
                  style: const TextStyle(
                      fontSize: 10,
                      color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          if (msg.isMe) const SizedBox(width: 4),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

List<_Message> _mockMessages(String teacherName) {
  final first = teacherName.split(' ').first;
  return [
    _Message(
        text: 'السلام عليكم, how are you doing today?',
        isMe: false,
        time: '9:02 AM'),
    _Message(
        text: 'وعليكم السلام! Alhamdulillah, doing well. JazakAllah khair for asking.',
        isMe: true,
        time: '9:05 AM'),
    _Message(
        text: 'Excellent. I wanted to let you know that your Tajweed has improved significantly this week. Keep it up!',
        isMe: false,
        time: '9:06 AM'),
    _Message(
        text: 'Thank you so much, $first! I have been practicing every day.',
        isMe: true,
        time: '9:08 AM'),
    _Message(
        text: "MashaAllah! For tomorrow's class, please review Surah Al-Mulk verses 1–10. We will be reciting together.",
        isMe: false,
        time: '9:09 AM'),
    _Message(
        text: 'In shaa Allah, I will prepare those verses tonight.',
        isMe: true,
        time: '9:11 AM'),
    _Message(
        text: 'Wonderful. Also, remember that your next assessment is on Friday. Let me know if you have any questions.',
        isMe: false,
        time: '9:12 AM'),
    _Message(
        text: 'Will do, JazakAllah khair!',
        isMe: true,
        time: '9:13 AM'),
    _Message(
        text: 'Wa iyyakum. See you in class!',
        isMe: false,
        time: '5:12 PM'),
  ];
}

class _Message {
  final String text;
  final bool isMe;
  final String time;
  const _Message(
      {required this.text, required this.isMe, required this.time});
}
