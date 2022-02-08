import 'package:flutter/material.dart';
import 'package:puzzle15/logic/logic.dart';
import 'package:puzzle15/screen/congratulations_page.dart';
import 'package:puzzle15/screen/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

late PuzzleLogic puzzleLogic;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  puzzleLogic = PuzzleLogic();
  puzzleLogic.prefs = await SharedPreferences.getInstance();

  puzzleLogic.init(
    puzzleLogic.prefs.getInt('matrix') ?? 3,
    puzzleLogic.prefs.getInt('color') ?? 0,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: const Color(0xFF90caf9),
        primaryColor: Colors.white,
        highlightColor: const Color(0xffffc900),
        dialogBackgroundColor: const Color(0xFF19629d),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF19629d),
          titleTextStyle: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
        '/congratulations': (context) => const CongratulationsPage(),
      },
    );
  }
}
