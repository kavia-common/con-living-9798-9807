import 'dart:math' as math;

import 'package:con_living_frontend/features/chat/chat_message.dart';
import 'package:con_living_frontend/model/rasa_webhook_response.dart';
import 'package:con_living_frontend/network/rasa_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Chat page screen backed by the existing Rasa REST integration.
///
/// - Sends user messages to Rasa via [RasaClient.sendMessage]
/// - Renders assistant responses as chat bubbles
/// - Provides basic loading and error handling
class ChatPageScreen extends StatefulWidget {
  const ChatPageScreen({super.key});

  @override
  State<ChatPageScreen> createState() => _ChatPageScreenState();
}

class _ChatPageScreenState extends State<ChatPageScreen> {
  // Design tokens (kept aligned with provided design specs).
  static const Color _bgCanvas = Color(0xFF0B0B0D);
  static const Color _textPrimary = Color(0xFFF2F2F4);
  static const Color _textSecondary = Color(0xFFA6A6AD);

  static const Color _assistantBubble = Color(0xFF2A2A2E);
  static const Color _composerBg = Color(0xFF1A1A1E);

  // Ocean theme-ish accent.
  static const Color _accentBlue = Color(0xFF2563EB);

  static const String _appBarTitle = 'Chat';

  late final RasaClient _rasaClient;

  late final TextEditingController _composerController;
  late final FocusNode _composerFocusNode;
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessage> _messages = <ChatMessage>[];

  bool _isSending = false;
  String? _errorBanner;

  // Primitive flags used to trigger widget operations in build()
  // (avoid using widget objects after async gaps).
  bool _shouldRequestFocus = false;
  bool _shouldScrollToBottom = false;

  @override
  void initState() {
    super.initState();
    _rasaClient = RasaClient();
    _composerController = TextEditingController();
    _composerFocusNode = FocusNode();

    // Optional: seed with a short assistant greeting.
    _messages.add(
      ChatMessage(
        id: _newId(),
        text: 'Hi! How can I help you today?',
        isUser: false,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _composerController.dispose();
    _composerFocusNode.dispose();
    _scrollController.dispose();
    _rasaClient.dispose();
    super.dispose();
  }

  String _newId() {
    // Simple deterministic-enough id for local UI rendering.
    return '${DateTime.now().microsecondsSinceEpoch}-${math.Random().nextInt(1 << 20)}';
  }

  void _queueScrollToBottom() {
    _shouldScrollToBottom = true;
    if (mounted) {
      setState(() {});
    }
  }

  void _queueRequestFocus() {
    _shouldRequestFocus = true;
    if (mounted) {
      setState(() {});
    }
  }

  // PUBLIC_INTERFACE
  void sendCurrentComposerMessage() {
    /// Sends the current text in the composer to Rasa.
    ///
    /// This method is synchronous in signature; it schedules async work but
    /// ensures no widget objects are used after the async gap (per project rule).
    final raw = _composerController.text;
    final text = raw.trim();
    if (text.isEmpty) return;

    // Immediate (sync) UI updates before async: add user message + clear input.
    setState(() {
      _errorBanner = null;
      _messages.add(
        ChatMessage(
          id: _newId(),
          text: text,
          isUser: true,
          createdAt: DateTime.now(),
        ),
      );
      _composerController.clear();
      _isSending = true;
    });

    _queueScrollToBottom();
    _queueRequestFocus();

    _sendToRasa(text);
  }

  Future<void> _sendToRasa(String userText) async {
    try {
      final List<RasaWebhookResponse> responses =
          await _rasaClient.sendMessage(message: userText);

      // After await: only compute primitives / plain data.
      final List<ChatMessage> assistantMessages = responses
          .map((r) => (r.text ?? '').trim())
          .where((t) => t.isNotEmpty)
          .map(
            (t) => ChatMessage(
              id: _newId(),
              text: t,
              isUser: false,
              createdAt: DateTime.now(),
            ),
          )
          .toList(growable: false);

      if (!mounted) return;

      setState(() {
        if (assistantMessages.isEmpty) {
          _messages.add(
            ChatMessage(
              id: _newId(),
              text: 'I didn’t get a text response back. Please try again.',
              isUser: false,
              createdAt: DateTime.now(),
            ),
          );
        } else {
          _messages.addAll(assistantMessages);
        }
        _isSending = false;
      });

      _queueScrollToBottom();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSending = false;
        _errorBanner = 'Couldn’t reach the assistant. Check RASA_BASE_URL.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Handle queued widget operations in build() (no context usage after await).
    if (_shouldRequestFocus) {
      _shouldRequestFocus = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _composerFocusNode.requestFocus();
        }
      });
    }
    if (_shouldScrollToBottom) {
      _shouldScrollToBottom = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (!_scrollController.hasClients) return;

        final position = _scrollController.position.maxScrollExtent;
        _scrollController.animateTo(
          position,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        );
      });
    }

    return Scaffold(
      backgroundColor: _bgCanvas,
      appBar: AppBar(
        backgroundColor: _bgCanvas,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 44,
        leading: Semantics(
          button: true,
          label: 'Back',
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.maybePop(context),
            icon: Icon(
              CupertinoIcons.chevron_left,
              size: 20,
              color: _textPrimary.withAlpha(240),
            ),
            tooltip: 'Back',
          ),
        ),
        title: Text(
          _appBarTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _textPrimary.withAlpha(245),
            height: 1.1,
          ),
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
        ),
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                if (_errorBanner != null) _ErrorBanner(text: _errorBanner!),
                Expanded(
                  child: _MessagesList(
                    messages: _messages,
                    controller: _scrollController,
                    isSending: _isSending,
                  ),
                ),
                _ComposerBar(
                  controller: _composerController,
                  focusNode: _composerFocusNode,
                  enabled: !_isSending,
                  onSend: sendCurrentComposerMessage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String text;

  const _ErrorBanner({required this.text});

  static const Color _bg = Color(0xFFEF4444);
  static const Color _fg = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _bg,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: Text(
        text,
        style: const TextStyle(
          color: _fg,
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
      ),
    );
  }
}

