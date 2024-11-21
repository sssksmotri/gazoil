import 'package:flutter/material.dart';
import 'package:gasoilt/screens/main-section/historypage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../../../api/wallet.dart';
import '../../../themes/manager.dart';

// ignore: must_be_immutable
class OperationsHistoryBody extends StatefulWidget {
  VoidCallback setBody0;
  VoidCallback setBody1;
  VoidCallback setBody2;
  OperationsHistoryBody(
      {super.key,
      required this.setBody0,
      required this.setBody1,
      required this.setBody2});

  @override
  State<OperationsHistoryBody> createState() => _OperationsHistoryBodyState();
}

class _OperationsHistoryBodyState extends State<OperationsHistoryBody> {
  dynamic deposit = 0;
  dynamic points = 0;
  List liters = [];
  double sumLiters = 0;
  dynamic availableBal = 0;
  dynamic availableBon = 0;
  List<Widget> historyWidgets = [];
  bool isBurned = false;
  bool isLoading = true;

  Future<void> getData() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    String token = (instance.getString('token'))!;

    Map<String, dynamic> balance = await getBalance(token);
    Map<String, dynamic> transactions = await getHistory(token);
    Map<String, dynamic> validBonuses = await getValidBonuses(token);

    Map<String, String> productName = {
      "AddPoints": "Начисление",
      "WriteOffPoints": "Списание баллов",
      "ConvertPointsToMoney": "Конвертация в деньги",
      "ConvertPointsToFuel": "Конвертация в топливо",
      "TransferPoints": "Перевод баллов"
    };

    setState(() {
      deposit = balance['deposit'];
      points = balance['points'];
      availableBal = balance['available_deposit'];
      availableBon = balance['available_points'];
      historyWidgets.clear();
      DateTime now = DateTime.now();
      isLoading = false;
      String? archivedBonusesData = instance.getString('archivedBonuses');
      List<Map<String, dynamic>> archivedBonuses = archivedBonusesData != null
          ? List<Map<String, dynamic>>.from(json.decode(archivedBonusesData))
          : [];


      if (validBonuses.containsKey('data')) {
        Map<String, dynamic> data = validBonuses['data'];

        List<Map<String, dynamic>> currentBonuses = [];


        if (data.containsKey('week_points') && data.containsKey('week_date')) {
          currentBonuses.add({
            'points': data['week_points'],
            'valid': DateTime.parse(data['week_date']).toIso8601String(),
            'usedPoints': 0,
          });
        }


        if (data.containsKey('month_points') &&
            data.containsKey('month_date')) {
          currentBonuses.add({
            'points': data['month_points'],
            'valid': DateTime.parse(data['month_date']).toIso8601String(),
            'usedPoints': 0,
          });
        }


        archivedBonuses.addAll(currentBonuses);
        instance.setString('archivedBonuses', json.encode(archivedBonuses));
      }


      for (var element in transactions['cards'][0]['bonusTransactions']) {
        DateTime date = DateTime.parse(element['date']);
        String formattedDate = DateFormat('dd/MM/yy kk:mm').format(date);
        int points = element['points'];
        String transactionType = productName[element['docType']] ??
            "Неизвестно";


        if (element['docType'] == "AddPoints") {
          historyWidgets.add(HistoryItem(
            date: formattedDate,
            productName: transactionType,
            points: points,
            money: 0,
            quantity: '+${points} баллов',
          ));
          historyWidgets.add(const SizedBox(height: 10));
        }


        else if (element['docType'] == "WriteOffPoints") {
          int pointsSpent = points;


          for (var bonus in archivedBonuses) {
            if (pointsSpent <= 0) break;
            int availableBonus = bonus['points'] - bonus['usedPoints'];

            if (availableBonus > 0) {
              int deduction = pointsSpent > availableBonus
                  ? availableBonus
                  : pointsSpent;
              bonus['usedPoints'] += deduction;
              pointsSpent -= deduction;
            }
          }


          historyWidgets.add(HistoryItem(
            date: formattedDate,
            productName: transactionType,
            points: -points,
            money: 0,
            quantity: '-${points} баллов',
          ));
          historyWidgets.add(const SizedBox(height: 10));
        }
      }


      for (var bonus in archivedBonuses) {
        int remainingPoints = bonus['points'] - bonus['usedPoints'];
        DateTime validUntil = DateTime.parse(bonus['valid']);

        if (validUntil.isBefore(now) && remainingPoints > 0) {
          String burnDate = DateFormat('dd/MM/yy kk:mm').format(validUntil);
          historyWidgets.add(HistoryItem(
            date: burnDate,
            productName: "Сгоревшие баллы",
            points: -remainingPoints,
            money: 0,
            quantity: '-${remainingPoints} баллов',
            isBurned: true,
          ));
          bonus['points'] = bonus['usedPoints'];
          historyWidgets.add(const SizedBox(height: 10));
        }
      }


      instance.setString('archivedBonuses', json.encode(archivedBonuses));
    });
  }


  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height * .7,
            child: ListView(
              children: [
                if (isLoading) // Если данные еще загружаются, показываем прогресс-бар
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ...historyWidgets.reversed, // Показываем данные
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class HistoryItem extends StatelessWidget {
  String date;
  String productName;
  var money;
  var quantity;
  var points;
  bool isBurned;
  HistoryItem(
      {super.key,
      required this.date,
      required this.productName,
      required this.points,
      required this.money,
      required this.quantity,
        this.isBurned = false});

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<DarkThemeProvider>(context).darkTheme;

    return Container(
      padding: const EdgeInsets.only(left: 10, bottom: 10),
      decoration:
      BoxDecoration(color: isDark ? const Color(0xFF343c40) : Colors.white),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: pointsContainer(points, isDark, isBurned:isBurned),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomLeft,  // Выравнивание даты в левый нижний угол
            child: Text(
              date,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class HistoryContainer extends StatelessWidget {
  String date;
  String addres;
  String productName;

  var quantity;
  var points;

  HistoryContainer(
      {super.key,
      required this.date,
      required this.addres,
      required this.productName,
      required this.points,
      required this.quantity});

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<DarkThemeProvider>(context).darkTheme;

    return Container(
      padding: const EdgeInsets.only(left: 10, bottom: 10),
      decoration:
          BoxDecoration(color: isDark ? const Color(0xFF343c40) : Colors.white),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: Text(
                      addres,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: pointsContainer(points, isDark),
              ),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                "=${quantity.toString()}₽",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            )
          ]),
          // SizedBox(
          //   height: 10,
          // ),
          // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          //   Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       SizedBox(
          //         width: MediaQuery.of(context).size.width * .7,
          //         child: Text(
          //           "Сосиска в тесте",
          //           style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          //   Padding(
          //     padding: const EdgeInsets.only(right: 10),
          //     child: Text(
          //       "=910.25₽",
          //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          //     ),
          //   )
          // ])
        ],
      ),
    );
  }
}
