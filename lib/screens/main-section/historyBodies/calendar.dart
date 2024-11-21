import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/wallet.dart';
import 'operations.dart';

// ignore: must_be_immutable
class CalendarHistoryBody extends StatefulWidget {
  VoidCallback setBody0;
  VoidCallback setBody1;
  VoidCallback setBody2;
  CalendarHistoryBody(
      {super.key, required this.setBody0, required this.setBody1, required this.setBody2});

  @override
  State<CalendarHistoryBody> createState() => _CalendarHistoryBodyState();
}

class _CalendarHistoryBodyState extends State<CalendarHistoryBody> {
  int deposit = 0;
  int points = 0;
  List liters = [];
  double sumLiters = 0;
  int availableBal = 0;
  int availableBon = 0;
  List<Widget> historyWidgets = [];

  Future<void> getData() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    String token = (await instance.getString('token'))!;
    Map<String, dynamic> balance = await getBalance(token);
    Map<String, dynamic> transactions = await getHistory(token);
    setState(() {
      deposit = balance['deposit'];
      points = balance['points'];
      liters = balance['liters'];
      availableBal = balance['available_deposit'];
      availableBon = balance['available_points'];
      for (var element in liters) {
        sumLiters += element['amount'];
      }
      transactions['transactions'].forEach((element) {
        historyWidgets.add(HistoryContainer(
            date: element['date'],
            addres: element['departmentId'],
            productName: element['goodsId'],
            points: element['addPoints'] - element['writeoffPoints'],
            quantity: element['quantity']));
        historyWidgets.add(const SizedBox(
          height: 10,
        ));
      });
    });
  }

  @override
  void initState() {
    print(14234);
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
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
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: GestureDetector(
                          onTap: widget.setBody0,
                          child: const Text(
                            "Список",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.chartPie,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Icon(
                            Icons.calendar_today,
                            color: Theme.of(context).primaryColor,
                          )
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
                child: ListView(children: historyWidgets)),
          ),
        ],
      ),
    );
  }
}