class _MessagesList extends StatelessWidget {
  final List<ChatMessage> messages;
  final ScrollController controller;
  final bool isSending;

  const _MessagesList({
    required this.messages,
    required this.controller,
    required this.isSending,
  });

  static const Color _assistantBubble = Color(0xFF2A2A2E);
  static const Color _textPrimary = Color(0xFFF2F2F4);
  static const Color _userBubble = Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      itemCount: messages.length + (isSending ? 1 : 0),
      itemBuilder: (context, index) {
        if (isSending && index == messages.length) {
          return const _TypingIndicator();
        }

        final m = messages[index];
        final bubbleColor = m.isUser ? _userBubble : _assistantBubble;
        final align = m.isUser ? Alignment.centerRight : Alignment.centerLeft;
        final radius = BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(m.isUser ? 16 : 4),
          bottomRight: Radius.circular(m.isUser ? 4 : 16),
        );

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Align(
            alignment: align,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: radius,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Text(
                    m.text,
                    style: TextStyle(
                      fontSize: 13.8,
                      fontWeight: FontWeight.w400,
                      height: 1.35,
                      color: _textPrimary.withAlpha(250),
                    ),
                    textHeightBehavior: const TextHeightBehavior(
                      applyHeightToFirstAscent: false,
                      applyHeightToLastDescent: false,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  static const Color _assistantBubble = Color(0xFF2A2A2E);
  static const Color _textPrimary = Color(0xFFF2F2F4);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _assistantBubble,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Text(
              'Thinking…',
              style: TextStyle(
                fontSize: 12.8,
                fontWeight: FontWeight.w500,
                height: 1.2,
                color: _textPrimary.withAlpha(210),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ComposerBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final VoidCallback onSend;

  const _ComposerBar({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.onSend,
  });

  static const Color _bgCanvas = Color(0xFF0B0B0D);
  static const Color _composerBg = Color(0xFF1A1A1E);
  static const Color _textPrimary = Color(0xFFF2F2F4);
  static const Color _textSecondary = Color(0xFFA6A6AD);

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      color: _bgCanvas,
      padding: EdgeInsets.fromLTRB(16, 10, 16, 10 + bottomInset),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: _composerBg,
          borderRadius: BorderRadius.circular(26),
        ),
        padding: const EdgeInsets.fromLTRB(16, 0, 12, 0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                enabled: enabled,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.2,
                  color: _textPrimary.withAlpha(245),
                  fontWeight: FontWeight.w400,
                ),
                decoration: const InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    height: 1.2,
                    color: _textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                cursorColor: _textPrimary.withAlpha(220),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) {
                  if (enabled) {
                    onSend();
                  }
                },
              ),
            ),
            const SizedBox(width: 10),
            Semantics(
              button: true,
              label: 'Send',
              child: IconButton(
                onPressed: enabled ? onSend : null,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                icon: Icon(
                  Icons.send_rounded,
                  size: 20,
                  color: _textPrimary.withAlpha(enabled ? 240 : 120),
                ),
                tooltip: 'Send',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
