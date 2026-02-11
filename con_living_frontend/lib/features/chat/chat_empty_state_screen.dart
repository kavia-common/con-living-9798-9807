import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Chat empty/landing screen based on `Chat_1.jpg`.
///
/// Visual spec authority: `assets/chat_screen_design_spec.md`.
class ChatEmptyStateScreen extends StatelessWidget {
  /// Title displayed in the top bar (centered).
  final String title;

  /// Optional callback for the back button. If null, defaults to
  /// `Navigator.maybePop`.
  final VoidCallback? onBack;

  /// Optional callback for the menu button.
  final VoidCallback? onMenu;

  /// Headline prompt shown under the hero illustration.
  final String headline;

  /// Supporting line shown under the headline.
  final String supporting;

  const ChatEmptyStateScreen({
    super.key,
    this.title = 'Travelling to Bali',
    this.onBack,
    this.onMenu,
    this.headline = 'Describe and show me the perfect vacation spot in',
    this.supporting = 'Ireland in the ocean',
  });

  static const Color _bgTop = Color(0xFF0B0C0E);
  static const Color _bgMid = Color(0xFF0A0B0D);
  static const Color _bgBottom = Color(0xFF070809);

  static const Color _textPrimary = Color(0xFFF1F4F8);
  static const Color _textSecondary = Color(0xFF9AA3AE);
  static const Color _textTertiary = Color(0xFFD7DCE3);

  static const Color _iconPrimary = Color(0xFFE9EDF3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const _ChatBackgroundGradient(),
          // Very subtle speck noise, as in the mock. Kept lightweight and
          // deterministic.
          const IgnorePointer(
            child: RepaintBoundary(
              child: _NoiseOverlay(opacity: 0.06),
            ),
          ),
          SafeArea(
            top: true,
            bottom: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  ChatTopBar(
                    title: title,
                    onBack: onBack ?? () => Navigator.maybePop(context),
                    onMenu: onMenu,
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final size = MediaQuery.sizeOf(context);

                        // Responsive rules from spec:
                        // - Height < 700 => shrink hero a bit and tighten spacing.
                        final isShort = size.height < 700;
                        final heroHeightFactor = isShort ? 0.35 : 0.42;
                        final heroWidthFactor = 0.74;

                        final heroW = size.width * heroWidthFactor;
                        final heroH = size.height * heroHeightFactor;

                        final textTopGap = isShort ? 14.0 : 18.0;

                        // Text block max width guidance: 280–320 typical, 360 on wide.
                        final maxTextWidth =
                            size.width > 430 ? 360.0 : 320.0;

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: heroW,
                              height: math.min(heroH, constraints.maxHeight * 0.55),
                              child: const _HeroRobotIllustration(),
                            ),
                            SizedBox(height: textTopGap),
                            ChatEmptyStateText(
                              headline: headline,
                              supporting: supporting,
                              maxWidth: maxTextWidth,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  // Breathing room above the home indicator (in addition to SafeArea).
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Top bar matching iOS compact nav bar: back chevron (left), centered title,
/// and menu icon (right).
class ChatTopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final VoidCallback? onMenu;

  const ChatTopBar({
    super.key,
    required this.title,
    required this.onBack,
    this.onMenu,
  });

  static const Color _iconPrimary = Color(0xFFE9EDF3);
  static const Color _titleColor = Color(0xFFD7DCE3);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _titleColor.withAlpha(204), // ~80%
                height: 1.1,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: _TopBarIconButton(
              icon: CupertinoIcons.chevron_left,
              onTap: onBack,
              semanticLabel: 'Back',
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _TopBarIconButton(
              icon: CupertinoIcons.ellipsis,
              onTap: onMenu,
              semanticLabel: 'Menu',
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String semanticLabel;

  const _TopBarIconButton({
    required this.icon,
    required this.onTap,
    required this.semanticLabel,
  });

  static const Color _iconPrimary = Color(0xFFE9EDF3);

  @override
  Widget build(BuildContext context) {
    // Ensure 44x44 hit target, no extra padding (pixel match).
    return SizedBox(
      width: 44,
      height: 44,
      child: Semantics(
        button: true,
        label: semanticLabel,
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: onTap,
          icon: Icon(
            icon,
            size: 20,
            color: _iconPrimary.withAlpha(230), // ~90%
          ),
          tooltip: semanticLabel,
        ),
      ),
    );
  }
}

/// Bottom centered text block (headline + supporting).
class ChatEmptyStateText extends StatelessWidget {
  final String headline;
  final String supporting;
  final double maxWidth;

  const ChatEmptyStateText({
    super.key,
    required this.headline,
    required this.supporting,
    this.maxWidth = 320,
  });

  static const Color _textPrimary = Color(0xFFF1F4F8);
  static const Color _textSecondary = Color(0xFF9AA3AE);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Column(
        children: [
          Text(
            headline,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              height: 1.2,
              color: _textPrimary,
            ),
            textHeightBehavior: const TextHeightBehavior(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: false,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            supporting,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1.25,
              color: _textSecondary,
            ),
            textHeightBehavior: const TextHeightBehavior(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBackgroundGradient extends StatelessWidget {
  const _ChatBackgroundGradient();

  static const Color _bgTop = Color(0xFF0B0C0E);
  static const Color _bgMid = Color(0xFF0A0B0D);
  static const Color _bgBottom = Color(0xFF070809);

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_bgTop, _bgMid, _bgBottom],
        ),
      ),
      child: SizedBox.expand(),
    );
  }
}

class _NoiseOverlay extends StatelessWidget {
  final double opacity;

  const _NoiseOverlay({required this.opacity});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _NoisePainter(opacity: opacity),
      size: Size.infinite,
    );
  }
}

class _NoisePainter extends CustomPainter {
  final double opacity;

