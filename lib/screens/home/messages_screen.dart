import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/student_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/guest_lock_screen.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _colorPalette = [
  Color(0xFF166534),
  Color(0xFF8B5CF6),
  Color(0xFF0EA5E9),
  Color(0xFFF97316),
  Color(0xFFF59E0B),
  Color(0xFF6366F1),
  Color(0xFF10B981),
];

Color _colorFromName(String name) =>
    _colorPalette[name.hashCode.abs() % _colorPalette.length];

String _initialsFrom(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.length >= 2) {
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
  return name.substring(0, min(2, name.length)).toUpperCase();
}

String _timeLabel(String? isoStr) {
  if (isoStr == null || isoStr.isEmpty) return '';
  final dt = DateTime.tryParse(isoStr)?.toLocal();
  if (dt == null) return '';
  final now = DateTime.now();
  final diff = now.difference(dt);
  if (diff.inDays == 0) {
    final h = dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final hour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '$hour:$m $period';
  }
  if (diff.inDays == 1) return 'Yesterday';
  return '${diff.inDays}d ago';
}

// ---------------------------------------------------------------------------
// Display model
// ---------------------------------------------------------------------------

class _Conversation {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int unread;
  final bool isGroup;
  final String initials;
  final Color color;

  const _Conversation({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unread,
    required this.isGroup,
    required this.initials,
    required this.color,
  });
}

_Conversation _parseConversation(Map<String, dynamic> j) {
  final id = j['id']?.toString() ??
      j['conversationId']?.toString() ??
      '';
  final name = j['name']?.toString() ??
      j['title']?.toString() ??
      j['teacherName']?.toString() ??
      'Unknown';
  final lastMessage = j['lastMessage']?.toString() ??
      j['preview']?.toString() ??
      j['latestMessage']?.toString() ??
      j['message']?.toString() ??
      '';
  final lastAt = j['lastMessageAt']?.toString() ??
      j['updatedAt']?.toString() ??
      j['createdAt']?.toString();
  final unread = (j['unreadCount'] as int?) ??
      (j['unread'] as int?) ??
      0;
  final isGroup = j['isGroup'] as bool? ??
      (j['type']?.toString() == 'group');

  return _Conversation(
    id: id,
    name: name,
    lastMessage: lastMessage,
    time: _timeLabel(lastAt),
    unread: unread,
    isGroup: isGroup,
    initials: _initialsFrom(name),
    color: _colorFromName(name),
  );
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<_Conversation> _filtered(List<_Conversation> all) => all
      .where((c) =>
          c.name.toLowerCase().contains(_query.toLowerCase()) ||
          c.lastMessage.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  void _openChat(BuildContext context, _Conversation conv) {
    context.push(
      '/messages/chat'
      '?name=${Uri.encodeComponent(conv.name)}'
      '&initials=${conv.initials}'
      '&color=${conv.color.toARGB32()}',
    );
  }

  void _showNewMessage(
      BuildContext context, AppLocalizations l, List<_Conversation> all) {
    String? selected;
    final msgCtrl = TextEditingController();
    final teachers = all.where((c) => !c.isGroup).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.fromLTRB(
              24, 20, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(l.messages_newMessageTitle,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                initialValue: selected,
                decoration:
                    InputDecoration(labelText: l.messages_sendToLabel),
                items: teachers
                    .map((c) => DropdownMenuItem(
                        value: c.name, child: Text(c.name)))
                    .toList(),
                onChanged: (v) => setSheet(() => selected = v),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: msgCtrl,
                maxLines: 3,
                decoration:
                    InputDecoration(labelText: l.messages_messageLabel),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: selected == null
                      ? null
                      : () {
                          Navigator.pop(ctx);
                          final conv = teachers
                              .firstWhere((c) => c.name == selected);
                          _openChat(context, conv);
                        },
                  child: Text(l.messages_send),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    if (ref.watch(isGuestProvider)) {
      return Scaffold(
        backgroundColor: AppTheme.warmBackground,
        appBar: AppBar(
          title: Text(l.messages_appBarTitle),
          automaticallyImplyLeading: false,
        ),
        body: GuestLockScreen(
          featureName: l.messages_guestFeatureName,
          description: l.messages_guestDesc,
          icon: Icons.chat_bubble_rounded,
        ),
      );
    }

    final convsAsync = ref.watch(conversationsProvider);

    return convsAsync.when(
      loading: () => Scaffold(
        backgroundColor: AppTheme.warmBackground,
        appBar: AppBar(
          title: Text(l.messages_appBarTitle),
          automaticallyImplyLeading: false,
        ),
        body: const Center(
          child:
              CircularProgressIndicator(color: AppTheme.primaryGreen),
        ),
      ),
      error: (_, __) =>
          _buildScaffold(context, l, []),
      data: (raw) {
        final all =
            raw.map(_parseConversation).toList();
        return _buildScaffold(context, l, all);
      },
    );
  }

  Widget _buildScaffold(
      BuildContext context, AppLocalizations l, List<_Conversation> all) {
    final filtered = _filtered(all);

    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      appBar: AppBar(
        title: Text(l.messages_appBarTitle),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () => _showNewMessage(context, l, all),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: AppTheme.surfaceWhite,
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 10),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: l.messages_searchHint,
                hintStyle:
                    const TextStyle(color: AppTheme.textSecondary),
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppTheme.textSecondary),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded,
                            color: AppTheme.textSecondary),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10),
                fillColor: AppTheme.warmBackground,
                filled: true,
              ),
            ),
          ),
          // Conversation list
          Expanded(
            child: filtered.isEmpty
                ? _EmptyMessages(l: l)
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      indent: 72,
                      color: Color(0xFFF3F4F6),
                    ),
                    itemBuilder: (ctx, i) => _ConversationTile(
                      conv: filtered[i],
                      onTap: () => _openChat(context, filtered[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets (unchanged UI)
// ---------------------------------------------------------------------------

class _ConversationTile extends StatelessWidget {
  final _Conversation conv;
  final VoidCallback onTap;
  const _ConversationTile({required this.conv, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surfaceWhite,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: conv.color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  conv.initials,
                  style: TextStyle(
                    color: conv.color,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            if (conv.isGroup)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.group,
                      size: 10, color: Colors.white),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                conv.name,
                style: TextStyle(
                  fontWeight: conv.unread > 0
                      ? FontWeight.w700
                      : FontWeight.w600,
                  fontSize: 15,
                  color: AppTheme.textDark,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              conv.time,
              style: TextStyle(
                fontSize: 12,
                color: conv.unread > 0
                    ? AppTheme.primaryGreen
                    : AppTheme.textSecondary,
                fontWeight: conv.unread > 0
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: Text(
                conv.lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: conv.unread > 0
                      ? AppTheme.textDark
                      : AppTheme.textSecondary,
                  fontWeight: conv.unread > 0
                      ? FontWeight.w500
                      : FontWeight.w400,
                ),
              ),
            ),
            if (conv.unread > 0)
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryGreen,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${conv.unread}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class _EmptyMessages extends StatelessWidget {
  final AppLocalizations l;
  const _EmptyMessages({required this.l});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.chat_bubble_outline_rounded,
                size: 40, color: AppTheme.primaryGreen),
          ),
          const SizedBox(height: 16),
          Text(
            l.messages_emptyTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l.messages_emptyBody,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
