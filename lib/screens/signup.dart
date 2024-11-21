import 'package:flutter/material.dart';
import 'package:gasoilt/api/auth.dart';
import 'package:gasoilt/screens/auth.dart';
import 'package:gasoilt/screens/sms-code.dart';
import 'package:gasoilt/widgets/mainButton.dart';
import 'package:masked_text/masked_text.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../themes/manager.dart';

class EnterScreen extends StatefulWidget {
  const EnterScreen({super.key});

  @override
  State<EnterScreen> createState() => _EnterScreenState();
}

class _EnterScreenState extends State<EnterScreen> {
  bool _legalEntity = false;
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController secondName = TextEditingController();

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
            : Container(),
        SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.width * .3,
                  horizontal: MediaQuery.of(context).size.height * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Регистрация",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.right,
                  ),
                  const Text(
                      "Войдите, чтобы получать подарки, копить бонусы и делиться литрами"),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Телефон:"),
                      MaskedTextField(
                        controller: phoneController,
                        mask: "+7 (###) ###-##-##",
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            hintText: "+7 (000) 000-00-00"),
                      )
                    ],
                  ),
                  
                  TextField(
                    controller: surnameController,
                    decoration: const InputDecoration(hintText: "Ваша фамилия"),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: "Ваше имя"),
                  ),
                  TextField(
                    controller: secondName,
                    decoration: const InputDecoration(hintText: "Ваше отчество"),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: mainButton(double.infinity,
                        MediaQuery.of(context).size.height * .05, () async {
                      Map response = await signUp(
                          phoneController.text,
                          _legalEntity ? 1 : 0,
                          nameController.text.split(' ')[0],
                          surnameController.text.split(' ')[0],
                          secondName.text.split(' ')[0]);
                      String token = response['token'];

                      SharedPreferences instance =
                          await SharedPreferences.getInstance();
                      instance.setString('token', token);
                      print(token);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SmsCodeVerificationScreen(
                                    phone: phoneController.text,
                                  )));
                    }, "Продолжить"),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const AuthorizationScreen()));
                      },
                      child: const Center(child: Text('Проблемы со входом?')))
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
