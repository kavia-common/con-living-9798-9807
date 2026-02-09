import 'package:flutter/material.dart';

/// Dashboard screen refined to match the provided screenshot (dark canvas,
/// compact header, purple hero promo, 4 quick tiles, poster carousel, and
/// 4-icon bottom navigation).
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Canvas/surface tokens tuned to the latest screenshot (slightly lifted from pure black).
  static const Color _bgCanvas = Color(0xFF0B0B0F);
  static const Color _surface1 = Color(0xFF12121A);
  static const Color _divider = Color(0xFF1D1D24);

  static const Color _textPrimary = Color(0xFFFFFFFF);
  static const Color _textMuted = Color(0xFFB8B8C2);
  static const Color _navInactive = Color(0xFF8A8A95);

  // Accent tokens per design notes/screenshot.
  static const Color _accentPurple = Color(0xFF8F3DFF);
  static const Color _accentPurple2 = Color(0xFFA56BFF);
  static const Color _accentPurpleGlow = Color(0xFFC79BFF);

  int _selectedNavIndex = 0; // Screenshot shows Home selected.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgCanvas,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            // Slightly tighter top padding to match screenshot.
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _HeaderRow(),
                SizedBox(height: 14),
                _HeroPromoCard(),
                SizedBox(height: 16),
                _SectionTitle(title: 'Featured'),
                SizedBox(height: 12),
                _FeaturedTilesRow(),
                SizedBox(height: 18),
                _SectionTitle(title: 'Curated for you'),
                SizedBox(height: 12),
                _CuratedHorizontalList(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedNavIndex,
        onSelected: (idx) => setState(() => _selectedNavIndex = idx),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _HeaderTextBlock()),
        SizedBox(width: 12),
        Row(
          children: [
            _CircleOutlineIconButton(icon: Icons.search_rounded),
            SizedBox(width: 10),
            _CircleOutlineIconButton(icon: Icons.notifications_none_rounded),
          ],
        ),
      ],
    );
  }
}

class _HeaderTextBlock extends StatelessWidget {
  const _HeaderTextBlock();

  static const Color _textPrimary = Color(0xFFFFFFFF);
  static const Color _textMuted = Color(0xFFB8B8C2);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Welcome to',
          style: TextStyle(
            color: _textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.15,
          ),
        ),
        SizedBox(height: 2),
        Text(
          'Xfinity Mobile',
          style: TextStyle(
            color: _textPrimary,
            fontSize: 19,
            fontWeight: FontWeight.w700,
            height: 1.1,
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Your bill is due soon.',
          style: TextStyle(
            color: _textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.15,
          ),
        ),
      ],
    );
  }
}

class _CircleOutlineIconButton extends StatelessWidget {
  const _CircleOutlineIconButton({required this.icon});

  final IconData icon;

  static const Color _textPrimary = Color(0xFFFFFFFF);
  static const Color _divider = Color(0xFF1D1D24);

