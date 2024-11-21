import 'package:flutter/material.dart';
import 'package:gasoilt/screens/main-section/actions/hot-full.dart';
import 'package:gasoilt/themes/manager.dart';
import 'package:provider/provider.dart';

import 'dart:math' as math;

class BonusCardsPage extends StatelessWidget {
  const BonusCardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<DarkThemeProvider>(context).darkTheme;

    return Scaffold(
      body: Column(children: [
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
                    icon: const Icon(
                      Icons.arrow_right_alt,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        'Статус карт лояльности',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ]),
        ),
        SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
                height: MediaQuery.of(context).size.height * .67,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListView(children: [
                    ActionCard(
                        MediaQuery.of(context).size.height * .15,
                        "СТАНДАРТ",
                        "",
                        "description",
                        "images/user-card.png",
                        "pro"),
                    const SizedBox(
                      height: 10,
                    ),
                    ActionCard(
                        MediaQuery.of(context).size.height * .15,
                        "СЕРЕБРО",
                        "",
                        "description",
                        "images/user-card.png",
                        "pro"),
                    const SizedBox(
                      height: 10,
                    ),
                    ActionCard(
                        MediaQuery.of(context).size.height * .15,
                        "ЗОЛОТО",
                        "",
                        "description",
                        "images/user-card.png",
                        "pro"),
                  ]),
                )))
      ]),
    );
  }
}

// сама карточка лояльности
// ignore: must_be_immutable
class ActionCard extends StatelessWidget {
  double height;
  String title;
  String text;
  String footer;
  String image;
  String description;
  ActionCard(this.height, this.title, this.text, this.footer, this.image,
      this.description);

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<DarkThemeProvider>(context).darkTheme;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HotFullPage(
                imageUrl: 'images/user-card.png',
                dates: footer,
                title: title,
                description: description)));
      },
      child: Container(
          padding: const EdgeInsets.all(10),
          height: height,
          decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3e474c) : Colors.white,
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(image),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .4,
                        child: Text(title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .4,
                        child: Text(
                          text,
                          style: const TextStyle(fontSize: 13),
                        ),
                      )
                    ],
                  ),
                  Text(
                    footer,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
