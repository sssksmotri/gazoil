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
  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 0;
  final ScrollController _scrollController = ScrollController();
  final Set<String> processedTransactionIds = <String>{};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    getData();
  }


  Future<void> getData({int page = 0}) async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    print("Запрос данных для страницы: $page");

    try {
      SharedPreferences instance = await SharedPreferences.getInstance();
      String token = (instance.getString('token'))!;

      Map<String, String> productName = {
        "AddPoints": "Начисление",
        "WriteOffPoints": "Списание баллов",
        "ConvertPointsToMoney": "Конвертация в деньги",
        "ConvertPointsToFuel": "Конвертация",
        "TransferPoints": "Перевод баллов"
      };

      Map<String, dynamic> transactions = await getHistory(token, page: page);

      if (transactions['cards'][0]['bonusTransactions'].isEmpty) {
        setState(() {
          hasMore = false;
        });
      } else {
        List<Map<String, dynamic>> newHistoryWidgets = [];


        String? archivedBonusesData = instance.getString('archivedBonuses');
        List<Map<String, dynamic>> archivedBonuses = archivedBonusesData != null
            ? List<Map<String, dynamic>>.from(json.decode(archivedBonusesData))
            : [];

        for (var element in transactions['cards'][0]['bonusTransactions']) {
          String transactionId = element['id'];
          if (processedTransactionIds.contains(transactionId)) {
            continue;
          }
          processedTransactionIds.add(transactionId);

          DateTime date = DateTime.parse(element['date']);
          double points = (element['points'] as num).toDouble();
          String transactionType = productName[element['docType']] ?? "Неизвестно";

          newHistoryWidgets.add(
            {
              "widget": HistoryItem(
                date: DateFormat('dd/MM/yy kk:mm').format(date),
                productName: transactionType,
                points: points,
                money: 0,
                quantity: element['docType'] == "AddPoints"
                    ? '+${points} баллов'
                    : '-${points} баллов',
              ),
              "date": date,
            },
          );
        }

        newHistoryWidgets.sort((a, b) => (b['date'] as DateTime).compareTo(a['date']));
        final sortedWidgets = newHistoryWidgets.map((e) => e['widget'] as Widget).toList();


        setState(() {
          historyWidgets.addAll(sortedWidgets);
          currentPage++;
        });
      }
    } catch (e) {
      print("Ошибка при загрузке данных: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }



  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !isLoading &&
        hasMore) {
      getData(page: currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: historyWidgets.length + (isLoading && hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == historyWidgets.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                return historyWidgets[index];
              },
            ),
          ),
          if (!isLoading && historyWidgets.isEmpty)
            const Center(child: Text("Нет данных для отображения")),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
