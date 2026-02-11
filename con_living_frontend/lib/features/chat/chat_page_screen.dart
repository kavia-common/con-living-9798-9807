import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Pixel-accurate Chat Page screen recreation based on:
/// - `assets/chat_page_flutter_design_spec.md`
/// - Screenshot: `attachments/20260211_051606_Chat_page_.jpg`
///
/// The screen shows a single assistant message card and a bottom composer.
/// This file intentionally contains no networking/state management; it is UI-only.
class ChatPageScreen extends StatelessWidget {
  const ChatPageScreen({super.key});

  // Color tokens from spec.
  static const Color _bgCanvas = Color(0xFF0B0B0D);
  static const Color _cardBg = Color(0xFF2A2A2E);
  static const Color _composerBg = Color(0xFF1A1A1E);

  static const Color _textPrimary = Color(0xFFF2F2F4);
  static const Color _textSecondary = Color(0xFFA6A6AD);
  static const Color _iconMuted = Color(0xFFCFCFD6);

  static const Color _infoBannerBg = Color(0xFF6FD0E6);
  static const Color _infoBannerText = Color(0xFFFFFFFF);

  static const String _appBarTitle = 'Chat with Bob';

  // Banner text as specified (keep exact; allow natural wrapping).
  static const String _infoBannerTextValue =
      'The information about you is updated. Please note that the above will be used for the response.';

  // Message paragraph (approx. from screenshot/spec) — long descriptive content.
  static const String _assistantMessage =
      'Imagine yourself on a lush, secluded island nestled in the heart of the ocean, where the sea is a mesmerizing shade of turquoise and the sand is as soft as powdered sugar. Towering palm trees sway gently in the warm breeze, casting dappled shadows over the shore. Sunlight glints off the water as gentle waves lap the beach, inviting you to wade in and feel the cool, crystal-clear sea. In the distance, vibrant coral reefs teeming with colorful fish create a natural paradise for snorkeling and diving. This is the perfect place to unwind—where every moment feels calm, refreshing, and beautifully endless.';

  static const String _beachAssetPath = 'assets/images/chat_beach.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgCanvas,
      appBar: _ChatAppBar(
        title: _appBarTitle,
        onBack: () => Navigator.maybePop(context),
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: const [
                Expanded(child: _MessagesArea()),
                _ComposerBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;

  const _ChatAppBar({
    required this.title,
    required this.onBack,
  });

  static const Color _bgCanvas = Color(0xFF0B0B0D);
  static const Color _textPrimary = Color(0xFFF2F2F4);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // ~56, iOS-like with SafeArea top.

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: _bgCanvas,
      elevation: 0,
      centerTitle: true,
      // Keep leading width compact like iOS.
      leadingWidth: 44,
      leading: Semantics(
        button: true,
        label: 'Back',
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: onBack,
          icon: Icon(
            CupertinoIcons.chevron_left,
            size: 20,
            color: _textPrimary.withAlpha(240),
          ),
          tooltip: 'Back',
        ),
      ),
      title: Text(
        title,
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
    );
  }
}

class _MessagesArea extends StatelessWidget {
  const _MessagesArea();

  // Re-declare tokens locally (private widget).
  static const Color _bgCanvas = Color(0xFF0B0B0D);
  static const Color _cardBg = Color(0xFF2A2A2E);
  static const Color _textPrimary = Color(0xFFF2F2F4);
  static const Color _iconMuted = Color(0xFFCFCFD6);
  static const Color _infoBannerBg = Color(0xFF6FD0E6);
  static const Color _infoBannerText = Color(0xFFFFFFFF);

  static const String _infoBannerTextValue =
      'The information about you is updated. Please note that the above will be used for the response.';

  static const String _assistantMessage =
      'Imagine yourself on a lush, secluded island nestled in the heart of the ocean, where the sea is a mesmerizing shade of turquoise and the sand is as soft as powdered sugar. Towering palm trees sway gently in the warm breeze, casting dappled shadows over the shore. Sunlight glints off the water as gentle waves lap the beach, inviting you to wade in and feel the cool, crystal-clear sea. In the distance, vibrant coral reefs teeming with colorful fish create a natural paradise for snorkeling and diving. This is the perfect place to unwind—where every moment feels calm, refreshing, and beautifully endless.';

