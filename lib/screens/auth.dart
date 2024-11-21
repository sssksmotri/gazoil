import 'package:flutter/material.dart';
import 'package:gasoilt/api/auth.dart';
import 'package:gasoilt/screens/signup.dart';
import 'package:gasoilt/screens/sms-code.dart';
import 'package:gasoilt/widgets/mainButton.dart';
import 'package:masked_text/masked_text.dart';
import 'package:provider/provider.dart';

import '../themes/manager.dart';

class AuthorizationScreen extends StatefulWidget {
  const AuthorizationScreen({super.key});

  @override
  State<AuthorizationScreen> createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {
  bool _legalEntity = false;
  TextEditingController phoneController = TextEditingController();
  TextEditingController secondController = TextEditingController();

  @override
  void initState() {
    // phoneController.text = "+7";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<DarkThemeProvider>(context).darkTheme;
    return Scaffold(
        backgroundColor: const Color(0xfff6f6f7),
        body: Container(
          decoration: isDark ? const BoxDecoration(
              gradient: LinearGradient(
            colors: [Color(0xff173435), Color(0xff134e29)],
            stops: [0, 1],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          )) : const BoxDecoration(
            color: Colors.white
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 75, right: 20, left: 20),
            child: CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: [
                const SliverToBoxAdapter(
                  child: Text(
                    "Авторизация",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                    textAlign: TextAlign.left,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .7,
                    child: const Text(
                        "Войдите, чтобы получать подарки, копить бонусы и делиться литрами"),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                SliverToBoxAdapter(
                  child: MaskedTextField(
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                    controller: phoneController,
                    mask: "+7 (###) ###-##-##",
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        hintText: "+7 (000) 000-00-00",
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 22)),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                SliverToBoxAdapter(
                  child: mainButton(double.infinity, 40.0, () async {
                    print(phoneController.text);
                    if (await phoneExist(phoneController.text)) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SmsCodeVerificationScreen(
                                    phone: phoneController.text,
                                  )));
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                                title: Text("Внимание!"),
                                content: Text(
                                    "Пользователя с таким номером телефона не существует!"),
                              ));
                    }
                  }, "Продолжить"),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                SliverToBoxAdapter(
                  child: mainButton(
                      double.infinity,
                      40.0,
                      () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const EnterScreen()),
                          ),
                      "Регистрация"),
                ),
              ],
            ),
          ),
        ));
  }
}
