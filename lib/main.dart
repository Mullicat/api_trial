import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/test_screen_pokemon.dart';
import 'screens/test_screen_magic.dart';
import 'screens/test_screen_apitcg.dart';
import 'screens/test_screen_yugioh.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedScreenIndex = 2;

  final List<Widget> _screens = [
    const TestScreen(),
    const TestScreenMagic(),
    const TestScreenApiTcg(),
    const TestScreenYuGiOh(),
  ];

  final List<String> _screenTitles = [
    'Pokémon TCG',
    'Magic: The Gathering',
    'API TCG',
    'Yu-Gi-Oh!',
  ];

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
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _onScreenSelected(2),
                    child: Text(_screenTitles[2]),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _onScreenSelected(1),
                    child: Text(_screenTitles[1]),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _onScreenSelected(0),
                    child: Text(_screenTitles[0]),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _onScreenSelected(3),
                    child: Text(_screenTitles[3]),
                  ),
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
