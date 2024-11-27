import 'dart:convert';
import 'package:gasoilt/api/auth.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getBalance(token) async {
  http.Response response = await http.get(
    Uri.parse('http://188.120.224.46:5000/api/my-balance?token=${token}'),
  );
  return json.decode(response.body);
}

Future<Map<String, dynamic>> addMoney(token, amount) async {
  http.Response response = await http.get(
    Uri.parse(
        'http://188.120.224.46:5000/api/add-money?token=${token}&amount=${amount}'),
  );
  print(response.body);
  return json.decode(response.body);
}

Future<Map<String, dynamic>> sharePoints(token, amount, recipent) async {
  recipent = recipent.replaceAll(' ', '');
  recipent = recipent.replaceAll('+', '');
  recipent = recipent.replaceAll(')', '');
  recipent = recipent.replaceAll('(', '');
  recipent = recipent.replaceAll('-', '');
  http.Response response = await http.get(
    Uri.parse(
        'http://188.120.224.46:5000/api/share-points?recipient=$recipent&amount=$amount&token=$token'),
  );
  print(response.body);
  return json.decode(response.body);
}

Future<Map<String, dynamic>> shareLiters(token, amount, id, recipent) async {
  recipent = recipent.replaceAll(' ', '');
  recipent = recipent.replaceAll('+', '');
  recipent = recipent.replaceAll(')', '');
  recipent = recipent.replaceAll('(', '');
  recipent = recipent.replaceAll('-', '');
  http.Response response = await http.get(
      Uri.parse(
        'http://188.120.224.46:5000/api/share-liters?recipient=$recipent&amount=$amount&petrol=$id&token=$token',
      ),
      headers: {"Content-Type": "application/json"});
  print(
      'http://188.120.224.46:5000/api/share-liters?token=${token}&amount=${amount}&petrol=$id&recipent=$recipent');
  print(json.decode(utf8.decode(response.bodyBytes)));
  return json.decode(response.body);
}

Future<Map<String, dynamic>> getHistory2(token) async {
  String endDate = DateTime.now().toString().replaceAll(" ", "T");
  String startDate = '2023-01-01T10:40:00';
  endDate = endDate.substring(0, endDate.indexOf('T'));
  endDate += 'T10:40:00';
  print(
      'http://188.120.224.46:5000/api/history?token=${token}&startDate=$startDate&endDate=$endDate');
  http.Response response = await http.get(
    Uri.parse(
        'http://188.120.224.46:5000/api/history?token=${token}&startDate=$startDate&endDate=$endDate'),
  );
  print(response.body);
  print(123);
  return json.decode(response.body);
}

Future<Map<String, dynamic>> getHistory(String token, {int page = 0, int pageSize = 10}) async {

  Map profile = (await getProfile(token));
  String phone = profile['phone'];
  String formatted = "${phone.substring(0,1)}-${phone.substring(1,4)}-${phone.substring(4,7)}-${phone.substring(7,9)}-${phone.substring(9,11)}";


  String username = 'mobile';
  String password = 'gGTC\$1fM';
  String basicAuth = 'Basic ${base64.encode(utf8.encode('$username:$password'))}';


  String endDate = DateTime.now().subtract(Duration(days: 1)).toString().replaceAll(" ", "T");
  String startDate = '2023-01-01T00:00:00';


  http.Response response = await http.post(
    Uri.parse('http://94.79.22.45:8282/emitent/hs/cards/getTransaction'),
    headers: <String, String>{'authorization': basicAuth},
    body: json.encode({
      "organizationId": "612306662431",
      "departmentId": "mobile",
      "phone": formatted,
      "period": {
        "startDate": startDate,
        "endDate": endDate,
      },
      "page": page,
      "pageSize": pageSize,
    }),
  );

  // Проверяем успешность запроса
  if (response.statusCode == 200) {
    print(response.body);
    return json.decode(response.body)['data'];
  } else {
    throw Exception('Ошибка получения транзакций: ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> getValidBonuses(String token) async {
  final url = 'http://188.120.224.46:5000/api/get-valid-bonuses?token=$token';
  http.Response response = await http.get(
      Uri.parse(url),
      headers: {'accept': 'application/json'}
  );
  if (response.statusCode == 200) {
    print(response.body);
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load valid bonuses');
  }
}

Future<Map<String, dynamic>> getUnavailableBonuses(String token) async {
  final url = 'http://188.120.224.46:5000/api/get_unavailable_bonuses?token=$token';
  http.Response response = await http.get(
      Uri.parse(url),
      headers: {'accept': 'application/json'}
  );
  if (response.statusCode == 200) {
    print(response.body);
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load unavailable bonuses');
  }
}

Future<Map> exchangeWallet(token, from, to, amount) async {
  if (from == "баллы") from = "points";
  if (to == "баллы") to = "points";
  if (from == "рубли") from = "money";
  if (to == "рубли") to = "money";
  print(from);
  print(to);
  print(amount);
  print(
      "http://188.120.224.46:5000/api/exchange?token=${token}&from=$from&to=$to&amount=$amount");
  http.Response response = await http.get(
      Uri.parse(
        'http://188.120.224.46:5000/api/exchange?token=${token}&from=$from&to=$to&amount=$amount',
      ),
      headers: {"Content-Type": "application/json"});
  print(json.decode(response.body));
  return json.decode(response.body);
}

Future<double> getMoneyCourse(token) async {
  http.Response response = await http.get(
      Uri.parse(
        'http://188.120.224.46:5000/api/money-course?token=$token',
      ),
      headers: {"Content-Type": "application/json"});
  print(response.body);
  return json.decode(response.body)['course'];
}

Future<double> getFuelCourse(token, goodId) async {
  http.Response response = await http.get(
      Uri.parse(
        'http://188.120.224.46:5000/api/fuel-course?token=$token&goodsId=$goodId',
      ),
      headers: {"Content-Type": "application/json"});
  print(
      'http://188.120.224.46:5000/api/fuel-course?token=$token&goodsId=$goodId');
  print(response.body);
  return json.decode(response.body)['course'];
}

Future<double> getFuelPrice(token, goodId, amount) async {
  http.Response response = await http.get(
      Uri.parse(
        'http://188.120.224.46:5000/api/fuel-price?token=$token&goodsId=$goodId&amount=$amount',
      ),
      headers: {"Content-Type": "application/json"});
  print(
      'http://188.120.224.46:5000/api/fuel-price?token=$token&goodsId=$goodId&amount=$amount');
  print(response.body);
  return json.decode(response.body)['course'];
}

Future<List> getGoods(token) async {
  http.Response response = await http.get(
      Uri.parse(
        'http://188.120.224.46:5000/api/goods?token=$token',
      ),
      headers: {"Content-Type": "application/json"});
  print(json.decode(response.body));
  return json.decode(response.body)['goods'];
}

Future<Map> buyLiters(token, amount, id) async {
  print(token);
  print(amount);
  print(id);
  http.Response response = await http.get(
      Uri.parse(
        'http://188.120.224.46:5000/api/buy-liters?token=$token&amount=$amount&goodsId=$id',
      ),
      headers: {"Content-Type": "application/json"});

  print(json.decode(response.body));
  return json.decode(response.body);
}
