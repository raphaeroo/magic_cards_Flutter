import 'package:flutter/material.dart';
import 'package:magic_cards/pages/homePage.dart';
import 'package:magic_cards/theme/color.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primaryColor: primary),
    home: IndexPage(),
  ));
}
