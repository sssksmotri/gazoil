import 'package:flutter/material.dart';
import 'package:gasoilt/api/cars.dart';
import 'package:gasoilt/screens/main-section/actions/edit-car.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../themes/manager.dart';
import 'dart:math' as math;

List<dynamic> listOfPetrols = [
  {"id": 0, "name": "нет", "code": "None"}
];

class LkAuto extends StatefulWidget {
  const LkAuto({super.key});

  @override
  State<LkAuto> createState() => _LkAutoState();
}

class _LkAutoState extends State<LkAuto> {
  List autos = [];

  Future getData() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    String token = instance.getString('token')!;
    List cars = (await myCars(token))["cars"];
    print((await myCars(token))["cars"]);
    listOfPetrols = await petrols(token);
    for (var car in cars) {
      autos.add(
        CarContainer(
          brand: car['brand']['name'],
          model: car['model']['name'],
          num: car['num'] ?? "Не указан",
          color: car['color'] ?? "Не указан",
          additional: car['additional'],
        ),
      );
    }

    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<DarkThemeProvider>(context).darkTheme;
    int petrolValue = 0;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: MediaQuery.of(context).size.height * .1,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: !isDark
                  ? [const Color(0xffcbffd6), const Color(0xffcaffa0)]
                  : [const Color(0xff0d4b29), const Color(0xff0a8467)],
              stops: const [0, 1],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.end, children: [
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
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                const Text(
                  "МОИ АВТО",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CircleAvatar(
                      radius: (30),
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset("images/personal-car.png"),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                ...autos,
                const SizedBox(
                  height: 20,
                ),
                // Center(
                //   child: GestureDetector(
                //     onTap: () {},
                //     child: Icon(
                //       Icons.add,
                //       color: Colors.grey,
                //     ),
                //   ),
                // ),
                const Text(
                  "МОЕ ТОПЛИВО",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButton<String>(
                  icon: const Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: Colors.grey,
                  ),
        
                  value: listOfPetrols[petrolValue][
                      'name'], // this place should not have a controller but a variable
                  onChanged: (value) {
                    setState(() {
                      petrolValue = listOfPetrols.firstWhere(
                        (element) => element['name'] == value,
                      );
                    });
                  },
                  items: listOfPetrols
                      .map<DropdownMenuItem<String>>((var value) =>
                          DropdownMenuItem<String>(
                              value: value[
                                  'name'], // add this property an pass the _value to it
                              child: Text(
                                value['name'],
                              )))
                      .toList(),
                ),
                // Container(
                //   child: Stack(
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.symmetric(vertical: 13.0),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text(
                //               petrol,
                //               style: TextStyle(color: Colors.grey),
                //             ),
                //             Icon(
                //               Icons.keyboard_arrow_down_outlined,
                //               color: Colors.grey,
                //             )
                //           ],
                //         ),
                //       ),
                //       Positioned.fill(
                //         child: Align(
                //           alignment: Alignment.bottomCenter,
                //           child: Container(
                //             height: 2,
                //             width: MediaQuery.of(context).size.width * .9,
                //             decoration: BoxDecoration(
                //                 color: Colors.grey.withOpacity(.1),
                //                 borderRadius: BorderRadius.circular(20)),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                EditCarPage(isEdit: false)));
                      },
                      child: Text(
                        "Добавить авто",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .apply(color: Colors.white),
                      )),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}

// ignore: must_be_immutable
class CarContainer extends StatelessWidget {
  String model;
  String color;
  List? additional;
  String brand;
  String num;
  CarContainer(
      {super.key,
      required this.model,
      required this.color,
      this.additional,
      required this.num,
      required this.brand});

  @override
  Widget build(BuildContext context) {
    List<Widget> additionals = [];
    if (additional != null) {
      for (var element in additional!) {
        additionals.add(
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 13.0),
                child: Text(element['value']
                    // style: TextStyle(color: Colors.black),
                    ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 2,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.1),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 13.0),
              child: Text(
                brand,
                // style: TextStyle(color: Colors.black),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 2,
                  width: MediaQuery.of(context).size.width * .9,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.1),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 13.0),
              child: Text(
                model,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 2,
                  width: MediaQuery.of(context).size.width * .9,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.1),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 13.0),
              child: Text(
                "Цвет машины: $color",
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 2,
                  width: MediaQuery.of(context).size.width * .9,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.1),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 13.0),
              child: Text(
                "Номер машины: $num",
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 2,
                  width: MediaQuery.of(context).size.width * .9,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.1),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        // Container(
        //   child: Stack(
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.symmetric(vertical: 13.0),
        //         child: Text(
        //           'Коробка передач',
        //           style: TextStyle(color: Colors.grey),
        //         ),
        //       ),
        //       Positioned.fill(
        //         child: Align(
        //           alignment: Alignment.bottomCenter,
        //           child: Container(
        //             height: 3,
        //             width: MediaQuery.of(context).size.width * .9,
        //             decoration: BoxDecoration(
        //                 color: Colors.grey.withOpacity(.1),
        //                 borderRadius: BorderRadius.circular(20)),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        ...additionals
      ],
    );
  }
}
