// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gasoilt/api/wallet.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../themes/manager.dart';

const List<String> list = <String>[
  'рубли',
  'баллы',
];

class HousePage extends StatefulWidget {
  const HousePage({super.key});

  @override
  State<HousePage> createState() => _HousePageState();
}

class _HousePageState extends State<HousePage> {
  String dropdownValue2 = 'рубли';
  List<String> listGet = ['рубли'];
  String dropdownValue1 = list.first;
  List<String> fuelsList = [];
  final ScrollController _controller = ScrollController();
  dynamic deposit = 0;
  dynamic points = 0;
  List liters = [];
  dynamic sumLiters = 0;
  List litersWidgets = [];
  int burger = 0;
  int coffee = 0;
  int hotdog = 0;
  List goods = [];
  List<Widget> courses = [];
  String? dropDownFuel;
  late Timer timer;
  List<Widget> infoBlocksList = [];
  bool isLoading=true;

  Future<void> getData(bool isDark) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    String token = instance.getString('token')!;

    // Получение данных
    Map<String, dynamic> balance = await getBalance(token);
    Map<String, dynamic> transactions = await getHistory(token);
    Map<String, dynamic> validBonuses = await getValidBonuses(token);

    // Загрузка архивных бонусов
    String? archivedBonusesData = instance.getString('archivedBonuses');
    List<Map<String, dynamic>> archivedBonuses = archivedBonusesData != null
        ? List<Map<String, dynamic>>.from(json.decode(archivedBonusesData))
        : [];

    // Инициализация переменных
    double totalAddedPoints = 0.0;
    double totalSpentPoints = 0.0;
    double expiredPoints = 0.0;
    double balanceAmount = (balance['points'] ?? 0).toDouble();
    isLoading = true;

    DateTime now = DateTime.now();
    DateTime oneMonthAgo = now.subtract(Duration(days: 60));

    int transactionLimit = 100;
    int transactionCount = 0;

    for (var card in transactions['cards']) {
      for (var transaction in card['bonusTransactions']) {
        if (transactionCount >= transactionLimit) {
          break;
        }

        // Преобразование points к double
        double points = (transaction['points'] ?? 0).toDouble();
        DateTime transactionDate = DateTime.parse(transaction['date']);

        // Отбираем только транзакции за последний месяц
        if (transactionDate.isAfter(oneMonthAgo)) {
          if (transaction['docType'] == "AddPoints") {
            totalAddedPoints += points;
          } else if (transaction['docType'] == "WriteOffPoints" ||
              transaction['docType'] == "TransferPoints" ||
              transaction['docType'] == "ConvertPointsToMoney" ||
              transaction['docType'] == "ConvertPointsToFuel") {
            totalSpentPoints += points.abs();
          }
          transactionCount++;
        }
      }
    }

    // Вычисляем количество сгоревших баллов
    double calculatedPoints = totalAddedPoints - totalSpentPoints;
    expiredPoints = (calculatedPoints > balanceAmount)
        ? calculatedPoints - balanceAmount
        : 0.0;

    // Получаем бонусы за неделю и месяц
    double weekPoints = (validBonuses['data']?['week_points'] ?? 0).toDouble();
    double monthPoints = (validBonuses['data']?['month_points'] ?? 0).toDouble();

    // Проверка на истечение срока действия бонусов
    DateTime baseDate = DateTime(now.year, 1, 1);

    // Перебираем архив бонусов и проверяем их срок действия
    for (var bonus in archivedBonuses) {
      DateTime validUntil = DateTime.parse(bonus['valid']);

      if (validUntil.isBefore(now)) {
        // Бонус истек, добавляем его к сгоревшим баллам
        expiredPoints += (bonus['points'] as num).toDouble();
        // Убираем бонус из списка действующих (не сохраняем его в новый архив)
        archivedBonuses.remove(bonus);
      }
    }

    // Сохраняем обновленный архив бонусов в SharedPreferences
    await instance.setString('archivedBonuses', json.encode(archivedBonuses));

