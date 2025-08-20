import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../screens/test_screen.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env"); // Load .env here
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        home: Scaffold(
          appBar: AppBar(title: const Text('Pokémon TCG API Test')),
          body: TestScreen(),
        ),
      ),
    );
  }
}
