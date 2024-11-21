
import 'package:flutter/material.dart';
import 'package:gasoilt/api/cars.dart';
import 'package:gasoilt/widgets/mainButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class EditCarPage extends StatefulWidget {
  bool isEdit;
  EditCarPage({super.key, required this.isEdit});

  @override
  State<EditCarPage> createState() => _EditCarPageState();
}

var list = ["hello, world", "how are you", "goodbye"];
List<dynamic> listOfColors = [
  {"id": 0, "name": "string", "code": "string"}
];
List<dynamic> listOfOils = [
  {"id": 0, "name": "string", "code": "string"}
];
List<dynamic> listOfPetrols = [
  {"id": 0, "name": "string", "code": "string"}
];
List<dynamic> listOfBrands = [
  {"id": 1, "name": "string", "code": "string"},
  {"id": 2, "name": "something", "code": "123"}
];

class _EditCarPageState extends State<EditCarPage> {
  List<Widget> carsWidgets = [];

  Future<void> getData() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    String token = instance.getString('token')!;
    listOfColors = await colors(token);
    listOfOils = await oils(token);
    listOfPetrols = await petrols(token);
    List tmp = await brands(token);
    listOfBrands = [];
    for (var item in tmp) {
      if (listOfBrands.any((e) => e['name'] == item['name'])) {
        continue;
      }
      listOfBrands.add(item);
    }
    print(listOfPetrols);
    Map cars = await myCars(token);
    (cars['cars'] as List).forEach(((element) {
      carsWidgets.add(AddCarWidget(
        carId: element['id'],
        brandId: element['brand']['id'],
        modelId: element['model']['id'],
        color: element['color'],
        num: element['num'],
        petrolId: listOfPetrols
            .indexWhere((el) => el['name'] == element['petrol']['name']),
      ));
    }));
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                  "Добавление машины",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                ...carsWidgets,
                Center(
                  child: mainButton(
                      MediaQuery.of(context).size.width * .8, 40.0, () async {
                    if (carsWidgets.length < 5) {
                      carsWidgets.add(AddCarWidget());
                      setState(() {});
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Вы можете добавить максимум 5 машин!"),
                      ));
                    }
                  }, 'Добавить машину'),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: mainButton(
                      MediaQuery.of(context).size.width * .8, 40.0, () async {
                    SharedPreferences instance =
                        await SharedPreferences.getInstance();
                    String token = instance.getString('token')!;
                    for (var element in carsWidgets) {
                      Map data = (element as AddCarWidget).retreiveData();
                      print(data);
                      if (data['id'] == null) {
                        addCar(token, data['brand'], data['model'], data['num'],
                            data['color'], listOfPetrols[data['petrol']]);
                        print("car added: $data");
                      } else {
                        editCar(
                            token,
                            data['id'],
                            data['brand'],
                            data['model'],
                            data['num'],
                            data['color'],
                            listOfPetrols[data['petrol']]);
                      }
                    }
                  }, 'Сохранить'),
                )
              ],
            )),
      ),
    );
  }
}

// ignore: must_be_immutable
class AddCarWidget extends StatefulWidget {
  int? brandId;
  String? num;
  String? color;
  int? petrolId;
  int? carId;
  int? modelId;
  AddCarWidget(
      {super.key,
      this.carId,
      this.brandId,
      this.modelId,
      this.num,
      this.color,
      this.petrolId});

  @override
  State<AddCarWidget> createState() => _AddCarWidgetState();

  Map retreiveData() {
    return {
      'id': carId,
      'brand': brandId,
      'num': num,
      'color': color,
      'petrol': petrolId,
      'model': modelId
    };
  }
}

class _AddCarWidgetState extends State<AddCarWidget> {
  TextEditingController colorController = TextEditingController();

  TextEditingController numController = TextEditingController();

  String dropDownValue = list.first;
  int petrolValue = 0;
  int brandValue = 0;

  List<dynamic> listOfModels = [
    {"id": 1, "name": "string", "code": "string"},
    {"id": 2, "name": "something", "code": "123"}
  ];

