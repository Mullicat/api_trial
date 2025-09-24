import 'package:flutter/material.dart';
import 'test_screen_pokemon.dart';
import 'test_screen_magic.dart';
import 'test_screen_yugioh.dart';
import 'test_screen_apitcg.dart';
import 'screen_onepiece.dart';

class ApiCardsScreen extends StatelessWidget {
  const ApiCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final crossAxisCount = _columnsForWidth(width);
            final horizontalPadding = width >= 1000 ? 24.0 : 16.0;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        24,
                        horizontalPadding,
                        12,
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Choose your card game',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 8,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: _CardsGrid(crossAxisCount: crossAxisCount),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  int _columnsForWidth(double w) {
    if (w >= 1400) return 4;
    if (w >= 900) return 3;
    return 2;
  }
}

class _CardsGrid extends StatelessWidget {
  const _CardsGrid({required this.crossAxisCount});
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    final items = [
      _GameCardData(
        title: 'Pokémon TCG',
        icon: Icons.catching_pokemon,
        color: const Color(0xFF2A75BB),
        onTap: () => _navigateTo(context, const TestScreen()),
      ),
      _GameCardData(
        title: 'Magic: The Gathering',
        icon: Icons.auto_fix_high,
        color: const Color(0xFFF26722),
        onTap: () => _navigateTo(context, const TestScreenMagic()),
      ),
      _GameCardData(
        title: 'Yu-Gi-Oh!',
        icon: Icons.style,
        color: const Color(0xFF991B1B),
        onTap: () => _navigateTo(context, const TestScreenYuGiOh()),
      ),
      _GameCardData(
        title: 'One Piece TCG',
        icon: Icons.directions_boat,
        color: const Color(0xFF2F4F4F),
        onTap: () => _navigateTo(context, const ScreenOnePiece()),
      ),
      _GameCardData(
        title: 'TCG API',
        icon: Icons.api,
        color: const Color(0xFF3742FA),
        onTap: () => _navigateTo(context, const TestScreenApiTcg()),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, i) => _GameCard(item: items[i]),
    );
  }

  static void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, a, __) => screen,
        transitionDuration: const Duration(milliseconds: 280),
        transitionsBuilder: (_, a, __, child) {
          final tween = Tween(
            begin: const Offset(0.06, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOutCubic));
          return SlideTransition(position: a.drive(tween), child: child);
        },
      ),
    );
  }
}

class _GameCardData {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  _GameCardData({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class _GameCard extends StatefulWidget {
  const _GameCard({required this.item});
  final _GameCardData item;

  @override
  State<_GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<_GameCard> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = widget.item;

    final scale = _pressed ? 0.98 : (_hovered ? 1.02 : 1.0);
    final elevation = _hovered ? 10.0 : 6.0;

    return Semantics(
      button: true,
      label: '${item.title}.',
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: scale,
        child: Card(
          clipBehavior: Clip.antiAlias, // ripple respects radius
          elevation: elevation,
          shadowColor: item.color.withOpacity(0.25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [item.color, item.color.withOpacity(0.85)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: InkWell(
              onTap: item.onTap,
              onHover: (h) => setState(() => _hovered = h),
              onTapDown: (_) => setState(() => _pressed = true),
              onTapCancel: () => setState(() => _pressed = false),
              onTapUp: (_) => setState(() => _pressed = false),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item.icon, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      item.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
