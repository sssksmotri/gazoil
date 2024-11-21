import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../../../themes/manager.dart';

class FiltersPage extends StatefulWidget {
  const FiltersPage({super.key});

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  bool ai95 = false;
  bool DT = false;
  bool ai92 = false;
  bool wash = false;
  bool cafe = false;
  bool store = false;
  bool shini = false;
  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<DarkThemeProvider>(context).darkTheme;

    return Scaffold(
      body: Container(
        child: Column(children: [
          Container(
            height: MediaQuery.of(context).size.height * .15,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: !isDark
                  ? [Color(0xffcbffd6), Color(0xffcaffa0)]
                  : [Color(0xff0d4b29), Color(0xff0a8467)],
              stops: [0, 1],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          'Фильтры',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7.0, right: 10),
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            ai95 = false;
                            DT = false;
                            ai92 = false;
                            wash = false;
                            cafe = false;
                            store = false;
                            shini = false;
                          });
                        },
                        child: Text(
                          "очистить",
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color),
                        )),
                  )
                ],
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "ТОПЛИВО",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  // decoration: BoxDecoration(color: Colors.white),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('АИ-95'),
                        Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              shape: CircleBorder(),
                              value: ai95,
                              onChanged: (_) {
                                setState(() {
                                  ai95 = !ai95;
                                });
                              }),
                        ),
                      ],
                    ),
                    Container(
                      height: .5,
                      width: MediaQuery.of(context).size.width * .9,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.6),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ДТ'),
                        Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              shape: CircleBorder(),
                              value: DT,
                              onChanged: (_) {
                                setState(() {
                                  DT = !DT;
                                });
                              }),
                        ),
                      ],
                    ),
                    Container(
                      height: .5,
                      width: MediaQuery.of(context).size.width * .9,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.6),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('АИ-92'),
                        Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              shape: CircleBorder(),
                              value: ai92,
                              onChanged: (_) {
                                setState(() {
                                  ai92 = !ai92;
                                });
                              }),
                        ),
                      ],
                    ),
                  ]),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 8),
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              ai95 = false;
                              DT = false;
                              ai92 = false;
                            });
                          },
                          child: Text(
                            "показать все",
                            style: Theme.of(context).textTheme.bodyMedium,
                          )),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 20),
                  child: Text(
                    "СЕРВИСЫ",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  // decoration: BoxDecoration(color: Colors.white),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Автомойка'),
                        Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              shape: CircleBorder(),
                              value: wash,
                              onChanged: (_) {
                                setState(() {
                                  wash = !wash;
                                });
                              }),
                        ),
                      ],
                    ),
                    Container(
                      height: .5,
                      width: MediaQuery.of(context).size.width * .9,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.6),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Шиномонтаж'),
                        Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              shape: CircleBorder(),
                              value: shini,
                              onChanged: (_) {
                                setState(() {
                                  shini = !shini;
                                });
                              }),
                        ),
                      ],
                    ),
                    Container(
                      height: .5,
                      width: MediaQuery.of(context).size.width * .9,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.6),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Кафе'),
                        Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              shape: CircleBorder(),
                              value: cafe,
                              onChanged: (_) {
                                setState(() {
                                  cafe = !cafe;
                                });
                              }),
                        ),
                      ],
                    ),
                    Container(
                      height: .5,
                      width: MediaQuery.of(context).size.width * .9,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.6),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Магазин'),
                        Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              shape: CircleBorder(),
                              value: store,
                              onChanged: (_) {
                                setState(() {
                                  store = !store;
                                });
                              }),
                        ),
                      ],
                    ),
                  ]),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
