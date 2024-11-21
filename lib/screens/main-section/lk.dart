import 'package:flutter/material.dart';
import 'package:gasoilt/api/account.dart';
import 'package:gasoilt/screens/auth.dart';
import 'package:gasoilt/screens/main-section/actions/lk-profile.dart';
import 'package:gasoilt/widgets/mainButton.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/auth.dart';
import '../../themes/manager.dart';

final WidgetStateProperty<Icon?> thumbIcon =
    WidgetStateProperty.resolveWith<Icon?>(
  (Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return const Icon(Icons.check);
    }
    return const Icon(Icons.close);
  },
);

class LKPage extends StatefulWidget {
  const LKPage({super.key});

  @override
  State<LKPage> createState() => _LKPageState();
}

class _LKPageState extends State<LKPage> {
  String photoPath = '';

  Future getData() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    String token = instance.getString('token')!;
    Map profile = (await getProfile(token));
    photoPath = "http://83.220.174.249:5000${profile['photo']}";
    setState(() {});
  }

  bool emailNotif = false;
  bool smsNotif = false;
  bool emailCheck = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool isDark = Provider.of<DarkThemeProvider>(context).darkTheme;

    return Scaffold(
      body: CustomScrollView(scrollDirection: Axis.vertical, slivers: [
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
        SliverToBoxAdapter(
            child: ListTile(
          leading: const Icon(
            Icons.person,
          ),
          title: const Text('Мои данные'),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LkProfile()));
          },
        )),
        SliverToBoxAdapter(
            child: ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Настройки'),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                    title: const Text('Настройки'),
                  ),
                  body: Column(
                    children: [
                      SwitchListTile(
                        value: themeChange.darkTheme,
                        onChanged: (bool value) {
                          themeChange.darkTheme = value;
                        },
                        title: const Text('Темная тема'),
                      )
                    ],
                  ),
                );
              },
            );
          },
        )),
        const SliverToBoxAdapter(
          child: Divider(
            height: 20,
            thickness: 2,
            indent: 25,
            endIndent: 25,
          ),
        ),
        SliverToBoxAdapter(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: mainButton(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height * .05, () async {
            await SharedPreferences.getInstance().then((value) {
              value.remove('token');
            });

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const AuthorizationScreen()));
          }, "Выйти из приложения"),
        )),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: mainButton(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height * .05, () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text('Удаление аккаунта'),
                        centerTitle: true,
                        automaticallyImplyLeading: false,
                      ),
                      body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomScrollView(
                          slivers: [
                            const SliverToBoxAdapter(
                              child: Text(
                                'Подтвердите Ваше действие, отменить его будет невозможно.',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SliverToBoxAdapter(
                              child: Divider(
                                height: 20,
                                thickness: 2,
                                indent: 25,
                                endIndent: 25,
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: mainButton(
                                  MediaQuery.of(context).size.width, 40.0,
                                  () async {
                                deleteData().then((value) async {
                                  await SharedPreferences.getInstance()
                                      .then((value) {
                                    value.remove('token');
                                  });

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const AuthorizationScreen()));
                                });
                              }, 'Удалить', false, false, Colors.red),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            }, "Удалить аккаунт", null, null, Colors.red),
          ),
        )
      ]),
    );
  }
}