    // Обновление UI
    setState(() {
      isLoading = false;
      infoBlocksList = [
        InfoBlock(value: '$weekPoints', description: 'Доступно до конца недели', isDark: isDark),
        InfoBlock(value: '$monthPoints', description: 'Доступно до конца месяца', isDark: isDark),
        InfoBlock(value: '$expiredPoints', description: 'Сгорело за 60 дней', isDark: isDark),
      ];
    });
  }



  void startPeriodicDataUpdate(bool isDark) {
    Timer.periodic(Duration(seconds: 15), (Timer timer) async {
      await getData(isDark);
    });
  }


  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    bool isDark = Provider.of<DarkThemeProvider>(context, listen: false).darkTheme;
    getData(isDark);
    startPeriodicDataUpdate(isDark);
    //таймер нужен для автоматического обновления данных
    timer = Timer.periodic(const Duration(minutes: 10), (timer) async {

      SharedPreferences instance = await SharedPreferences.getInstance();
      // getMoneyCourse();
      String token = (instance.getString('token'))!;
      // goods = await getGoods(token);
      Map<String, dynamic> balance = await getBalance(token);
      sumLiters = 0.0;
      litersWidgets = [];
      deposit = 0.0;
      setState(() {
        deposit += balance['deposit'];
        points = balance['points'];
        liters = balance['liters'];
        burger = balance['burger'];
        coffee = balance['coffee'];
        hotdog = balance['hot-dog'];
        fuelsList = [];
        for (var element in liters) {
          sumLiters += element['amount'];
          fuelsList.add(element['name'] + ' - ${element['amount']}');
        }
        dropDownFuel = fuelsList.first;
        for (var element in liters) {
          litersWidgets.add(litersWidget(
              element['name'], element['amount'], sumLiters, context));
        }
      });
    });

    super.initState();
  }

  void changeList() async {
    // функция для смены списков топлива и ценников
    SharedPreferences instance = await SharedPreferences.getInstance();

    String token = instance.getString('token')!;
    listGet = [];
    fuelsList = [];
    goods = await getGoods(token);

    setState(() {});

    setState(() {
      if (dropdownValue1 != 'рубли') {
        //YI: take it off for points
        //listGet.add("рубли");
        for (var element in goods) {
          listGet.add(element['name']);
          fuelsList.add(element['name']);
        }
      } else {
        for (var element in goods) {
          listGet.add(element['name']);
          fuelsList.add(element['name']);
        }
      }
      dropdownValue2 = listGet.first;
    });

    double price = inputController.text.isNotEmpty
        ? double.parse(inputController.text)
        : 0.0;

    if (dropdownValue2 == "рубли") {
      price /= await getMoneyCourse(token);
    } else {
      Map good =
          goods.firstWhere((element) => element['name'] == dropdownValue2);
      if (dropdownValue1 == "баллы") {
        price /= await getFuelCourse(token, good['id']);
      } else {
        price /= await getFuelPrice(token, good['id'], 1);
      }
    }
    print(price);
    outputController.text = (price.toStringAsFixed(2)).toString();
  }

  String getDynamicDate(int daysOffset) {
    DateTime newDate = DateTime.now().add(Duration(days: daysOffset));
    return DateFormat('dd.MM').format(newDate);
  }

  TextEditingController inputController = TextEditingController();
  TextEditingController outputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<DarkThemeProvider>(context).darkTheme;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .65,
        child: isLoading
            ? Center(child: CircularProgressIndicator()) // Показываем прогресс-бар, если идет загрузка
            : ListView(
            controller: _controller,
            children: [
            /*Container(
                height: MediaQuery.of(context).size.height * .1,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF3e474c)
                      : const Color(0xffffffeb),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left:
                                    MediaQuery.of(context).size.width * .05),
                            child: SvgPicture.asset('icons/house/pocket.svg'),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .05,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Мой депозит",
                                style: TextStyle(fontSize: 17),
                              ),
                              Text(
                                "$deposit ₽",
                                style: const TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: mainButton(
                            MediaQuery.of(context).size.width * .29, 40.0,
                            () {
                          TextEditingController sumEditor =
                              TextEditingController();
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title:
                                      const Text("Введите сумму для оплаты"),
                                  content: SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height *
                                            .15,
                                    child: Column(
                                      children: [
                                        TextField(
                                            controller: sumEditor,
                                            keyboardType:
                                                TextInputType.number,
                                            decoration: const InputDecoration(
                                                hintText: "Введите сумму"),
                                            onSubmitted: (value) async {
                                              // print(123);
                                              SharedPreferences instance =
                                                  await SharedPreferences
                                                      .getInstance();
                                              String token = instance
                                                  .getString("token")!;
                                              String url = (await addMoney(
                                                  token,
                                                  value))['confirmation_url'];
                                              launchUrl(Uri.parse(url),
                                                  mode: LaunchMode
                                                      .externalApplication);
                                              Navigator.of(context).pop();
                                            }),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        mainButton(
                                            MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .8,
                                            40.0, () async {
                                          String value = sumEditor.text;
                                          SharedPreferences instance =
                                              await SharedPreferences
                                                  .getInstance();
                                          String token =
                                              instance.getString("token")!;
                                          String url = (await addMoney(token,
                                              value))['confirmation_url'];
                                          launchUrl(Uri.parse(url),
                                              mode: LaunchMode
                                                  .externalApplication);
                                          Navigator.of(context).pop();
                                        }, "Оплатить")
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }, "Пополнить балланс"),
                      )
                    ])),
            SizedBox(
              height: MediaQuery.of(context).size.height * .01,
            ),*/
            Container(
                height: MediaQuery.of(context).size.height * .1,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF383f43) : Colors.transparent,
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left:
                                    MediaQuery.of(context).size.width * .05),
                            child:
                                SvgPicture.asset('icons/house/diamond.svg'),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .05,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Мои баллы",
                                style: TextStyle(fontSize: 17),
                              ),
                              Text(
                                points.toString(),
                                style: const TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                      /*Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: mainButton(
                              MediaQuery.of(context).size.width * .3, 40.0,
                              () async {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => HomeScreen(
                                          initPage: 1,
                                        )));
                            // обмен баллами
                            // TextEditingController amountController =
                            //     TextEditingController();
                            // TextEditingController phoneController =
                            //     TextEditingController();
                            // var status = await Permission.contacts.status;
                            // if (status.isDenied) {
                            //   Permission.contacts.request();
                            // }
                            // status = await Permission.contacts.status;
                            // if (status.isDenied) {
                            //   return;
                            // }

                            // final contacts =
                            //     await FastContacts.getAllContacts();

                            // List<String> phones = [];
                            // contacts.forEach(
                            //   (element) {
                            //     try {
                            //       phones.add(element.phones[0].number);
                            //     } catch (_) {}
                            //   },
                            // );
                            // showDialog(
                            //     context: context,
                            //     builder: (
                            //       context,
                            //     ) =>
                            //         StatefulBuilder(
                            //             builder: (context, setStateSB) {
                            //           return AlertDialog(
                            //             title: const Text(
                            //                 "Введите данные для обмена баллами"),
                            //             content: SizedBox(
                            //               child: Column(
                            //                 mainAxisSize: MainAxisSize.min,
                            //                 children: [
                            //                   TextField(
                            //                     controller: amountController,
                            //                     keyboardType:
                            //                         TextInputType.number,
                            //                     decoration:
                            //                         const InputDecoration(
                            //                             hintText:
                            //                                 "Кол-во баллов"),
                            //                   ),
                            //                   const SizedBox(
                            //                     height: 30,
                            //                   ),
                            //                   Autocomplete(
                            //                     onSelected: (option) {
                            //                       phoneController.text =
                            //                           option as String;
                            //                     },
                            //                     fieldViewBuilder: (BuildContext
                            //                             context,
                            //                         TextEditingController
                            //                             fieldTextEditingController,
                            //                         FocusNode fieldFocusNode,
                            //                         VoidCallback
                            //                             onFieldSubmitted) {
                            //                       phoneController =
                            //                           fieldTextEditingController;
                            //                       return TextField(
                            //                         controller:
                            //                             fieldTextEditingController,
                            //                         focusNode: fieldFocusNode,
                            //                         style: const TextStyle(
                            //                             fontWeight:
                            //                                 FontWeight.bold),
                            //                       );
                            //                     },
                            //                     initialValue:
                            //                         TextEditingValue(
                            //                             text: "+7"),
                            //                     optionsBuilder:
                            //                         (TextEditingValue
                            //                             textEditingValue) {
                            //                       if (textEditingValue.text ==
                            //                           '') {
                            //                         return const Iterable<
                            //                             Contact>.empty();
                            //                       }
                            //                       return phones
                            //                           .where((option) {
                            //                         return option.contains(
                            //                             textEditingValue.text
                            //                                 .toLowerCase());
                            //                       });
                            //                     },
                            //                   ),
                            //                   const SizedBox(
                            //                     height: 30,
                            //                   ),
                            //                   mainButton(
                            //                       MediaQuery.of(context)
                            //                               .size
                            //                               .width *
                            //                           .5,
                            //                       40.0, () async {
                            //                     SharedPreferences instance =
                            //                         await SharedPreferences
                            //                             .getInstance();
                            //                     String token = instance
                            //                         .getString("token")!;
                            //                     Map result =
                            //                         await sharePoints(
                            //                             token,
                            //                             amountController.text,
                            //                             phoneController.text);
                            //                     if (result['error'] == null) {
                            //                       ScaffoldMessenger.of(
                            //                               context)
                            //                           .showSnackBar(
                            //                               const SnackBar(
                            //                                   content: Text(
                            //                                       "УСПЕШНО")));
                            //                     } else {
                            //                       ScaffoldMessenger.of(
                            //                               context)
                            //                           .showSnackBar(
                            //                               const SnackBar(
                            //                                   content: Text(
                            //                                       "НЕ ЗАРЕГЕСТРИРОВАН")));
                            //                     }
                            //                     Navigator.of(context).pop();
                            //                     getData();
                            //                     setState(() {});
                            //                   }, 'Обменять')
                            //                 ],
                            //               ),
                            //             ),
                            //           );
                            //         }));
                          }, "На что потратить"))*/
                    ])),
            SizedBox(
              height: MediaQuery.of(context).size.height * .01,
            ),
            Image.asset(
              'images/neftegazt-red.png',
              width: 100,
              height: 70,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .01,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var block in infoBlocksList) block,
                ],
              ),
            ),
            Image.asset(
              'images/logo.png'
            )
          ]),
    ));
  }
}

