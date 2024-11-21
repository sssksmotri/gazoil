import 'package:flutter/material.dart';
import 'package:gasoilt/api/account.dart';
import 'package:gasoilt/widgets/mainButton.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../../themes/manager.dart';

// ignore: must_be_immutable
class QRPage extends StatefulWidget {
  Function navi;
  QRPage({super.key, required this.navi});

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  var imageData;
  bool isLoaded = false;
  String name = '';
  late Timer _timer;
  Map<String, dynamic> card = {
    "card_number": "string",
    "status": 0,
    "status_name": "string",
    "next_status": "string",
    "points_to_next": 0
  };
  @override
  void initState() {
    getData();
    super.initState();
    _timer = Timer.periodic(Duration(minutes: 15), (Timer t) {
      print('qrcode: обновился $imageData');
      getData();
    });
  }

  void getData() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    String token = instance.getString('token')!;
    imageData = await getQR(token);
    card = await loyaltyCard(token);

    setState(() {});
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    bool isDark = Provider.of<DarkThemeProvider>(context).darkTheme;

    return SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
        // height: MediaQuery.of(context).size.width * .5,
        width: MediaQuery.of(context).size.width * .85,
        child: imageData != null ? Image.memory(imageData) : Container(),
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: mainButton(MediaQuery.of(context).size.width * .8, 50.0, () {
          //print('Boo!');
          getData();
        }, "Обновить QR-код"),
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: null,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * .13 * 1.5,
                child: Stack(children: [
                  Image.asset(
                      Theme.of(context).brightness == Brightness.light
                          ? 'images/user-card.png'
                          : 'images/user-card-dark.png',
                      width: MediaQuery.of(context).size.width * .46 * 1.5),
                  Center(
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * .46 * 1.5,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : const Color.fromARGB(255, 73, 73, 73),
                      ),
                      child: Center(
                          child: Text(
                        card['card_number'],
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                    ),
                  )
                ]),
              ),
            ),
          ),
        ],
      )
    ]));
  }
}

Widget imageDialog(text, path, context) {
  return Dialog(
    shadowColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    child: SizedBox(
      height: MediaQuery.of(context).size.height * .22,
      child: Stack(children: [
        Image.asset(path, width: MediaQuery.of(context).size.width * .8),
        Center(
          child: Container(
            height: 45,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : const Color.fromARGB(255, 73, 73, 73)),
            child: Center(
                child: Text(
              text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
          ),
        )
      ]),
    ),
  );
}
