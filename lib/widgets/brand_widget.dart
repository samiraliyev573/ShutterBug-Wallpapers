import 'package:flutter/material.dart';

Widget brandName() {
  return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Shutter',
          style: TextStyle(color: Colors.black87, fontSize: 26),
          children: <TextSpan>[
            TextSpan(
                text: 'Bug',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))
          ]));
}
