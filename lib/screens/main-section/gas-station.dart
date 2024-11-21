import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../themes/manager.dart';
import '../../widgets/mainButton.dart';
import 'dart:math' as math;

// всплывающий экран с данными об АЗС
// ignore: must_be_immutable
class GasStation extends StatefulWidget {
  DraggableScrollableController controller;
  String text;
  String addres;
  ScrollController lcontroller;
  VoidCallback buildRoute;
  GasStation(
      {super.key, required this.controller,
      required this.text,
      required this.addres,
      required this.lcontroller,
      required this.buildRoute});

  @override
  State<GasStation> createState() => _GasStationState();
}

class _GasStationState extends State<GasStation> {
  bool isAppBar = false;
  void _onScroll() {
    final offset = widget.controller.size;
    if (offset >= 0.9) {
      setState(() {
        isAppBar = true;
      });
    } else {
      setState(() {
        isAppBar = false;
      });
    }
  }

  @override
  void initState() {
    widget.controller.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<DarkThemeProvider>(context).darkTheme;

    return Scaffold(
      appBar: isAppBar
          ? AppBar(
              actions: const [],
              leading: Transform.rotate(
                angle: 180 * math.pi / 180,
                child: IconButton(
                  icon: const Icon(Icons.arrow_right_alt,
                      color: Colors.black, size: 30),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              flexibleSpace: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                colors: !isDark
                    ? [const Color(0xffcbffd6), const Color(0xffcaffa0)]
                    : [const Color(0xff0d4b29), const Color(0xff0a8467)],
                stops: const [0, 1],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ))),
            )
          : null,
      body: GestureDetector(
        child: Material(
          child: GestureDetector(
            child: Container(
              color: isDark ? const Color(0xff2d3337) : Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: ListView(
                  controller: widget.lcontroller,
                  children: [
                    mainButton(MediaQuery.of(context).size.width * .4, 50.0,
                        widget.buildRoute, "Построить маршрут"),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.text,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.addres,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        children: [
                          SvgPicture.asset('icons/AZS-car.svg'),
                          const SizedBox(
                            width: 25,
                          ),
                          SvgPicture.asset('icons/AZS-market.svg'),
                          const SizedBox(
                            width: 25,
                          ),
                          SvgPicture.asset('icons/AZS-cafe.svg'),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.lightBlue)),
                            child: const Text('95 | 42.30'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.blue)),
                            child: const Text('95 | 42.30'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.orange)),
                            child: const Text('95 | 42.30'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.yellowAccent)),
                            child: const Text('95 | 42.30'),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset('images/AZS.png'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Сервисы",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: isDark
                            ? const Color(0xff3e474c)
                            : Colors.grey.withOpacity(.1),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset('icons/AZS-car.svg', height: 44),
                          const SizedBox(
                            width: 30,
                          ),
                          
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .66,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Автомойка",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Оплати мойку машины с помощью бонусов 💥",
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                mainButton(
                                    MediaQuery.of(context).size.width * .4,
                                    33.0,
                                    () {},
                                    "Бронировать")
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
