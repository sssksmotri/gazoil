import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gasoilt/screens/auth.dart';
import 'package:gasoilt/screens/main-section/home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../themes/manager.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Timer? timer;
  //получаем данные об авторизации и через 5 секунд после открытия приложения переходим на нужную нам вкладку
  Future<void> getData(context) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    if (timer != null) {
      timer!.cancel();
    }
    if (instance.getString('token') != null) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => HomeScreen(initPage: 2)));
      return;
    }
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const AuthorizationScreen()));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    timer = Timer(const Duration(seconds: 5), () => getData(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<DarkThemeProvider>(context).darkTheme;

    return Scaffold(
      body: Stack(
        children: [
          isDark
              ? Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                    colors: [Color(0xff173435), Color(0xff134e29)],
                    stops: [0, 1],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  )),
                )
              : Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                    colors: [Colors.white, Color.fromARGB(255, 214, 214, 214)],
                    stops: [0, 1],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  )),
                ),
          GestureDetector(
            onTap: () async {
              if (timer != null) {
                timer!.cancel();
                print("timer cancelled!");
              }
              SharedPreferences instance =
                  await SharedPreferences.getInstance();
              if (instance.getString('token') != null) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomeScreen(initPage: 2)));
                return;
              }
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const AuthorizationScreen()));
            },
            child: Center(
                          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .00,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .67,
                child: isDark
                    ? Image.asset('images/neftegazt-white.png')
                    : Image.asset('images/neftegazt-red.png'),
              ),
              Image.asset('images/logo.png'),
              SizedBox(
                width: MediaQuery.of(context).size.width * .5,
                child: const Text(
                  "Программа лояльности сети АЗС “НефтеГазТ”",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              )
            ],
                          ),
                        ),
          ),
        ],
      ),
    );
  }
}
