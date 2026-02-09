import 'package:flutter/material.dart';

/// Dashboard screen that recreates the provided design notes (dark UI with hero
/// promo card, featured tiles, curated carousel, and bottom navigation).
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const Color _bgCanvas = Color(0xFF000000);
  static const Color _textPrimary = Color(0xFFFFFFFF);
  static const Color _textSecondary = Color(0xFFB9B9C2);
  static const Color _divider = Color(0xFF24242A);
  static const Color _tileBg = Color(0xFF0F0F14);

  // Bottom-nav tokens per design notes.
  static const Color _navInactive = Color(0xFF8C8C96);
  static const Color _navActive = Color(0xFFFFFFFF);

  // Accent tokens per design notes.
  static const Color _accentPurple1 = Color(0xFF7A2CFF);
  static const Color _accentPurple2 = Color(0xFFB24DFF);
  static const Color _accentMagenta = Color(0xFFFF4FD8);

  int _selectedNavIndex = 2; // "center item highlighted" per notes.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgCanvas,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _HeaderRow(),
                SizedBox(height: 12),
                _HeroPromoCard(),
                SizedBox(height: 16),
                _SectionTitle(title: 'Featured'),
                SizedBox(height: 12),
                _FeaturedTilesRow(),
                SizedBox(height: 16),
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

  static const Color _textPrimary = Color(0xFFFFFFFF);
  static const Color _textSecondary = Color(0xFFB9B9C2);
  static const Color _divider = Color(0xFF24242A);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: _HeaderTextBlock(),
        ),
        const SizedBox(width: 12),
        Row(
          children: const [
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
  static const Color _textSecondary = Color(0xFFB9B9C2);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Welcome to',
          style: TextStyle(
            color: _textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.2,
          ),
        ),
        SizedBox(height: 2),
        Text(
          'Xfinity Mobile.',
          style: TextStyle(
            color: _textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            height: 1.15,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'What do you want to do today?',
          style: TextStyle(
            color: _textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            height: 1.2,
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
  static const Color _divider = Color(0xFF24242A);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
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
              size: 19,
              color: _textPrimary,
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
  static const Color _ctaBg = Color(0xFFFFFFFF);
  static const Color _ctaText = Color(0xFF111118);

  static const Color _accentPurple1 = Color(0xFF7A2CFF);
  static const Color _accentPurple2 = Color(0xFFB24DFF);
  static const Color _accentMagenta = Color(0xFFFF4FD8);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 162,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment(-1.0, 0.6),
          end: Alignment(1.0, -0.6),
          colors: [_accentPurple1, _accentPurple2, _accentMagenta],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Decorative "X/star" approximation to avoid depending on missing assets.
            Positioned.fill(
              child: CustomPaint(
                painter: _HeroStarPainter(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  const Text(
                    'Xfinity Stream + ThermoX',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Available November 2024',
                    style: TextStyle(
                      color: _textPrimary.withAlpha(220),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 34,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _ctaBg,
                        foregroundColor: _ctaText,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {
                        // Static UI recreation: no navigation yet.
                      },
                      child: const Text(
                        'Watch Now',
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
          ],
        ),
      ),
    );
  }
}

class _HeroStarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintGlow = Paint()
      ..color = const Color(0xFFFFFFFF).withAlpha(56)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final paintCore = Paint()
      ..color = const Color(0xFFFFFFFF).withAlpha(90)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Big soft "X" on the right side.
    final center = Offset(size.width * 0.82, size.height * 0.55);
    final span = size.height * 0.65;

    canvas.drawLine(
      Offset(center.dx - span * 0.45, center.dy - span * 0.45),
      Offset(center.dx + span * 0.45, center.dy + span * 0.45),
      paintGlow,
    );
    canvas.drawLine(
      Offset(center.dx - span * 0.45, center.dy + span * 0.45),
      Offset(center.dx + span * 0.45, center.dy - span * 0.45),
      paintGlow,
    );

    canvas.drawLine(
      Offset(center.dx - span * 0.45, center.dy - span * 0.45),
      Offset(center.dx + span * 0.45, center.dy + span * 0.45),
      paintCore,
    );
    canvas.drawLine(
      Offset(center.dx - span * 0.45, center.dy + span * 0.45),
      Offset(center.dx + span * 0.45, center.dy - span * 0.45),
      paintCore,
    );

    // Small sparkles points.
    final sparkle = Paint()
      ..color = const Color(0xFFFFFFFF).withAlpha(160)
      ..style = PaintingStyle.fill;

    for (final p in <Offset>[
      Offset(size.width * 0.70, size.height * 0.28),
      Offset(size.width * 0.76, size.height * 0.20),
      Offset(size.width * 0.62, size.height * 0.46),
      Offset(size.width * 0.72, size.height * 0.70),
      Offset(size.width * 0.88, size.height * 0.28),
    ]) {
      canvas.drawCircle(p, 1.6, sparkle);
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
        fontSize: 15,
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
    return Row(
      children: const [
        Expanded(
          child: _FeaturedTile(
            icon: Icons.star_rounded,
            label: 'Rewards',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _FeaturedTile(
            icon: Icons.confirmation_number_rounded,
            label: 'Tickets',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _FeaturedTile(
            icon: Icons.card_giftcard_rounded,
            label: 'Gifts',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _FeaturedTile(
            icon: Icons.local_offer_rounded,
            label: 'Deals',
          ),
        ),
      ],
    );
  }
}

class _FeaturedTile extends StatelessWidget {
  const _FeaturedTile({required this.icon, required this.label});

  final IconData icon;
  final String label;

  static const Color _tileBg = Color(0xFF0F0F14);
  static const Color _divider = Color(0xFF24242A);
  static const Color _textSecondary = Color(0xFFB9B9C2);
  static const Color _accentPurple1 = Color(0xFF7A2CFF);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.05,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Static UI recreation: no action wired yet.
          },
          child: Ink(
            decoration: BoxDecoration(
              color: _tileBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _divider, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
              child: Column(
                children: [
                  const Spacer(),
                  Icon(icon, size: 22, color: _accentPurple1),
                  const Spacer(),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
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

  static const double _cardWidth = 152;
  static const double _cardHeight = 106;

  @override
  Widget build(BuildContext context) {
    // Notes mention portrait-ish thumbnails ~140–160 wide and ~95–110 tall (in
    // dashboard_design_notes.md). We recreate with gradient placeholders to avoid
    // adding binary assets in this task.
    return SizedBox(
      height: _cardHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: const [
          _CuratedCard(
            width: _cardWidth,
            height: _cardHeight,
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [Color(0xFF0F4C3A), Color(0xFF0B0B0F)],
            ),
          ),
          SizedBox(width: 12),
          _CuratedCard(
            width: _cardWidth,
            height: _cardHeight,
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [Color(0xFF4A2B2B), Color(0xFF0B0B0F)],
            ),
          ),
          SizedBox(width: 12),
          _CuratedCard(
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

class _CuratedCard extends StatelessWidget {
  const _CuratedCard({
    required this.width,
    required this.height,
    required this.gradient,
    this.showOverlayX = false,
  });

  final double width;
  final double height;
  final Gradient gradient;
  final bool showOverlayX;

  static const Color _divider = Color(0xFF24242A);
  static const Color _accentPurple1 = Color(0xFF7A2CFF);

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
              top: (height / 2) - 16,
              child: Material(
                color: _accentPurple1,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    // Static UI recreation: no action wired yet.
                  },
                  child: const SizedBox(
                    width: 32,
                    height: 32,
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

  static const Color _bg = Color(0xFF000000);
  static const Color _inactive = Color(0xFF8C8C96);
  static const Color _active = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    // 5 items with center highlighted per dashboard_design_notes.md.
    return Container(
      decoration: const BoxDecoration(
        color: _bg,
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
              icon: Icons.search_rounded,
              selected: selectedIndex == 1,
              onTap: () => onSelected(1),
            ),
            _NavIcon(
              icon: Icons.grid_view_rounded,
              selected: selectedIndex == 2,
              onTap: () => onSelected(2),
            ),
            _NavIcon(
              icon: Icons.play_circle_outline_rounded,
              selected: selectedIndex == 3,
              onTap: () => onSelected(3),
            ),
            _NavIcon(
              icon: Icons.person_outline_rounded,
              selected: selectedIndex == 4,
              onTap: () => onSelected(4),
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

  static const Color _inactive = Color(0xFF8C8C96);
  static const Color _active = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    final color = selected ? _active : _inactive;

    return SizedBox(
      width: 56,
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

