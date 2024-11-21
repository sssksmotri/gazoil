import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> myCars(token) async {
  http.Response response = await http.get(
    Uri.parse('http://188.120.224.46:5000/api/my-cars?token=${token}'),
  );
  print("my cars:");
  print(response.body);
  return json.decode(response.body);
}

Future<List> brands(token) async {
  http.Response response = await http.get(
    Uri.parse('http://188.120.224.46:5000/api/brands'),
  );
  return json.decode(response.body)['brands'];
}

Future<List> models(token, brand) async {
  http.Response response = await http.get(
    Uri.parse('http://188.120.224.46:5000/api/models?brand=$brand'),
  );
  return json.decode(response.body)['models'];
}

Future<List> colors(token) async {
  http.Response response = await http.get(
    Uri.parse('http://188.120.224.46:5000/api/colors?token=${token}'),
  );
  return json.decode(response.body)["data"];
}

Future<List> oils(token) async {
  http.Response response = await http.get(
    Uri.parse('http://188.120.224.46:5000/api/oils?token=${token}'),
  );
  return json.decode(response.body)["data"];
}

Future<List> petrols(token) async {
  http.Response response = await http.get(
      Uri.parse('http://188.120.224.46:5000/api/petrols?token=${token}'),
      headers: {'Keep-Alive': 'true'});
  return json.decode(response.body)["data"];
}

Future<String> addCar(token, brand, model, num, colorId, petrolId,
    [insurance = '30-08-2023', additional = null]) async {
  String body = json.encode({
    'brand': brand,
    "model": model,
    "num": num,
    'color': colorId,
    'petrol_type': 92,
    'insurance': insurance,
    'additional': additional
  });
  http.Response response = await http.post(
      Uri.parse('http://188.120.224.46:5000/api/add-car?token=$token'),
      body: body,
      headers: {"Content-Type": "application/json"});
  print(response.body);
  return json.decode(response.body);
}

Future<String> editCar(token, carId, brand, model, num, colorId, petrolId,
    [insurance = '30-08-2023', additional = null]) async {
  String body = json.encode({
    'brand': brand,
    "model": model,
    "num": num,
    'color': colorId,
    'petrol_type': 92,
    'insurance': insurance,
    'additional': additional
  });
  print('http://188.120.224.46:5000/api/edit-car?token=$token&id=$carId');
  http.Response response = await http.put(
      Uri.parse(
          'http://188.120.224.46:5000/api/edit-car?token=$token&id=$carId'),
      body: body,
      headers: {"Content-Type": "application/json"});
  print("car edited!");
  print(response.body);
  return json.decode(response.body);
}
