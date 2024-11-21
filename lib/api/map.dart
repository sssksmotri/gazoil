import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> mapList() async {
  http.Response response = await http.get(
    Uri.parse('http://188.120.224.46:5000/api/map'),
  );
  print(response.body);
  return json.decode(response.body);
}
