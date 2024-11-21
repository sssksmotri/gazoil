import 'package:http/http.dart' as http;
import 'dart:convert';

Future getQR(token) async {
  http.Response response = await http.get(
    Uri.parse('http://188.120.224.46:5000/api/qr?token=${token}'),
  );
  return response.bodyBytes;
}

Future<Map<String, dynamic>> checkCode(token) async {
  http.Response response = await http.get(
      Uri.parse('http://188.120.224.46:5000/api/loyalty-card'),
      headers: {'token': token});
  return json.decode(response.body);
}

Future<Map<String, dynamic>> notifications(token) async {
  http.Response response = await http.get(
    Uri.parse('http://188.120.224.46:5000/api/notifications?token=${token}'),
  );
  print("notifications:");
  print(response.body);
  return json.decode(response.body);
}

Future<Map<String, dynamic>> notification(token) async {
  http.Response response = await http.get(
      Uri.parse('http://188.120.224.46:5000/api/notification'),
      headers: {'token': token});
  return json.decode(response.body);
}

Future<Map<String, dynamic>> loyaltyCard(token) async {
  http.Response response = await http.get(
    Uri.parse('http://188.120.224.46:5000/api/loyalty-card?token=$token'),
  );
  return json.decode(response.body);
}

Future<void> deleteData() async {
  http.Response response = await http.get(
      Uri.parse('https://xn--80affam5azbem.xn--p1ai/deleteMyData.html')
  );

  await Future.delayed(const Duration(seconds: 2));

  return;
}
