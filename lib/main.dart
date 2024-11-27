import 'package:flutter/material.dart';
import 'package:gasoilt/themes/manager.dart';
import 'package:provider/provider.dart';
import './screens/welcome.dart';
import 'dart:io';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(milliseconds: 300));
  runApp(MyApp());
}



class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) {
      return themeChangeProvider;
    }, child: Consumer<DarkThemeProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: !themeChangeProvider.darkTheme
              ? ThemeData(
                  primaryColor: Palette.kToDark,
                  textTheme: const TextTheme(
                    bodyMedium: TextStyle(fontSize: 16),
                    bodyLarge: TextStyle(fontSize: 16),
                  ).apply(
                    bodyColor: Colors.black,
                  ),
                  primarySwatch: Palette.kToDark,
                  //scaffoldBackgroundColor: const Color(0xfff8f4f4),
                  brightness: Brightness.light)
              : ThemeData(
                  primaryColor: Palette.kToDark,
                  textTheme: const TextTheme(
                    bodyMedium: TextStyle(fontSize: 16),
                    bodyLarge: TextStyle(fontSize: 16),
                  ).apply(
                    bodyColor: Colors.white,
                  ),
                  primarySwatch: Palette.kToDark,
                  //scaffoldBackgroundColor: const Color(0xff2d3337),
                  brightness: Brightness.dark),
          home: WelcomeScreen(),
          builder: (context, child) {
            return MediaQuery(
              //чтобы шрифты всегда были одного размера
              child: child!,
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            );
          },
        );
      },
    ));
  }
}

class Palette {
  static const MaterialColor kToDark = MaterialColor(
    0xff00b929,
    <int, Color>{
      50: Color(0xff00b929), //10%
      100: Color(0xff03a627), //20%
      200: Color(0xff03a627), //30%
      300: Color(0xff01821e), //40%
      400: Color(0xff016e19), //50%
      500: Color(0xff015e16), //60%
      600: Color(0xff014d12), //70%
      700: Color(0xff01360c), //80%
      800: Color(0xff011c06), //90%
      900: Color(0xff000000), //100%
    },
  );
}
