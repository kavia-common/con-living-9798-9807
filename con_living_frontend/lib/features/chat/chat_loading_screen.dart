import 'dart:async';
import 'dart:math' as math;

import 'package:con_living_frontend/features/chat/chat_empty_state_screen.dart';
import 'package:con_living_frontend/main.dart';
import 'package:flutter/material.dart';

/// Chat loading/transition screen.
///
/// Shows a short animation and then automatically navigates to the Chat page.
/// This is used as an intermediate step when entering chat from the Dashboard.
///
/// NOTE: This is implemented as a separate screen to keep the original
/// `ChatEmptyStateScreen` pixel-perfect and reusable as a standalone landing UI.
class ChatLoadingScreen extends StatefulWidget {
  /// Optional override of the delay before transitioning to the Chat page.
  final Duration delay;

  const ChatLoadingScreen({
    super.key,
    this.delay = const Duration(seconds: 3),
  });

  @override
  State<ChatLoadingScreen> createState() => _ChatLoadingScreenState();
}

class _ChatLoadingScreenState extends State<ChatLoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _navTimer;

  // Primitive-only state used after async gaps.
  bool _shouldNavigate = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // Timer callback must not use context directly.
    _navTimer = Timer(widget.delay, () {
      // Only update primitive state after async gap.
      _shouldNavigate = true;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Navigation happens in build() based on primitive flag to avoid using
    // BuildContext across async gaps.
    if (_shouldNavigate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // No async/await here; immediate navigation on next frame.
        Navigator.of(context).pushReplacementNamed(MyApp.chatPageRoute);
      });
    }

    return Stack(
      children: [
        // Reuse the existing pixel-perfect empty state UI as the base.
        ChatEmptyStateScreen(
          // For the loading step, a tap back should cancel the flow and return.
          onBack: () => Navigator.maybePop(context),
          onMenu: () {},
        ),

        // Loading overlay (non-interactive).
        IgnorePointer(
          child: Center(
            child: RepaintBoundary(
              child: _LoadingOverlay(controller: _controller),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  final AnimationController controller;

  const _LoadingOverlay({required this.controller});

  static const Color _ringColor = Color(0xFF53D6FF);
  static const Color _ringColor2 = Color(0xFF2F7BFF);

  @override
  Widget build(BuildContext context) {
    // Keeps the animation subtle and "production" (no janky layout shifts).
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final t = controller.value;

            // A gentle "breathing" scale and opacity.
            final breathe = 0.92 + (math.sin(t * math.pi * 2) + 1) * 0.04;
            final alpha = (190 + (math.sin(t * math.pi * 2) + 1) * 25)
                .clamp(0, 255)
                .toInt();

            return Transform.scale(
              scale: breathe,
              child: SizedBox(
                width: 90,
                height: 90,
                child: CustomPaint(
                  painter: _OrbitRingsPainter(
                    progress: t,
                    ringColor: _ringColor.withAlpha(alpha),
                    ringColor2: _ringColor2.withAlpha((alpha - 30).clamp(0, 255)),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        const Text(
          'Preparing chat…',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            height: 1.2,
            color: Color(0xFFD7DCE3),
          ),
        ),
      ],
    );
  }
}

class _OrbitRingsPainter extends CustomPainter {
  final double progress;
  final Color ringColor;
  final Color ringColor2;

  _OrbitRingsPainter({
    required this.progress,
    required this.ringColor,
    required this.ringColor2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    final baseStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;

    // Outer ring (faint full circle).
    final faint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = ringColor.withAlpha((ringColor.alpha * 0.28).toInt());

    canvas.drawCircle(center, size.width * 0.42, faint);

    // Inner ring (fainter).
    final faint2 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = ringColor2.withAlpha((ringColor2.alpha * 0.22).toInt());

    canvas.drawCircle(center, size.width * 0.29, faint2);

    // Arc segments orbiting.
    final outerRect = Rect.fromCircle(center: center, radius: size.width * 0.42);
    final innerRect = Rect.fromCircle(center: center, radius: size.width * 0.29);

    baseStroke.color = ringColor;
    canvas.drawArc(
      outerRect,
      (progress * math.pi * 2) - math.pi / 2,
      math.pi / 1.35,
      false,
      baseStroke,
    );

    baseStroke
      ..strokeWidth = 3
      ..color = ringColor2;
    canvas.drawArc(
      innerRect,
      -(progress * math.pi * 2) + math.pi / 3,
      math.pi / 1.55,
      false,
      baseStroke,
    );

    // A small "spark" dot on the outer orbit.
    final angle = (progress * math.pi * 2) - math.pi / 2;
    final dot = Offset(
      center.dx + math.cos(angle) * (size.width * 0.42),
      center.dy + math.sin(angle) * (size.width * 0.42),
    );

    final dotPaint = Paint()..color = ringColor.withAlpha(230);
    canvas.drawCircle(dot, 3.2, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _OrbitRingsPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.ringColor != ringColor ||
        oldDelegate.ringColor2 != ringColor2;
  }
}
