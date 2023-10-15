import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'nemorphic_container.dart';

class CalculatorNeuApp extends StatefulWidget {
  const CalculatorNeuApp({super.key});

  @override
  State<CalculatorNeuApp> createState() => _CalculatorNeuAppState();
}

class _CalculatorNeuAppState extends State<CalculatorNeuApp> {
  bool darkMode = false;
  String display = '';
  String equation = '';
  Color colorDark = Color(0xFF374352);
  Color colorLight = Color(0xFFe6eeff);
  Parser p = Parser();

  Widget _buttonOval({String? title, double padding = 17}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: NeuContainer(
        darkMode: darkMode,
        borderRadius: BorderRadius.circular(50),
        padding:
            EdgeInsets.symmetric(horizontal: padding, vertical: padding / 2),
        child: SizedBox(
          width: padding * 2,
          child: Center(
            child: Text(
              '$title',
              style: TextStyle(
                  color: darkMode ? Colors.white : Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _switchMode() {
    return NeuContainer(
      darkMode: darkMode,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      borderRadius: BorderRadius.circular(40),
      child: SizedBox(
        width: 70,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Icon(
            Icons.wb_sunny,
            color: darkMode ? Colors.grey : Colors.redAccent,
          ),
          Icon(
            Icons.nightlight_round,
            color: darkMode ? Colors.green : Colors.grey,
          ),
        ]),
      ),
    );
  }

  Widget _buttonRounded(
      {String? title,
      double? padding = 17,
      IconData? icon,
      Color? iconColor,
      Color? textColor,
      required void Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: NeuContainer(
        darkMode: darkMode,
        borderRadius: BorderRadius.circular(40),
        padding: EdgeInsets.all(padding!),
        child: SizedBox(
          width: padding * 2,
          height: padding * 2,
          child: Center(
              child: title != null
                  ? Text(
                      title,
                      style: TextStyle(
                          color: textColor ??
                              (darkMode ? Colors.white : Colors.black),
                          fontSize: 30),
                    )
                  : Icon(
                      icon,
                      color: iconColor,
                      size: 30,
                    )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode ? colorDark : colorLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          darkMode = !darkMode;
                        });
                      },
                      child: _switchMode()),
                  SizedBox(height: 80),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      display,
                      style: TextStyle(
                          fontSize: 55,
                          fontWeight: FontWeight.bold,
                          color: darkMode ? Colors.white : Colors.red),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '=',
                        style: TextStyle(
                            fontSize: 35,
                            color: darkMode ? Colors.green : Colors.grey),
                      ),
                      Text(
                        equation,
                        style: TextStyle(
                            fontSize: 20,
                            color: darkMode ? Colors.green : Colors.grey),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
              Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buttonOval(title: 'sin'),
                    _buttonOval(title: 'cos'),
                    _buttonOval(title: 'tan'),
                    _buttonOval(title: '%'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buttonRounded(
                        title: 'C',
                        textColor: darkMode ? Colors.green : Colors.redAccent,
                        onTap: () {
                          clear();
                        }),
                    _buttonRounded(title: '(', onTap: () => addCharacter('(')),
                    _buttonRounded(title: ')', onTap: () => addCharacter(')')),
                    _buttonRounded(
                        title: '/',
                        textColor: darkMode ? Colors.green : Colors.redAccent,
                        onTap: () => addCharacter('/')),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buttonRounded(title: '7', onTap: () => addCharacter('7')),
                    _buttonRounded(title: '8', onTap: () => addCharacter('8')),
                    _buttonRounded(title: '9', onTap: () => addCharacter('9')),
                    _buttonRounded(
                        title: 'x',
                        textColor: darkMode ? Colors.green : Colors.redAccent,
                        onTap: () => addCharacter('*')),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buttonRounded(title: '4', onTap: () => addCharacter('4')),
                    _buttonRounded(title: '5', onTap: () => addCharacter('5')),
                    _buttonRounded(title: '6', onTap: () => addCharacter('6')),
                    _buttonRounded(
                        title: '-',
                        textColor: darkMode ? Colors.green : Colors.redAccent,
                        onTap: () => addCharacter('-')),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buttonRounded(title: '1', onTap: () => addCharacter('1')),
                    _buttonRounded(title: '2', onTap: () => addCharacter('2')),
                    _buttonRounded(title: '3', onTap: () => addCharacter('3')),
                    _buttonRounded(
                        title: '+',
                        textColor: darkMode ? Colors.green : Colors.redAccent,
                        onTap: () => addCharacter('+')),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buttonRounded(title: '0', onTap: () => addCharacter('0')),
                    _buttonRounded(
                        title: ',',
                        onTap: () {
                          addCharacter('.');
                        }),
                    _buttonRounded(
                        icon: Icons.backspace_outlined,
                        iconColor: darkMode ? Colors.green : Colors.redAccent,
                        onTap: () {
                          removeCharacter();
                        }),
                    _buttonRounded(
                        title: '=',
                        textColor: darkMode ? Colors.green : Colors.redAccent,
                        onTap: () {
                          calculate();
                        }),
                  ],
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }

  void clear() {
    setState(() {
      display = '';
      equation = '';
    });
  }

  void addCharacter(String character) {
    setState(() {
      display += character;
      equation += character;
    });
  }

  void removeCharacter() {
    setState(() {
      display = display.substring(0, display.length - 1);
      equation = equation.substring(0, equation.length - 1);
    });
  }

  void calculate() {
    try {
      Expression exp = p.parse(equation);
      ContextModel cm = ContextModel();
      final result = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        display = result.toStringAsFixed(2);
        equation = display;
      });
    } catch (e) {
      // Handle errors, e.g., division by zero
      setState(() {
        display = 'Error';
        equation = 'Error';
      });
    }
  }
}