  Future getData() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    String token = instance.getString('token')!;
    List tmp = (await models(
        token,
        listOfBrands
            .firstWhere((element) => element['id'] == brandValue)['id']));
    listOfModels = [];
    for (var item in tmp) {
      if (listOfModels.any((e) => e['name'] == item['name'])) {
        continue;
      }
      listOfModels.add(item);
    }
    print(brandValue);
    print(listOfModels);
    print(widget.modelId);
    try {
      if (listOfModels.isNotEmpty) {
        widget.modelId = listOfModels
            .firstWhere((element) => element['id'] == widget.modelId)['id'];
      }
    } catch (_) {
      widget.modelId = listOfModels[0]['id'];
    }
    setState(() {});
  }

  @override
  void initState() {
    brandValue = widget.brandId ?? 1;
    numController.text = widget.num ?? '';
    colorController.text = widget.color ?? '';
    petrolValue = widget.petrolId ?? 0;
    widget.brandId = widget.brandId ?? 1;
    widget.petrolId = widget.petrolId ?? 0;
    widget.modelId = widget.modelId ?? 1;

    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.modelId);
    print(listOfModels);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("Марка машины:"),
      DropdownButton<String>(
        value: listOfBrands
                .firstWhere((element) => element['id'] == brandValue)[
            'name'], // this place should not have a controller but a variable
        onChanged: (value) {
          setState(() {
            brandValue = listOfBrands.firstWhere(
              (element) => element['name'] == value,
            )['id'];
            widget.brandId = listOfBrands.firstWhere(
              (element) => element['name'] == value,
            )['id'];
            getData();
          });
        },
        items: listOfBrands
            .map<DropdownMenuItem<String>>(
                (var value) => DropdownMenuItem<String>(
                    value: value['name'],
                    child: Text(
                      value['name'],
                    )))
            .toList(),
      ),
      const SizedBox(
        height: 20,
      ),
      const Text("Модель:"),
      DropdownButton<String>(
        value: listOfModels
                .firstWhere((element) => widget.modelId == element['id'])[
            'name'], // this place should not have a controller but a variable
        onChanged: (value) {
          setState(() {
            widget.modelId = listOfModels.firstWhere(
              (element) => element['name'] == value,
            )['id'];
          });
        },
        items: listOfModels
            .map<DropdownMenuItem<String>>((value) => DropdownMenuItem<String>(
                value: value[
                    'name'], // add this property an pass the _value to it
                child: Text(
                  value['name'],
                )))
            .toList(),
      ),
      const SizedBox(
        height: 20,
      ),
      const Text("Номер машины:"),
      TextField(
        controller: numController,
        onChanged: (value) => widget.num = value,
      ),
      const SizedBox(
        height: 20,
      ),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
      //   children: [
      //     Text("Цвет машины:"),
      //     DropdownButton<String>(
      //       value: listOfColors[colorValue][
      //           'name'], // this place should not have a controller but a variable
      //       onChanged: (_value) {
      //         setState(() {
      //           colorValue = listOfColors.firstWhere(
      //             (element) => element['name'] == _value,
      //           );
      //           ;
      //         });
      //       },
      //       items: listOfColors
      //           .map<DropdownMenuItem<String>>((var _value) =>
      //               DropdownMenuItem<String>(
      //                   value: _value[
      //                       'name'], // add this property an pass the _value to it
      //                   child: Text(
      //                     _value['name'],
      //                   )))
      //           .toList(),
      //     ),
      //   ],
      // ),
      const Text("Цвет машины:"),
      TextField(
        controller: colorController,
        onChanged: (value) => widget.color = value,
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text("Топливо машины:"),
          DropdownButton<String>(
            value: listOfPetrols[petrolValue][
                'name'], // this place should not have a controller but a variable
            onChanged: (value) {
              setState(() {
                petrolValue = listOfPetrols.indexWhere(
                  (element) => element['name'] == value,
                );
                widget.petrolId = listOfPetrols.indexWhere(
                  (element) => element['name'] == value,
                );
                print(petrolValue);
              });
            },
            items: listOfPetrols
                .map<DropdownMenuItem<String>>((var value) => DropdownMenuItem<
                        String>(
                    value: value[
                        'name'], // add this property an pass the _value to it
                    child: Text(
                      value['name'],
                    )))
                .toList(),
          ),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
      //   children: [
      //     Text("Масло машины:"),
      //     DropdownButton<String>(
      //       value: listOfOils[oilValue][
      //           'name'], // this place should not have a controller but a variable
      //       onChanged: (_value) {
      //         setState(() {
      //           oilValue = listOfOils.firstWhere(
      //             (element) => element['name'] == _value,
      //           );
      //           ;
      //         });
      //       },
      //       items: listOfOils
      //           .map<DropdownMenuItem<String>>((var _value) =>
      //               DropdownMenuItem<String>(
      //                   value: _value[
      //                       'name'], // add this property an pass the _value to it
      //                   child: Text(
      //                     _value['name'],
      //                   )))
      //           .toList(),
      //     ),
      //   ],
      // ),
      const SizedBox(
        height: 20,
      ),
    ]);
  }
}
