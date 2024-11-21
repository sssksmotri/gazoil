import 'package:flutter/material.dart';
import 'package:gasoilt/api/map.dart';
import 'package:gasoilt/screens/main-section/gas-station.dart';
import 'package:gasoilt/themes/manager.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class GazStationModel {
  final String name;
  final String address;

  GazStationModel({required this.name, required this.address});
}

class AZSList extends StatefulWidget {
  const AZSList({super.key});

  @override
  State<AZSList> createState() => _AZSListState();
}

class _AZSListState extends State<AZSList> {
  List<GazStationModel> gazStations = [];

  
  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    List data = (await mapList())['AzsList'];

    for (var azs in data) {
      gazStations
          .add(GazStationModel(name: azs['name'], address: azs['addres']));
    }

    setState(() {});
  }

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
                ? [const Color(0xffcbffd6), const Color(0xffcaffa0)]
                : [const Color(0xff0d4b29), const Color(0xff0a8467)],
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
                        'Список АЗС',
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
        ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gazStations[index].name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 46,
                          child: Text(
                          gazStations[index].address,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            
                          ),
                          maxLines: 2,
                          
                        ),
                      )
                    ],
                  ),
                  const Icon(
                    Icons.keyboard_arrow_right,
                    size: 30,
                    color: Colors.grey,
                  )
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: gazStations.length,
        )
      ]),
    ));
  }
}
