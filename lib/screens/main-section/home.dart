import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gasoilt/api/account.dart';
import 'package:gasoilt/api/auth.dart';
import 'package:gasoilt/screens/main-section/historypage.dart';
import 'package:gasoilt/screens/main-section/hot-page.dart';
import 'package:gasoilt/screens/main-section/house-page.dart';
import 'package:gasoilt/screens/main-section/lk.dart';
import 'package:gasoilt/screens/main-section/map-page.dart';
import 'package:gasoilt/screens/main-section/mapActions/AZSlist.dart';
import 'package:gasoilt/screens/main-section/mapActions/filters.dart';
import 'package:gasoilt/screens/main-section/qr-page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../themes/manager.dart';
import 'dart:math' as math;

// для имени с фамилией
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  int initPage;
  HomeScreen({super.key, required this.initPage});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pageType = 1;
  int? _pageIndex;
  List<Widget> notifsWidget = [];
  String name = "";
  String surname = "";
  //получение данных о пользователе с сервера
  Future getData() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    String token = instance.getString('token')!;
    List notifs = (await notifications(token))['notifications'];
    Map profile = (await getProfile(token));
    print(profile);
    name = profile['name'];
    surname = profile['surname'];
    for (var element in notifs) {
      notifsWidget.add(
          notificationWidget("", element['title'], element['description']));
    }
    setState(() {});
  }

  void navi() {
    setState(() {
      _pageIndex = 1;
    });
  }

  //выбираем правильное тело виджета приложения
  Widget getBodyByIndex(int index) {
    if (index == 2) {
      return QRPage(navi: navi);
    }
    if (index == 0) {
      return const HousePage();
    }
    if (index == 1) {
      return const HotPage();
    }
    if (index == 3) {
      return const HistoryPage();
    }
    if (index == 4) {
      // Future.delayed(Duration.zero, () {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (BuildContext context) => (MapPage())));
      // });
      return MapPage();
    }
    return Container();
  }

  @override
  void initState() {
    _pageIndex = widget.initPage;
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<DarkThemeProvider>(context).darkTheme;
    // получаем правильную верхнюю панель для каждой страницы
    Widget getAppBarContextByIndex(int index) {
      if (index == 3) {
        return const Padding(
          padding: EdgeInsets.only(left: 25.0, bottom: 20),
          child: Text(
            'История',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        );
      }
      if (index == 1) {
        return const Padding(
          padding: EdgeInsets.only(left: 25.0, bottom: 20),
          child: Text(
            'Акции',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        );
      }
      if (index == 2 || index == 0) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 20),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => const LKPage()));
                },
                backgroundColor:  const Color(0xff00b929),
                child: Icon(Icons.person, color: isDark ? Colors.white : Colors.white,),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                "${name.capitalize()} ${surname.capitalize()}",
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              )
            ],
          ),
        );
      }
      return Container();
    }

    Widget returnBody(pageType) {
      Widget appBarContent =
          getAppBarContextByIndex(_pageIndex ?? widget.initPage);
      if (pageType == 1) {
        return Column(children: [
          _pageIndex != 4
              ? Container(
                  height: MediaQuery.of(context).size.height * .2,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: !isDark
                        ? [const Color(0xffcbffd6), const Color(0xffcaffa0)]
                        : [const Color(0xff0d4b29), const Color(0xff0a8467)],
                    stops: const [0, 1],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15, right: 15),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                child: !isDark
                                    ? SvgPicture.asset(
                                        'icons/notification.svg',
                                        color: Colors.transparent,
                                      )
                                    : SvgPicture.asset(
                                        'icons/notif-white-true.svg',
                                        color: Colors.transparent),
                                onTap: () {
                                  setState(() {
                                    _pageType = 2;
                                  });
                                },
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                child: !isDark
                                    ? SvgPicture.asset('icons/actions.svg')
                                    : SvgPicture.asset('icons/list-white.svg'),
                                onTap: () {
                                  setState(() {
                                    _pageType = 3;
                                  });
                                },
                              )
                            ],
                          ),
                          Row(
                            children: [appBarContent],
                          )
                        ]),
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height * .15,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: !isDark
                        ? [const Color(0xffcbffd6), const Color(0xffcaffa0)]
                        : [const Color(0xff0d4b29), const Color(0xff0a8467)],
                    stops: const [0, 1],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset('icons/compas.svg'),
                                  const SizedBox(width: 10),
                                  const Text('маршрут'),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    child: SvgPicture.asset(
                                        'icons/note-sheet.svg'),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AZSList()));
                                    },
                                  ),
                                  const SizedBox(width: 30),
                                  GestureDetector(
                                    child: SvgPicture.asset(
                                        'icons/map-settings.svg'),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const FiltersPage()));
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        )
                      ]),
                ),
          getBodyByIndex(_pageIndex ?? widget.initPage),
        ]);
      }
      if (pageType == 2) {
        return Column(children: [
          Container(
            height: MediaQuery.of(context).size.height * .15,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: !isDark
                  ? [const Color(0xffcbffd6), const Color(0xffcaffa0)]
                  : [const Color(0xff0d4b29), const Color(0xff0a8467)],
              stops: const [0, 1],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )),
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_left),
                    onPressed: () {
                      setState(() {
                        _pageType = 1;
                      });
                    },
                  ),
                ],
              ),
              const Row(
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      'Сообщения',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  )
                ],
              ),
            ]),
          ),
          ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: const BoxDecoration(
                      border: Border.symmetric(
                          horizontal:
                              BorderSide(color: Colors.grey, width: 1))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: notifsWidget,
                  ),
                ),
              )
            ],
          )
        ]);
      }
      if (pageType == 3) {
        return Column(children: [
          Container(
            height: MediaQuery.of(context).size.height * .15,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: !isDark
                  ? [const Color(0xffcbffd6), const Color(0xffcaffa0)]
                  : [const Color(0xff0d4b29), const Color(0xff0a8467)],
              stops: const [0, 1],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )),
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Transform.rotate(
                    angle: 180 * math.pi / 180,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_right_alt),
                      onPressed: () {
                        setState(() {
                          _pageType = 1;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Text(
                      'Меню',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  )
                ],
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: ListView(
              shrinkWrap: true,
              children: [
                actionCard('О приложении', isDark),
                actionCard('О компании', isDark),
                actionCard('Техподдержка', isDark),
                actionCard('Политика конфиденциальности', isDark),
              ],
            ),
          )
        ]);
      }
      return Container();
    }

    bool returnFalse(int index) {
      return false;
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: returnBody(_pageType),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: !isDark
            ? const Color.fromARGB(255, 27, 27, 27)
            : const Color.fromARGB(255, 91, 104, 112),
        color: isDark ? Colors.black : Colors.white,
        items: <Widget>[
          _pageIndex == 0
              ? SvgPicture.asset('icons/bottombaricons/active/house.svg')
              : !isDark
                  ? SvgPicture.asset('icons/bottombaricons/bright/house.svg')
                  : SvgPicture.asset('icons/bottombaricons/dark/house.svg'),
          _pageIndex == 1
              ? SvgPicture.asset('icons/bottombaricons/active/fire.svg')
              : !isDark
                  ? SvgPicture.asset('icons/bottombaricons/bright/fire.svg')
                  : SvgPicture.asset('icons/bottombaricons/dark/fire.svg'),
          Icon(Icons.qr_code,
              size: 30,
              color: _pageIndex == 2
                  ? Colors.white
                  : !isDark
                      ? Colors.grey
                      : Colors.white),
          _pageIndex == 3
              ? SvgPicture.asset('icons/bottombaricons/active/list.svg')
              : !isDark
                  ? SvgPicture.asset('icons/bottombaricons/bright/list.svg')
                  : SvgPicture.asset('icons/bottombaricons/dark/list.svg'),
          _pageIndex == 4
              ? SvgPicture.asset('icons/bottombaricons/active/location.svg')
              : !isDark
                  ? SvgPicture.asset('icons/bottombaricons/bright/location.svg')
                  : SvgPicture.asset('icons/bottombaricons/dark/location.svg'),
        ],
        index: _pageIndex ?? widget.initPage,
        onTap: (index) {
          setState(() {
            _pageIndex = index;
            _pageType = 1;
          });
        },
      ),
    );
  }
}

Widget actionCard(text, isDark, [Function? ontap]) {
  return GestureDetector(
    onTap: ontap != null ? () => ontap() : () {},
    child: Container(
        decoration: BoxDecoration(
            color: isDark ? const Color(0xFF3e474c) : Colors.white,
            border: Border.symmetric(
                horizontal:
                    BorderSide(color: Colors.grey.withOpacity(.1), width: 1))),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right_outlined,
                size: 30,
                color: !isDark
                    ? const Color(0xFF3e474c).withOpacity(.3)
                    : Colors.white,
              )
            ],
          ),
        )),
  );
}

Widget notificationWidget(time, title, description) {
  return Container(
    decoration: const BoxDecoration(
        border: Border.symmetric(
            horizontal: BorderSide(color: Colors.grey, width: 1))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        time,
        style: const TextStyle(color: Colors.grey),
      ),
      const SizedBox(
        height: 15,
      ),
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: 5,
      ),
      Text(
        description,
        style: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
      const SizedBox(
        height: 30,
      )
    ]),
  );
}