  static const String _beachAssetPath = 'assets/images/chat_beach.jpg';

  @override
  Widget build(BuildContext context) {
    // Spec: horizontal padding ~16, vertical padding ~8–12.
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      children: [
        Container(
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info banner.
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _infoBannerBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Text(
                  _infoBannerTextValue,
                  style: const TextStyle(
                    color: _infoBannerText,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                  textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                    applyHeightToLastDescent: false,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Image block.
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Semantics(
                  label: 'Tropical beach island',
                  image: true,
                  child: Image.asset(
                    _beachAssetPath,
                    height: 152,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    // If asset isn't present yet, show a deterministic fallback gradient
                    // while keeping compilation working.
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 152,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF2C7DA0),
                              Color(0xFF014F86),
                              Color(0xFF012A4A),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.photo_outlined,
                            size: 40,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Message paragraph.
              Text(
                _assistantMessage,
                style: TextStyle(
                  fontSize: 13.8,
                  fontWeight: FontWeight.w400,
                  height: 1.42,
                  color: _textPrimary.withAlpha(245),
                ),
                textHeightBehavior: const TextHeightBehavior(
                  applyHeightToFirstAscent: false,
                  applyHeightToLastDescent: false,
                ),
              ),
              const SizedBox(height: 12),

              // Action row.
              Row(
                children: const [
                  _ActionIcon(icon: Icons.copy_outlined, semanticLabel: 'Copy'),
                  SizedBox(width: 16),
                  _ActionIcon(
                    icon: Icons.thumb_down_alt_outlined,
                    semanticLabel: 'Thumbs down',
                  ),
                  SizedBox(width: 16),
                  _ActionIcon(
                    icon: Icons.thumb_up_alt_outlined,
                    semanticLabel: 'Thumbs up',
                  ),
                  SizedBox(width: 16),
                  _ActionIcon(
                    icon: Icons.ios_share_outlined,
                    semanticLabel: 'Share',
                  ),
                ],
              ),
            ],
          ),
        ),

        // Keep the remaining area dark like the screenshot.
        const SizedBox(height: 12),
        Container(height: 1, color: _bgCanvas),
      ],
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String semanticLabel;

  const _ActionIcon({
    required this.icon,
    required this.semanticLabel,
  });

  static const Color _iconMuted = Color(0xFFCFCFD6);

  @override
  Widget build(BuildContext context) {
    // Pixel feel: icons appear small, with subtle hit area.
    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkResponse(
        radius: 22,
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: Icon(
            icon,
            size: 18,
            color: _iconMuted.withAlpha(235),
          ),
        ),
      ),
    );
  }
}

class _ComposerBar extends StatelessWidget {
  const _ComposerBar();

  static const Color _bgCanvas = Color(0xFF0B0B0D);
  static const Color _composerBg = Color(0xFF1A1A1E);
  static const Color _textPrimary = Color(0xFFF2F2F4);
  static const Color _textSecondary = Color(0xFFA6A6AD);

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    // Spec: horizontal padding ~16, vertical ~10–12; include SafeArea bottom.
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
            const Expanded(
              child: _ComposerTextField(),
            ),
            const SizedBox(width: 10),
            Semantics(
              button: true,
              label: 'Microphone',
              child: IconButton(
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                icon: Icon(
                  Icons.mic_none_outlined,
                  size: 20,
                  color: _textPrimary.withAlpha(240),
                ),
                tooltip: 'Microphone',
              ),
            ),
            const SizedBox(width: 2),
            Semantics(
              button: true,
              label: 'Send',
              child: IconButton(
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                icon: Icon(
                  Icons.send_rounded,
                  size: 20,
                  color: _textPrimary.withAlpha(240),
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

class _ComposerTextField extends StatefulWidget {
  const _ComposerTextField();

  @override
  State<_ComposerTextField> createState() => _ComposerTextFieldState();
}

class _ComposerTextFieldState extends State<_ComposerTextField> {
  late final TextEditingController _controller;

  static const Color _textPrimary = Color(0xFFF2F2F4);
  static const Color _textSecondary = Color(0xFFA6A6AD);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // IMPORTANT: no async usage here; controller lifetime is local & safe.
    return TextField(
      controller: _controller,
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
        // UI-only: no send behavior.
      },
    );
  }
}
