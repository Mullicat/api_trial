// lib/main.dart
import 'package:api_trial/screens/image_capture_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:api_trial/screens/test_screen_pokemon.dart';
import 'package:api_trial/screens/test_screen_magic.dart';
import 'package:api_trial/screens/test_screen_apitcg.dart';
import 'package:api_trial/screens/test_screen_yugioh.dart';
import 'dart:developer' as dev;

Future<void> main() async {
  try {
    await dotenv.load(fileName: "assets/.env");
    runApp(const MainApp());
  } catch (e, stack) {
    dev.log('Main error: $e', stackTrace: stack);
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedScreenIndex = 4;

  final List<Widget> _screens = [
    const TestScreen(),
    const TestScreenMagic(),
    const TestScreenApiTcg(),
    const TestScreenYuGiOh(),
    const ImageCaptureScreen(),
  ];

  final List<String> _screenTitles = [
    'Pokémon TCG',
    'Magic: The Gathering',
    'API TCG',
    'Yu-Gi-Oh!',
    'Image Capture',
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
                for (int i = 0; i < _screenTitles.length; i++)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _onScreenSelected(i),
                      child: Text(_screenTitles[i]),
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
