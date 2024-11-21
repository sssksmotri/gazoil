import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gasoilt/api/auth.dart';
import 'package:gasoilt/widgets/mainButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookCarWash extends StatefulWidget {
  const BookCarWash({super.key});

  @override
  State<BookCarWash> createState() => _BookCarWashState();
}

class _BookCarWashState extends State<BookCarWash> {
  String name = '';
  Future<void> getData() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    String token = instance.getString('token')!;
    name = (await getProfile(token))['name'];
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shadowColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'ЗАПИСЬ НА АВТОМОЙКУ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Ваше имя',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            SizedBox(
              height: 5,
            ),
            Text(name),
            SizedBox(
              height: 5,
            ),
            Container(
              height: .5,
              width: MediaQuery.of(context).size.width * .9,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.6),
                  borderRadius: BorderRadius.circular(20)),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Марка машины',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            SizedBox(
              height: 5,
            ),
            Text("Huyndai Coupe"),
            SizedBox(
              height: 5,
            ),
            Container(
              height: .5,
              width: MediaQuery.of(context).size.width * .9,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.6),
                  borderRadius: BorderRadius.circular(20)),
            ),
            SizedBox(
              height: 10,
            ),
            // Text(
            //   'Номер машины',
            //   style: TextStyle(color: Colors.grey, fontSize: 14),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            // Text("Р 777 РС"),
            // SizedBox(
            //   height: 10,
            // ),
            // Container(
            //   height: .5,
            //   width: MediaQuery.of(context).size.width * .9,
            //   decoration: BoxDecoration(
            //       color: Colors.grey.withOpacity(.6),
            //       borderRadius: BorderRadius.circular(20)),
            // ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Выберите адрес',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "Выбрать на карте",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color),
                    )),
              ],
            ),
            Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButton(
                    underline: null,
                    items: [
                      DropdownMenuItem(child: Text('ул. Милославская, 27'))
                    ],
                    onChanged: (_) {})),
            SizedBox(
              height: 20,
            ),
            Text(
              'Выберите дату',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            Container(
                height: 200,
                child: CupertinoDatePicker(
                  maximumYear: DateTime.now().year,
                  minimumYear: DateTime.now().year,
                  onDateTimeChanged: (_) {},
                  mode: CupertinoDatePickerMode.date,
                )),
            SizedBox(
              height: 10,
            ),
            // Text(
            //   'Выберите время',
            //   style: TextStyle(color: Colors.grey, fontSize: 14),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     Container(
            //       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            //       decoration: BoxDecoration(
            //           border: Border.all(color: Colors.grey),
            //           borderRadius: BorderRadius.circular(5)),
            //       child: Text("14.00"),
            //     ),
            //     Container(
            //       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            //       decoration: BoxDecoration(
            //           border: Border.all(color: Colors.grey),
            //           borderRadius: BorderRadius.circular(5)),
            //       child: Text("15.40"),
            //     ),
            //     Container(
            //       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            //       decoration: BoxDecoration(
            //           border: Border.all(color: Colors.grey),
            //           borderRadius: BorderRadius.circular(5)),
            //       child: Text("16.30"),
            //     ),
            //     Container(
            //       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            //       decoration: BoxDecoration(
            //           border: Border.all(color: Colors.grey),
            //           borderRadius: BorderRadius.circular(5)),
            //       child: Text("18.10"),
            //     ),
            //   ],
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            mainButton(
                MediaQuery.of(context).size.width, 40.0, () {}, "Записаться")
          ]),
        ),
      ),
    );
  }
}
