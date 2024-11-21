import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gasoilt/widgets/mainButton.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../themes/manager.dart';

// ignore: must_be_immutable
class PieChartBody extends StatefulWidget {
  VoidCallback setBody0;
  VoidCallback setBody1;
  VoidCallback setBody2;

  PieChartBody(
      {super.key, required this.setBody0, required this.setBody1, required this.setBody2});

  @override
  State<PieChartBody> createState() => _PieChartBodyState();
}

class _PieChartBodyState extends State<PieChartBody> {
  bool dep = true;
  bool points = true;
  bool liters = true;
  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<DarkThemeProvider>(context).darkTheme;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: widget.setBody1,
                          child: FaIcon(
                            FontAwesomeIcons.chartPie,
                            color: Theme.of(context).primaryColor,
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: mainButton(
                                MediaQuery.of(context).size.width * .3,
                                30.0,
                                widget.setBody0,
                                "Список",
                                null, null,
                                Colors.grey),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                              // onTap: widget.setBody2,
                              child: const Icon(Icons.calendar_today))
                        ],
                      )
                    ]),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 2,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
                height: MediaQuery.of(context).size.height * .67,
                child: ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width * .5,
                      color: isDark ? const Color(0xFF383f43) : Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Мой депозит",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    dep = true;
                                  });
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: dep
                                                ? Theme.of(context).primaryColor
                                                : Colors.grey)),
                                    child: const Text(
                                      "Расходы",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    dep = false;
                                  });
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: !dep
                                                ? Theme.of(context).primaryColor
                                                : Colors.grey)),
                                    child: const Text(
                                      "Поступления",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Stack(
                            children: [
                              SfCircularChart(
                                  palette: const [
                                    Color(0xffff3f6d),
                                    Color(0xffff993f),
                                    Color(0xffa564d8),
                                    Color(0xff2f82e3)
                                  ],
                                  borderWidth: 20,
                                  // tooltipBehavior: TooltipBehavior(enable: true),
                                  legend:  Legend(
                                    isResponsive: false,
                                    overflowMode: LegendItemOverflowMode.wrap,
                                    isVisible: true,
                                    position: LegendPosition.bottom,
                                    // height: "1000",
                                    iconWidth: 30,
                                  ),
                                  annotations: <CircularChartAnnotation>[
                                    CircularChartAnnotation(
                                        widget: Container(
                                            // color: Colors.black,
                                            margin: const EdgeInsets.all(20),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    dep
                                                        ? 'Расходы'
                                                        : "Поступления",
                                                    style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 0.5),
                                                    )),
                                                const Text('0₽',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            )))
                                  ],
                                  series: [
                                    DoughnutSeries<ChartData, String>(
                                        animationDuration: .01,
                                        innerRadius:
                                            (MediaQuery.of(context).size.width *
                                                    .25)
                                                .toString(),
                                        enableTooltip: true,
                                        dataSource: [
                                          // Bind data source
                                          ChartData('Топливо 0₽', 0),
                                          ChartData('Магазин 0₽', 0),
                                          // ChartData('Кафе 0₽', 0),
                                          ChartData('Сервис 0₽', 0),
                                        ],
                                        xValueMapper: (ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData data, _) =>
                                            data.y),
                                  ]),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    color: Colors.transparent,
                                    width:
                                        MediaQuery.of(context).size.width * .8,
                                    height: 100,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width * .5,
                      color: isDark ? const Color(0xFF383f43) : Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Мои баллы",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    points = true;
                                  });
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: points
                                                ? Theme.of(context).primaryColor
                                                : Colors.grey)),
                                    child: const Text(
                                      "Расходы",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    points = false;
                                  });
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: !points
                                                ? Theme.of(context).primaryColor
                                                : Colors.grey)),
                                    child: const Text(
                                      "Поступления",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Stack(
                            children: [
                              SfCircularChart(
                                  palette: const [
                                    Color(0xffff3f6d),
                                    Color(0xffa564d8),
                                    Color(0xff48d15d)
                                  ],
                                  borderWidth: 20,
                                  tooltipBehavior:
                                      TooltipBehavior(enable: true),
                                  legend:  Legend(
                                    isResponsive: false,
                                    overflowMode: LegendItemOverflowMode.wrap,
                                    isVisible: true,
                                    position: LegendPosition.bottom,
                                    // height: "1000",

                                    iconWidth: 30,
                                  ),
                                  annotations: <CircularChartAnnotation>[
                                    CircularChartAnnotation(
                                        widget: Container(
                                            // color: Colors.black,
                                            margin: const EdgeInsets.all(20),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    points
                                                        ? 'Расходы'
                                                        : "Поступления",
                                                    style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 0.5),
                                                    )),
                                                const Text('0 баллов',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            )))
                                  ],
                                  series: [
                                    DoughnutSeries<ChartData, String>(
                                        animationDuration: .01,
                                        innerRadius:
                                            (MediaQuery.of(context).size.width *
                                                    .25)
                                                .toString(),
                                        enableTooltip: true,
                                        dataSource: [
                                          // Bind data source
                                          ChartData('Топливо 0 баллов', 0),
                                          ChartData('Магазин 0 баллов', 0),
                                          ChartData('Перевод 0 баллов', 0),
                                        ],
                                        xValueMapper: (ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData data, _) =>
                                            data.y),
                                  ]),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    color: Colors.transparent,
                                    width:
                                        MediaQuery.of(context).size.width * .8,
                                    height: 100,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width * .5,
                      color: isDark ? const Color(0xFF383f43) : Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Мои литры",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    liters = true;
                                  });
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: liters
                                                ? Theme.of(context).primaryColor
                                                : Colors.grey)),
                                    child: const Text(
                                      "Расходы",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    liters = false;
                                  });
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: !liters
                                                ? Theme.of(context).primaryColor
                                                : Colors.grey)),
                                    child: const Text(
                                      "Поступления",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Stack(
                            children: [
                              SfCircularChart(
                                  palette: const [
                                    Color(0xffff3f6d),
                                    Color(0xffff993f),
                                    Color(0xffa564d8),
                                    Color(0xff2f82e3)
                                  ],
                                  borderWidth: 20,
                                  tooltipBehavior:
                                      TooltipBehavior(enable: true),
                                  legend:  Legend(
                                    isResponsive: false,
                                    overflowMode: LegendItemOverflowMode.wrap,
                                    isVisible: true,
                                    position: LegendPosition.bottom,
                                    // height: "1000",

                                    iconWidth: 30,
                                  ),
                                  annotations: <CircularChartAnnotation>[
                                    CircularChartAnnotation(
                                        widget: Container(
                                            // color: Colors.black,
                                            margin: const EdgeInsets.all(20),
                                            child: const Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('Литры',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 0.5),
                                                    )),
                                                Text('0',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            )))
                                  ],
                                  series: [
                                    DoughnutSeries<ChartData, String>(
                                        animationDuration: .01,
                                        innerRadius:
                                            (MediaQuery.of(context).size.width *
                                                    .25)
                                                .toString(),
                                        enableTooltip: true,
                                        dataSource: [
                                          // Bind data source
                                          ChartData('АИ-95 0₽', 0),
                                          ChartData('ДТ 0₽', 0),
                                          ChartData('АИ-92 0₽', 0),
                                          ChartData('Перевод 0₽', 0),
                                        ],
                                        xValueMapper: (ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData data, _) =>
                                            data.y),
                                  ]),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    color: Colors.transparent,
                                    width:
                                        MediaQuery.of(context).size.width * .8,
                                    height: 100,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color = Colors.black]);
  final String x;
  final double y;
  final Color color;
}
