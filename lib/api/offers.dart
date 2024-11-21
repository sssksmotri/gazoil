import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> offers(token) async {
  http.Response response = await http.get(
    Uri.parse('http://188.120.224.46:5000/api/all-offers?token=${token}'),
  );
  print(response.body);
  return json.decode(response.body);
}

Future<Map<String, dynamic>> personalOffers(token) async {
  http.Response response = await http.get(
    Uri.parse('http://188.120.224.46:5000/api/personal-offers?token=${token}'),
  );
  return json.decode(response.body);
}

Future<Map<String, dynamic>> offer(token, num) async {
  http.Response response = await http.get(
      Uri.parse('http://188.120.224.46:5000/api/offer'),
      headers: {'token': token, 'offer': num});
  return json.decode(response.body);
}

Future<Map<String, dynamic>> getalloffers(token) async {
  DateTime dateTime = DateTime.now();
  String username = 'mobile';
  String password = 'gGTC\$1fM';
  String basicAuth = 'Basic ${base64.encode(utf8.encode('$username:$password'))}';

  String requestDate = dateTime.toIso8601String();

  http.Response response = await http.post(
    Uri.parse('http://94.79.22.45:8282/emitent/hs/ngtcards/promotions'),
    headers: <String, String>{'authorization': basicAuth},
    body: json.encode({
      "organizationId": "612306662431",
      "requestDate": requestDate,
    }),
  );
  print(response.body);

  return json.decode(response.body)['data'];
}