  @override
  Widget build(BuildContext context) {
    // Slightly larger tap target while keeping the visible circle compact.
    return SizedBox(
      width: 40,
      height: 40,
      child: Center(
        child: SizedBox(
          width: 34,
          height: 34,
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(
              side: BorderSide(color: _divider, width: 1),
            ),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                // Static UI recreation: no action wired yet.
              },
              child: Center(
                child: Icon(
                  icon,
                  size: 20,
                  color: _textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroPromoCard extends StatelessWidget {
  const _HeroPromoCard();

  static const Color _textPrimary = Color(0xFFFFFFFF);
  static const Color _textMuted = Color(0xFFB8B8C2);

  static const Color _accentPurple = Color(0xFF8F3DFF);
  static const Color _accentPurple2 = Color(0xFFA56BFF);
  static const Color _accentPurpleGlow = Color(0xFFC79BFF);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 168,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment(-1.0, 0.9),
          end: Alignment(1.0, -0.6),
          colors: [
            Color(0xFF2A143C),
            Color(0xFF5B2A88),
            _accentPurpleGlow,
          ],
        ),
        border: Border.all(color: const Color(0xFF1D1D24), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _HeroXGlowPainter(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Xfinity Stream',
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'ThermoX',
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'New episode • Jun 2024',
                    style: TextStyle(
                      color: _textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 38,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accentPurple,
                        foregroundColor: _textPrimary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        // Static UI recreation: no navigation yet.
                      },
                      child: const Text(
                        'Watch now',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Slight sheen on the top edge (very subtle in screenshot).
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Container(
                height: 26,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withAlpha(24),
                      Colors.white.withAlpha(0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroXGlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..color = const Color(0xFFFFFFFF).withAlpha(36)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final core = Paint()
      ..color = const Color(0xFFFFFFFF).withAlpha(70)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final highlight = Paint()
      ..color = const Color(0xFFA56BFF).withAlpha(120)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Large stylized "X" on right side, matching screenshot positioning.
    final center = Offset(size.width * 0.84, size.height * 0.53);
    final span = size.height * 0.70;

    void drawX(Paint p) {
      canvas.drawLine(
        Offset(center.dx - span * 0.46, center.dy - span * 0.46),
        Offset(center.dx + span * 0.46, center.dy + span * 0.46),
        p,
      );
      canvas.drawLine(
        Offset(center.dx - span * 0.46, center.dy + span * 0.46),
        Offset(center.dx + span * 0.46, center.dy - span * 0.46),
        p,
      );
    }

    drawX(glow);
    drawX(core);

    // Inner highlight stroke.
    canvas.save();
    canvas.translate(2, -2);
    drawX(highlight);
    canvas.restore();

    // Small sparkles around the X.
    final sparkle = Paint()
      ..color = const Color(0xFFFFFFFF).withAlpha(140)
      ..style = PaintingStyle.fill;

    for (final p in <Offset>[
      Offset(size.width * 0.70, size.height * 0.30),
      Offset(size.width * 0.76, size.height * 0.22),
      Offset(size.width * 0.90, size.height * 0.26),
      Offset(size.width * 0.64, size.height * 0.58),
      Offset(size.width * 0.74, size.height * 0.74),
    ]) {
      canvas.drawCircle(p, 1.7, sparkle);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  static const Color _textPrimary = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: _textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
    );
  }
}

class _FeaturedTilesRow extends StatelessWidget {
  const _FeaturedTilesRow();

  @override
  Widget build(BuildContext context) {
    // Tiles in screenshot are compact squares.
    return Row(
      children: const [
        Expanded(child: _FeaturedTile(icon: Icons.star_rounded, label: 'Rewards')),
        SizedBox(width: 12),
        Expanded(
          child: _FeaturedTile(icon: Icons.confirmation_number_rounded, label: 'Tickets'),
        ),
        SizedBox(width: 12),
        Expanded(child: _FeaturedTile(icon: Icons.card_giftcard_rounded, label: 'Gifts')),
        SizedBox(width: 12),
        Expanded(child: _FeaturedTile(icon: Icons.local_offer_rounded, label: 'Deals')),
      ],
    );
  }
}

class _FeaturedTile extends StatelessWidget {
  const _FeaturedTile({required this.icon, required this.label});

  final IconData icon;
  final String label;

  static const Color _tileBg = Color(0xFF12121A);
  static const Color _divider = Color(0xFF1D1D24);
  static const Color _textMuted = Color(0xFFB8B8C2);
  static const Color _accentPurple2 = Color(0xFFA56BFF);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            // Static UI recreation: no action wired yet.
          },
          child: Ink(
            decoration: BoxDecoration(
              color: _tileBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _divider, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 22, color: _accentPurple2),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _textMuted,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w400,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CuratedHorizontalList extends StatelessWidget {
  const _CuratedHorizontalList();

  // Screenshot shows tall poster cards (not short landscape thumbnails).
  static const double _cardWidth = 132;
  static const double _cardHeight = 184;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _cardHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: const [
          _PosterCard(
            width: _cardWidth,
            height: _cardHeight,
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [Color(0xFF0F4C3A), Color(0xFF0B0B0F)],
            ),
          ),
          SizedBox(width: 12),
          _PosterCard(
            width: _cardWidth,
            height: _cardHeight,
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [Color(0xFF4A2B2B), Color(0xFF0B0B0F)],
            ),
          ),
          SizedBox(width: 12),
          _PosterCard(
            width: _cardWidth,
            height: _cardHeight,
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [Color(0xFF2A2A5A), Color(0xFF0B0B0F)],
            ),
            showOverlayX: true,
          ),
        ],
      ),
    );
  }
}

class _PosterCard extends StatelessWidget {
  const _PosterCard({
    required this.width,
    required this.height,
    required this.gradient,
    this.showOverlayX = false,
  });

  final double width;
  final double height;
  final Gradient gradient;
  final bool showOverlayX;

  static const Color _divider = Color(0xFF1D1D24);
  static const Color _accentPurple = Color(0xFF8F3DFF);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: gradient,
              border: Border.all(color: _divider, width: 1),
            ),
          ),
          if (showOverlayX)
            Positioned(
              right: 10,
              top: (height / 2) - 20,
              child: Material(
                color: _accentPurple,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    // Static UI recreation: no action wired yet.
                  },
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Center(
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const Color _bg = Color(0xFF0F0F14);
  static const Color _inactive = Color(0xFF8A8A95);
  static const Color _active = Color(0xFFFFFFFF);
  static const Color _divider = Color(0xFF1D1D24);

  @override
  Widget build(BuildContext context) {
    // Screenshot shows 4 icons.
    return Container(
      decoration: const BoxDecoration(
        color: _bg,
        border: Border(top: BorderSide(color: _divider, width: 1)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
      child: SizedBox(
        height: 72,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavIcon(
              icon: Icons.home_rounded,
              selected: selectedIndex == 0,
              onTap: () => onSelected(0),
            ),
            _NavIcon(
              icon: Icons.play_circle_outline_rounded,
              selected: selectedIndex == 1,
              onTap: () => onSelected(1),
            ),
            _NavIcon(
              icon: Icons.grid_view_rounded,
              selected: selectedIndex == 2,
              onTap: () => onSelected(2),
            ),
            _NavIcon(
              icon: Icons.person_outline_rounded,
              selected: selectedIndex == 3,
              onTap: () => onSelected(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  static const Color _inactive = Color(0xFF8A8A95);
  static const Color _active = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    final color = selected ? _active : _inactive;

    return SizedBox(
      width: 64,
      height: 56,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap,
          child: Center(
            child: Icon(icon, color: color, size: 24),
          ),
        ),
      ),
    );
  }
}

