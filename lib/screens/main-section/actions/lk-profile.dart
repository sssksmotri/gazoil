import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/auth.dart';
import '../../../themes/manager.dart';
import '../../../widgets/mainButton.dart';

class LkProfile extends StatefulWidget {
  const LkProfile({super.key});

  @override
  State<LkProfile> createState() => _LkProfileState();
}

class _LkProfileState extends State<LkProfile> {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController surnameEditingController = TextEditingController();
  TextEditingController fatherEditingController = TextEditingController();

  String name = '';
  String surname = '';
  String photo = '';
  String phone = '';
  String father = '';

  Future getData() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    String token = instance.getString('token')!;
    Map profile = (await getProfile(token));
    print(profile);

    name = profile['name'];
    surname = profile['surname'];
    father = profile['second_name'];
    phone = profile['phone'];
    
    setState(() {});
  }

  Future saveData() async {}

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<DarkThemeProvider>(context).darkTheme;

    return Scaffold(
        body: CustomScrollView(
      scrollDirection: Axis.vertical,
      slivers: [
        SliverAppBar(
          title: const Text('Личный кабинет'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: !isDark
                  ? [const Color(0xffcbffd6), const Color(0xffcaffa0)]
                  : [const Color(0xff0d4b29), const Color(0xff0a8467)],
              stops: const [0, 1],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          const Divider(
            height: 20,
            thickness: 2,
            indent: 5,
            endIndent: 5,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    flex: 1,
                    child: Text('Фамилия: ',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                      flex: 2,
                      child: TextField(
                        controller: surnameEditingController,
                        decoration: InputDecoration(
                          hintText: surname,
                          contentPadding: const EdgeInsets.all(1),
                        ),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal),
                      ))
                ],
              )),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    flex: 1,
                    child: Text('Имя: ',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                      flex: 2,
                      child: TextField(
                        controller: nameEditingController,
                        decoration: InputDecoration(
                          hintText: name,
                          contentPadding: const EdgeInsets.all(1),
                        ),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal),
                      ))
                ],
              )),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    flex: 1,
                    child: Text('Отчество: ',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                      flex: 2,
                      child: TextField(
                        controller: fatherEditingController,
                        decoration: InputDecoration(
                          hintText: father,
                          contentPadding: const EdgeInsets.all(1),
                        ),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal),
                      ))
                ],
              )),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    flex: 1,
                    child: Text('Номер телефона: ',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                      flex: 2,
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: phone.replaceAllMapped(
                                RegExp(r'(\d{1})(\d{3})(\d{3})(\d{2})(\d+)'),
                                (Match m) =>
                                    "+${m[1]} ${m[2]} ${m[3]} ${m[4]} ${m[5]}"),
                            contentPadding: const EdgeInsets.all(1),
                            enabled: false),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal),
                      ))
                ],
              )),
          const Divider(
            height: 20,
            thickness: 2,
            indent: 5,
            endIndent: 5,
          ),
        ])),
        SliverToBoxAdapter(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: mainButton(MediaQuery.of(context).size.width * .4, 40.0,
              () async {
            String newName = nameEditingController.text;
            String newSurname = surnameEditingController.text;
            String newFather = fatherEditingController.text;

            await SharedPreferences.getInstance().then((prefs) {
              prefs.setBool('setUserData', true);

              if (newName.isNotEmpty) {
                prefs.setString('newName', newName);
              }

              if (newSurname.isNotEmpty) {
                prefs.setString('newSurname', newSurname);
              }

              if (newFather.isNotEmpty) {
                prefs.setString('newFather', newFather);
              }
            }).whenComplete(() {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Новые данные сохранены')));
            });
          }, "Сохранить"),
        ))
      ],
    ));
  }
}