Widget InfoBlock({
  required String value,
  required String description,
  required bool isDark,
}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8), // Увеличение отступов для большей высоты
    constraints: BoxConstraints(
      minWidth: 80,
      maxWidth: 125,
    ),
    decoration: BoxDecoration(
      color: isDark ? Color(0xFF505050) : Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: isDark ? Colors.black54 : Colors.grey.withOpacity(0.2),
          blurRadius: 5,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28, // Увеличен размер шрифта для значения
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        SizedBox(height: 8), // Больший отступ между значением и описанием
        Text(
          description,
          textAlign: TextAlign.center,
          maxLines: 2, // Установка ограничения на количество строк для описания
          overflow: TextOverflow.ellipsis, // Указать обрезку, если текст слишком длинный
          style: TextStyle(
            fontSize: 16, // Чуть крупнее текст для лучшей читабельности
            color: isDark ? Colors.grey[300] : Colors.grey[700],
          ),
        ),
      ],
    ),
  );
}


Widget litersWidget(name, amount, max, context) {
  return Container(
      decoration: BoxDecoration(
          border: Border.symmetric(
              horizontal:
                  BorderSide(color: Colors.grey.withOpacity(.5), width: 1))),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * .2,
                child: Text(name)),
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .5,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.4),
                      borderRadius: BorderRadius.circular(20)),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .5 * amount / max,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                ),
              ],
            ),
            const SizedBox(
              width: 3,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * .15,
                child: Text(
                  amount.toStringAsFixed(2),
                )),
          ],
        ),
      ));
}

