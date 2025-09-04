import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'home.dart';
import 'image_capture_screen.dart';
import 'api_cards_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final PageStorageBucket _bucket = PageStorageBucket();
  int _currentIndex = 0;

  late final List<_Tab> _tabs = [
    _Tab(
      title: 'Home',
      icon: Icons.home,
      child: const HomePage(),
      storageKey: const PageStorageKey('home'),
    ),
    _Tab(
      title: 'Cámara',
      icon: Icons.camera_alt,
      child: const ImageCaptureScreen(),
      storageKey: const PageStorageKey('camera'),
    ),
    _Tab(
      title: 'API Cards',
      icon: Icons.style,
      child: const ApiCardsScreen(),
      storageKey: const PageStorageKey('apiCards'),
    ),
  ];

  void _onTabTapped(int index) => setState(() => _currentIndex = index);

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Cerrar sesión',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final auth = context.read<AuthViewModel>();
    try {
      await auth.signOut();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesión cerrada correctamente')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cerrar sesión: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isWide = MediaQuery.of(context).size.width >= 900;

    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true, // content can go to the very top
        appBar: AppBar(
          // No title — only the logout button
          title: const SizedBox.shrink(),
          automaticallyImplyLeading: false,
          centerTitle: false,

          // fully transparent header
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,

          // readable icons over any bg
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),

          // transparent status bar
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light, // Android
            statusBarBrightness: Brightness.dark, // iOS
          ),

          // Right-side logout menu stays visible
          actions: [
            Selector<AuthViewModel, String?>(
              selector: (_, vm) => vm.currentUser?.email,
              builder: (context, email, _) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.account_circle),
                  itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      enabled: false,
                      child: Text(
                        'Signed in as:\n${email ?? 'Unknown'}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem<String>(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Cerrar sesión'),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'logout') _confirmLogout();
                  },
                );
              },
            ),
          ],
        ),
        // No top padding — your screen content can reach the top
        body: PageStorage(
          bucket: _bucket,
          child: Row(
            children: [
              if (isWide)
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: _onTabTapped,
                  labelType: NavigationRailLabelType.selected,
                  destinations: _tabs
                      .map(
                        (t) => NavigationRailDestination(
                          icon: Icon(t.icon),
                          selectedIcon: Icon(t.icon),
                          label: Text(t.title),
                        ),
                      )
                      .toList(),
                ),
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: _tabs
                      .map(
                        (t) => KeyedSubtree(key: t.storageKey, child: t.child),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: isWide
            ? null
            : BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: _onTabTapped,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: colorScheme.primary,
                unselectedItemColor: colorScheme.onSurfaceVariant,
                items: _tabs
                    .map(
                      (t) => BottomNavigationBarItem(
                        icon: Icon(t.icon),
                        label: t.title,
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}

class _Tab {
  final String title;
  final IconData icon;
  final Widget child;
  final Key storageKey;
  const _Tab({
    required this.title,
    required this.icon,
    required this.child,
    required this.storageKey,
  });
}
