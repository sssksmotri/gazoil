import 'package:flutter_test/flutter_test.dart';
import 'package:gasoilt/api/auth.dart';

void main() {
  test("testing api", () async {
    expect(await auth("111"), false);
  });
}
