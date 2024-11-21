import 'package:flutter/material.dart';

mainButton(width, height, function, text, [bool? disabled, bool? readonly, Color? color]) {
  
  return SizedBox(
    width: width,
    height: height,
    child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: 
            color ?? (disabled == null || disabled == false
                ? const Color(0xff00b929)
                : Colors.grey)),
        onPressed: function,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        )),
  );
}
