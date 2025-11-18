// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:asa_calculator/screens/calculator_page.dart';
import 'package:asa_calculator/screens/algebraic_calculator_page.dart';
import 'package:asa_calculator/screens/calculus_calculator_page.dart';
import 'package:asa_calculator/screens/graphing_calculator_page.dart';
import 'package:asa_calculator/screens/unit_converter_page.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => CalculatorNeuApp(),
            '/algebraic': (context) => AlgebraicCalculatorPage(),
            '/calculus': (context) => CalculusCalculatorPage(),
            '/graphing': (context) => GraphingCalculatorPage(),
            '/converter': (context) => UnitConverterPage(),
          },
        );
      },
    );
  }
}


