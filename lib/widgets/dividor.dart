import 'package:flutter/material.dart';

Widget dividor(width) {
  return Container(
    height: 2,
    width: width,
    decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.2),
        borderRadius: BorderRadius.circular(1)),
  );
}
