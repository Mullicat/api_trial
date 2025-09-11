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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        toolbarHeight: 30,
        title: const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            'Trading Card Games',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose your card game',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 0.80,
                children: [
                  _buildEnhancedApiCard(
                    context: context,
                    title: 'Pokémon TCG',
                    subtitle: 'Gotta catch \'em all!',
                    icon: Icons.catching_pokemon,
                    color: const Color(0xFF2A75BB),
                    onTap: () => _navigateToScreen(context, const TestScreen()),
                  ),
                  _buildEnhancedApiCard(
                    context: context,
                    title: 'Magic: The Gathering',
                    subtitle: 'Planeswalker\'s choice',
                    icon: Icons.auto_fix_high,
                    color: const Color(0xFFF26722),
                    onTap: () =>
                        _navigateToScreen(context, const TestScreenMagic()),
                  ),
                  _buildEnhancedApiCard(
                    context: context,
                    title: 'Yu-Gi-Oh!',
                    subtitle: 'It\'s time to duel!',
                    icon: Icons.style,
                    color: const Color(0xFF991B1B),
                    onTap: () =>
                        _navigateToScreen(context, const TestScreenYuGiOh()),
                  ),
                  _buildEnhancedApiCard(
                    context: context,
                    title: 'One Piece TCG',
                    subtitle: 'Set sail for adventure!',
                    icon: Icons.directions_boat,
                    color: const Color(0xFF2F4F4F),
                    onTap: () =>
                        _navigateToScreen(context, const ScreenOnePiece()),
                  ),
                  _buildEnhancedApiCard(
                    context: context,
                    title: 'TCG API',
                    subtitle: 'All cards in one',
                    icon: Icons.api,
                    color: const Color(0xFF3742fa),
                    onTap: () =>
                        _navigateToScreen(context, const TestScreenApiTcg()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedApiCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Card(
          elevation: 8,
          shadowColor: color.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: color,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, size: 40, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}