class SliverGridWithCustomGeometryLayout extends SliverGridRegularTileLayout {
  /// The builder for each child geometry.
  final SliverGridGeometry Function(
    int index,
    SliverGridRegularTileLayout layout,
  ) geometryBuilder;

  const SliverGridWithCustomGeometryLayout({
    required this.geometryBuilder,
    required super.crossAxisCount,
    required super.mainAxisStride,
    required super.crossAxisStride,
    required super.childMainAxisExtent,
    required super.childCrossAxisExtent,
    required super.reverseCrossAxis,
  })  : assert(crossAxisCount > 0),
        assert(mainAxisStride >= 0),
        assert(crossAxisStride >= 0),
        assert(childMainAxisExtent >= 0),
        assert(childCrossAxisExtent >= 0);

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    return geometryBuilder(index, this);
  }
}

class SliverGridDelegateWithFixedCrossAxisCountAndCentralizedLastElement
    extends SliverGridDelegateWithFixedCrossAxisCount {
  /// The total number of itens in the layout.
  final int itemCount;

  SliverGridDelegateWithFixedCrossAxisCountAndCentralizedLastElement({
    required this.itemCount,
    required super.crossAxisCount,
    super.mainAxisSpacing,
    super.crossAxisSpacing,
    super.childAspectRatio,
  })  : assert(itemCount > 0),
        assert(crossAxisCount > 0),
        assert(mainAxisSpacing >= 0),
        assert(crossAxisSpacing >= 0),
        assert(childAspectRatio > 0);

  bool _debugAssertIsValid() {
    assert(crossAxisCount > 0);
    assert(mainAxisSpacing >= 0.0);
    assert(crossAxisSpacing >= 0.0);
    assert(childAspectRatio > 0.0);
    return true;
  }

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    assert(_debugAssertIsValid());
    final usableCrossAxisExtent = max(
      0.0,
      constraints.crossAxisExtent - crossAxisSpacing * (crossAxisCount - 1),
    );
    final childCrossAxisExtent = usableCrossAxisExtent / crossAxisCount;
    final childMainAxisExtent = childCrossAxisExtent / childAspectRatio;
    return SliverGridWithCustomGeometryLayout(
      geometryBuilder: (index, layout) {
        return SliverGridGeometry(
          scrollOffset: (index ~/ crossAxisCount) * layout.mainAxisStride,
          crossAxisOffset: itemCount.isOdd && index == itemCount - 1
              ? layout.crossAxisStride / 2
              : _getOffsetFromStartInCrossAxis(index, layout),
          mainAxisExtent: childMainAxisExtent,
          crossAxisExtent: childCrossAxisExtent,
        );
      },
      crossAxisCount: crossAxisCount,
      mainAxisStride: childMainAxisExtent + mainAxisSpacing,
      crossAxisStride: childCrossAxisExtent + crossAxisSpacing,
      childMainAxisExtent: childMainAxisExtent,
      childCrossAxisExtent: childCrossAxisExtent,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  double _getOffsetFromStartInCrossAxis(
    int index,
    SliverGridRegularTileLayout layout,
  ) {
    final crossAxisStart = (index % crossAxisCount) * layout.crossAxisStride;

    if (layout.reverseCrossAxis) {
      return crossAxisCount * layout.crossAxisStride -
          crossAxisStart -
          layout.childCrossAxisExtent -
          (layout.crossAxisStride - layout.childCrossAxisExtent);
    }
    return crossAxisStart;
  }
}
