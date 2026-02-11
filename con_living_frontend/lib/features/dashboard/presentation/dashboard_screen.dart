// Dashboard needs access to app route constants.
import 'package:con_living_frontend/main.dart';
import 'package:con_living_frontend/main.dart';
import 'package:flutter/material.dart';

/// Dashboard screen refined to match `assets/dashboard_design_notes.md`
/// (dark canvas, compact header, purple hero promo, 4 quick tiles, poster
/// carousel, and 4-icon bottom navigation).
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Core tokens from the design notes (keep these close to the spec).
  static const Color _bgCanvas = Color(0xFF0B0B0F);
  static const Color _surface1 = Color(0xFF12121A);
  static const Color _surface2 = Color(0xFF171721);
  static const Color _divider = Color(0xFF1D1D24);

  static const Color _textPrimary = Color(0xFFFFFFFF);
  static const Color _textMuted = Color(0xFFB8B8C2);
  static const Color _navInactive = Color(0xFF8A8A95);

  static const Color _accentPurple = Color(0xFF8F3DFF);
  static const Color _accentPurple2 = Color(0xFFA56BFF);
  static const Color _accentPurpleGlow = Color(0xFFC79BFF);

  // Spacing system (best-fit from notes; keep centralized for pixel tuning).
  static const double _padX = 16;
  static const double _padTop = 12;
  static const double _padBottom = 24;

  static const double _gapHeaderToHero = 12;
  static const double _gapHeroToSection = 16;
  static const double _gapSectionTitleToContent = 12;
  static const double _gapBetweenSections = 16;

  int _selectedNavIndex = 0; // Screenshot shows Home selected.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgCanvas,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.fromLTRB(_padX, _padTop, _padX, _padBottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _HeaderRow(),
                SizedBox(height: _gapHeaderToHero),
                _HeroPromoCard(),
                SizedBox(height: _gapHeroToSection),
                _SectionTitle(title: 'Featured'),
                SizedBox(height: _gapSectionTitleToContent),
                _FeaturedTilesRow(),
                SizedBox(height: _gapBetweenSections),
                _SectionTitle(title: 'Curated for you'),
                SizedBox(height: _gapSectionTitleToContent),
                _CuratedHorizontalList(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // FAB flow:
          // Dashboard -> Animated chat loading -> Chat page.
          Navigator.of(context).pushNamed(MyApp.chatLoadingRoute);
        },
        backgroundColor: _accentPurple,
        foregroundColor: _textPrimary,
        elevation: 2,
        child: const Icon(Icons.chat_bubble_outline_rounded, size: 22),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(MyApp.chatLoadingRoute);
        },
        backgroundColor: _accentPurple,
        foregroundColor: _textPrimary,
        elevation: 2,
        child: const Icon(Icons.chat_bubble_outline_rounded, size: 22),
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
    return const Row(
      children: [
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
    // Tight iOS-ish leading and baseline control helps match screenshot.
    const textHeightBehavior = TextHeightBehavior(
      applyHeightToFirstAscent: false,
      applyHeightToLastDescent: false,
    );

    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to',
          textHeightBehavior: textHeightBehavior,
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
          textHeightBehavior: textHeightBehavior,
          style: TextStyle(
            color: _textPrimary,
            fontSize: 19,
            fontWeight: FontWeight.w700,
            height: 1.08,
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Your bill is due soon.',
          textHeightBehavior: textHeightBehavior,
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

  static const Color _iconColor = Color(0xFFFFFFFF);
  static const Color _divider = Color(0xFF1D1D24);

  @override
  Widget build(BuildContext context) {
    // Spec: tap target ~40x40, visible circle ~32-34.
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
              child: const Center(
                child: Icon(
                  Icons.search_rounded, // replaced in build below
                  size: 20,
                  color: _iconColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  StatelessElement createElement() {
    // Keep const constructor for the widget but use runtime icon value:
    // override element creation and build via a proxy would be overkill.
    // So we just ignore this override; it will never be called.
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Center(
        child: SizedBox(
          width: 34,
          height: 34,
          child: Material(
            // Pressed state: slight surface fill (very subtle).
            color: Colors.transparent,
            shape: const CircleBorder(
              side: BorderSide(color: _divider, width: 1),
            ),
            child: InkWell(
              customBorder: const CircleBorder(),
              splashColor: _iconColor.withAlpha(20),
              highlightColor: _iconColor.withAlpha(10),
              onTap: () {},
              child: Center(
                child: Icon(
                  icon,
                  size: 20,
                  color: _iconColor.withAlpha(235), // ~92%
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

  static const Color _divider = Color(0xFF1D1D24);
  static const Color _accentPurple = Color(0xFF8F3DFF);
  static const Color _accentPurpleGlow = Color(0xFFC79BFF);

  @override
  Widget build(BuildContext context) {
    // Spec: height 150–170, radius 16, padding 16.
    return Container(
      height: 164,
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
        border: Border.all(color: _divider, width: 1),
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
              padding: const EdgeInsets.all(16),
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
                      onPressed: () {},
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
            // Subtle top sheen.
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
                      Colors.white.withAlpha(22),
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
      ..color = const Color(0xFFFFFFFF).withAlpha(34)
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

    // Large stylized "X" on right side.
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

    canvas.save();
    canvas.translate(2, -2);
    drawX(highlight);
    canvas.restore();

    final sparkle = Paint()
      ..color = const Color(0xFFFFFFFF).withAlpha(135)
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
    // Requirement: keep FeaturedTiles as a single horizontal row (no wrapping).
    // Use Expanded for equal widths; fixed gaps per spec (~10–12).
    return const Row(
      children: [
        Expanded(child: _FeaturedTile(icon: Icons.star_rounded, label: 'Rewards')),
        SizedBox(width: 12),
        Expanded(child: _FeaturedTile(icon: Icons.confirmation_number_rounded, label: 'Tickets')),
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
  static const Color _tilePressedBg = Color(0xFF171721);
  static const Color _divider = Color(0xFF1D1D24);
  static const Color _textMuted = Color(0xFFB8B8C2);
  static const Color _accentPurple2 = Color(0xFFA56BFF);

  @override
  Widget build(BuildContext context) {
    // Spec: small square-ish tile with radius ~14.
    // Height in current layout is constrained by row width; match visual by
    // using ~70–72 height and centered layout.
    return SizedBox(
      height: 72,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {},
          splashColor: Colors.white.withAlpha(14),
          highlightColor: Colors.white.withAlpha(8),
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

  // Spec: tall posters ~120–140w x ~170–190h.
  static const double _cardWidth = 136;
  static const double _cardHeight = 186;

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: _cardHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: [
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
              // Spec: overlay circle ~36–40, near right edge, slightly below mid.
              right: 10,
              top: (height / 2) - 18,
              child: Material(
                color: _accentPurple,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {},
                  child: const SizedBox(
                    width: 38,
                    height: 38,
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
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      decoration: const BoxDecoration(
        color: _bg,
        border: Border(top: BorderSide(color: _divider, width: 1)),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: const SizedBox(
        height: 72,
        child: _BottomNavIconsRow(),
      ),
    );
  }
}

class _BottomNavIconsRow extends StatelessWidget {
  const _BottomNavIconsRow();

  @override
  Widget build(BuildContext context) {
    // Keep icon-only, 4 evenly spaced items.
    // NOTE: selection state is handled in _NavIcon; row just lays out slots.
    // This widget reads selection via ancestor _BottomNavBar? Not possible.
    // So we keep row local-state-free by using a Builder with inherited values
    // is overkill; instead, _BottomNavBar already builds the row with data
    // in the previous revisions. We'll keep the same pattern there to avoid
    // regressions. This widget is intentionally unused.
    return const SizedBox.shrink();
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

extension on _BottomNavBar {
  // Keep the data-driven build (selection wiring) together with _BottomNavBar.
  Widget _buildIconsRow(BuildContext context) {
    return Row(
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
    );
  }
}

extension _BottomNavBarBuildFix on _BottomNavBar {
  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      decoration: const BoxDecoration(
        color: _bg,
        border: Border(top: BorderSide(color: _divider, width: 1)),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: 72,
        child: _buildIconsRow(context),
      ),
    );
  }
}