  _NoisePainter({required this.opacity});

  // A fixed seed keeps the pattern stable across frames.
  static const int _seed = 1337;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final rnd = math.Random(_seed);

    // A small number of dots to avoid performance issues.
    // Dots are subtle and scattered; sizes are tiny.
    final dotPaint = Paint()..style = PaintingStyle.fill;

    final dotCount = (size.width * size.height / 12000).clamp(70, 160).toInt();

    for (var i = 0; i < dotCount; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;

      // Vary alpha slightly; keep very subtle overall.
      final a = (opacity * 255).clamp(0, 255).toInt();
      final jitter = rnd.nextInt(18) - 9; // +/- 9
      final alpha = (a + jitter).clamp(0, 255);

      dotPaint.color = Colors.white.withAlpha(alpha);

      final r = (rnd.nextDouble() * 0.9) + 0.35; // 0.35..1.25
      canvas.drawCircle(Offset(x, y), r, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _NoisePainter oldDelegate) {
    return oldDelegate.opacity != opacity;
  }
}

class _HeroRobotIllustration extends StatelessWidget {
  const _HeroRobotIllustration();

  static const String _assetPath = 'assets/images/chat_robot.png';

  @override
  Widget build(BuildContext context) {
    // Prefer a real exported asset for pixel match. If not present, fall back
    // to a clean placeholder that still compiles.
    return Semantics(
      label: 'Friendly robot assistant illustration',
      image: true,
      child: Image.asset(
        _assetPath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback: a compact, friendly "robot" glyph in cyan/blue accent.
          return const _RobotPlaceholder();
        },
      ),
    );
  }
}

class _RobotPlaceholder extends StatelessWidget {
  const _RobotPlaceholder();

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF0B0C0E),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: const Color(0xFF2F7BFF).withAlpha(120),
            width: 2,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 22),
          child: Icon(
            Icons.smart_toy_outlined,
            size: 168,
            color: Color(0xFF53D6FF),
          ),
        ),
      ),
    );
  }
}
