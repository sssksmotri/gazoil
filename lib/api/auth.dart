import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> auth(String phone) async {
  http.Response response = await http.get(
      Uri.parse('http://188.120.224.46:5000/api/auth'),
      headers: {'phone': phone});
  return json.decode(response.body)["result"];
}

Future<String> sendCode(phone) async {
  phone = phone.replaceAll(' ', '');
  phone = phone.replaceAll('+', '');
  phone = phone.replaceAll(')', '');
  phone = phone.replaceAll('(', '');
  phone = phone.replaceAll('-', '');
  http.Response response = await http.get(
    Uri.parse('http://188.120.224.46:5000/api/send-code?phone=${phone}'),
  );
  print('ringing result:');
  print(response.body);
  return response.body;
}

Future<String> resendCode(phone) async {
  phone = phone.replaceAll(' ', '');
  phone = phone.replaceAll('+', '');
  phone = phone.replaceAll(')', '');
  phone = phone.replaceAll('(', '');
  phone = phone.replaceAll('-', '');
  http.Response response = await http.get(
    Uri.parse('http://188.120.224.46:5000/api/resend-code?phone=${phone}'),
  );
  print('sending code result:');
  print(response.body);
  return response.body;
}

Future<Map<String, dynamic>> checkCode(phone, code) async {
  phone = phone.replaceAll(' ', '');
  phone = phone.replaceAll('+', '');
  phone = phone.replaceAll(')', '');
  phone = phone.replaceAll('(', '');
  phone = phone.replaceAll('-', '');
  http.Response response = await http.get(
    Uri.parse(
        'http://188.120.224.46:5000/api/check-code?phone=${phone}&code=${code}'),
  );
  print(json.decode(response.body));
  return json.decode(response.body);
}

Future<Map> signUp(phone, org, name, surname, secondName) async {
  phone = phone.replaceAll(' ', '');
  phone = phone.replaceAll('+', '');
  phone = phone.replaceAll(')', '');
  phone = phone.replaceAll('(', '');
  phone = phone.replaceAll('-', '');
  String body = json
      .encode({"name": name, "surname": surname, "second_name": secondName});
  var bodyEncoded = json.encode(body);
  print('http://188.120.224.46:5000/api/sign_up?org=$org&phone=$phone');
  http.Response response = await http.post(
      Uri.parse('http://188.120.224.46:5000/api/sign_up?org=$org&phone=$phone'),
      body: body,
      headers: {"Content-Type": "application/json"});
  print(json.decode(response.body));
  return json.decode(response.body);
}

Future<Map> getProfile(token) async {
  Map profile = {};

  http.Response response = await http.get(
    Uri.parse('http://188.120.224.46:5000/api/profile?token=$token'),
  );

  profile = json.decode(response.body);

  await SharedPreferences.getInstance().then((instance) {
    String? newName = instance.getString('newName');
    String? newSurname = instance.getString('newSurname');
    String? newFather = instance.getString('newFather');

    if (newName != null && newName.isNotEmpty) {
      profile['name'] = instance.getString('newName')!;
    }

    if (newSurname != null && newSurname.isNotEmpty) {
      profile['surname'] = instance.getString('newSurname')!;
    }

    if (newFather != null && newFather.isNotEmpty) {
      profile['second_name'] = instance.getString('newFather')!;
    }
  });

  return profile;
}

Future<bool> phoneExist(String phone) async {
  phone = phone.replaceAll(' ', '');
  phone = phone.replaceAll('+', '');
  phone = phone.replaceAll(')', '');
  phone = phone.replaceAll('(', '');
  phone = phone.replaceAll('-', '');
  http.Response response = await http.get(
    Uri.parse('http://188.120.224.46:5000/api/auth?phone=$phone'),
  );
  print(json.decode(response.body));
  return json.decode(response.body)['result'];
}
