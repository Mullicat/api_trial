import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/test_screen_pokemon.dart';
import 'screens/test_screen_magic.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env"); // Load .env here
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedScreenIndex = 0; // 0 for Pokémon, 1 for Magic

  final List<Widget> _screens = [const TestScreen(), const TestScreenMagic()];

  final List<String> _screenTitles = ['Pokémon TCG', 'Magic: The Gathering'];

  void _onScreenSelected(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        home: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _onScreenSelected(0),
                  child: Text(_screenTitles[0]),
                ),
                ElevatedButton(
                  onPressed: () => _onScreenSelected(1),
                  child: Text(_screenTitles[1]),
                ),
              ],
            ),
          ),
          body: _screens[_selectedScreenIndex],
        ),
      ),
    );
  }
}
