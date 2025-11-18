import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'nemorphic_container.dart';
import '../services/history_service.dart';
import '../services/sound_service.dart';
import '../widgets/history_sidebar.dart';
import '../widgets/app_drawer.dart';

class CalculatorNeuApp extends StatefulWidget {
  const CalculatorNeuApp({super.key});

  @override
  State<CalculatorNeuApp> createState() => _CalculatorNeuAppState();
}

class _CalculatorNeuAppState extends State<CalculatorNeuApp> {
  bool darkMode = false;
  bool scientificMode = false;
  bool showHistory = false;
  bool asmrMode = true; // ASMR mode enabled by default for maximum satisfaction
  bool hapticEnabled = true;
  bool soundEnabled = true;
  String display = '0';
  String equation = '';
  bool shouldResetDisplay = false;
  Color colorDark = const Color(0xFF2A3441); // Darker, more comfortable for eyes
  Color colorLight = const Color(0xFFF5F7FA); // Softer light color to reduce glare
  final parser = Parser();
  static const int maxEquationLength = 200; // Prevent extremely long equations

  @override
  void initState() {
    super.initState();
    SoundService.initialize();
    _loadPreferences();
  }

  // Load all preferences from local storage
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      darkMode = prefs.getBool('darkMode') ?? false;
      asmrMode = prefs.getBool('asmrMode') ?? true;
      hapticEnabled = prefs.getBool('hapticEnabled') ?? true;
      soundEnabled = prefs.getBool('soundEnabled') ?? true;
    });
    
    // Update sound service settings
    SoundService.setHapticEnabled(hapticEnabled);
    SoundService.setSoundEnabled(soundEnabled);
  }

  // Save dark mode preference to local storage
  Future<void> _saveDarkModePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }

  // Save ASMR preferences
  Future<void> _saveASMRPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('asmrMode', asmrMode);
    await prefs.setBool('hapticEnabled', hapticEnabled);
    await prefs.setBool('soundEnabled', soundEnabled);
    
    // Update sound service settings
    SoundService.setHapticEnabled(hapticEnabled);
    SoundService.setSoundEnabled(soundEnabled);
  }

  Widget _buttonOval({String? title, double? padding, required void Function()? onTap}) {
    // Use Sizer for responsive sizing - increased text size for scientific functions
    final responsivePadding = padding ?? 2.w;
    final fontSize = 3.2.w; // Bigger text for scientific notations

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(0.6.w),
        child: GestureDetector(
          onTap: () async {
            await SoundService.playOperatorTap();
            onTap?.call();
          },
          child: NeuContainer(
            darkMode: darkMode,
            borderRadius: BorderRadius.circular(60), // More round
            padding: EdgeInsets.symmetric(
              horizontal: responsivePadding,
              vertical: responsivePadding * 0.8
            ),
            child: Container(
              height: 8.w, // Fixed height to prevent overflow
              child: Center(
                child: Text(
                  '$title',
                  style: TextStyle(
                    color: darkMode ? Colors.white : Colors.black,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _switchMode() {
    return NeuContainer(
      darkMode: darkMode,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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

  Widget _toggleButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return GestureDetector(
      onTap: () async {
        await SoundService.playButtonTap();
        onTap();
      },
      child: Tooltip(
        message: tooltip,
        child: NeuContainer(
          darkMode: darkMode,
          padding: const EdgeInsets.all(12),
          borderRadius: BorderRadius.circular(30),
          child: Icon(
            icon,
            color: isActive
                ? (darkMode ? Colors.green : Colors.red)
                : (darkMode ? Colors.grey : Colors.grey),
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buttonRounded({
    String? title,
    double? padding,
    IconData? icon,
    Color? iconColor,
    Color? textColor,
    required void Function()? onTap,
    bool isNumber = false,
    bool isOperator = false,
    bool isEquals = false,
    bool isClear = false,
  }) {
    // Use Sizer for responsive sizing - reduced button sizes
    final responsivePadding = padding ?? 2.5.w;
    final fontSize = 4.5.w;
    final iconSize = 4.w;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(1.w),
        child: GestureDetector(
          onTap: () async {
            // Play appropriate sound based on button type
            if (isNumber) {
              await SoundService.playNumberTap();
            } else if (isOperator) {
              await SoundService.playOperatorTap();
            } else if (isEquals) {
              await SoundService.playEqualsTap();
            } else if (isClear) {
              await SoundService.playClearTap();
            } else {
              await SoundService.playButtonTap();
            }
            onTap?.call();
          },
          child: NeuContainer(
            darkMode: darkMode,
            borderRadius: BorderRadius.circular(60), // More round
            padding: EdgeInsets.all(responsivePadding),
            child: Container(
              height: 12.w, // Fixed height instead of AspectRatio to prevent overflow
              child: Center(
                child: title != null
                    ? Text(
                        title,
                        style: TextStyle(
                          color: textColor ?? (darkMode ? Colors.white : Colors.black),
                          fontSize: fontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : Icon(
                        icon,
                        color: iconColor ?? (darkMode ? Colors.white : Colors.black),
                        size: iconSize,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode ? colorDark : colorLight,
      drawer: AppDrawer(
        darkMode: darkMode,
        currentRoute: '/',
        onClose: () => Navigator.of(context).pop(),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(4.w, 4.w, 4.w, 6.w), // Added extra bottom padding
              child: Column(
                children: [
                  // Top section with controls and display
                  Expanded(
                    flex: scientificMode ? 3 : 4, // More space for display in regular mode
                    child: Column(
                      children: [
                        // Top controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Builder(
                                  builder: (BuildContext scaffoldContext) {
                                    return GestureDetector(
                                      onTap: () async {
                                        await SoundService.playButtonTap();
                                        if (!mounted) return;
                                        Scaffold.of(scaffoldContext).openDrawer();
                                      },
                                      child: NeuContainer(
                                        darkMode: darkMode,
                                        padding: const EdgeInsets.all(10),
                                        borderRadius: BorderRadius.circular(30),
                                        child: Icon(
                                          Icons.menu,
                                          color: darkMode ? Colors.white : Colors.black,
                                          size: 20,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(width: 2.w),
                                GestureDetector(
                                    onTap: () async {
                                      await SoundService.playButtonTap();
                                      final newDarkMode = !darkMode;
                                      setState(() {
                                        darkMode = newDarkMode;
                                      });
                                      await _saveDarkModePreference(newDarkMode);
                                    },
                                    child: _switchMode()),
                              ],
                            ),
                            Row(
                              children: [
                                _toggleButton(
                                  icon: Icons.functions,
                                  isActive: scientificMode,
                                  onTap: () {
                                    setState(() {
                                      scientificMode = !scientificMode;
                                    });
                                  },
                                  tooltip: 'Scientific Mode',
                                ),
                                SizedBox(width: 2.w),
                                _toggleButton(
                                  icon: Icons.history,
                                  isActive: showHistory,
                                  onTap: () {
                                    setState(() {
                                      showHistory = !showHistory;
                                    });
                                  },
                                  tooltip: 'History',
                                ),
                                SizedBox(width: 2.w),
                                _toggleButton(
                                  icon: Icons.settings,
                                  isActive: false,
                                  onTap: () => _showASMRSettings(),
                                  tooltip: 'ASMR Settings',
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),

                        // Display area with better contrast and larger text
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: darkMode 
                                ? Color(0xFF2A3441) // Darker background for better contrast
                                : Color(0xFFF5F7FA), // Softer light background to reduce glare
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: darkMode ? Colors.black26 : Colors.grey.shade300,
                                  offset: Offset(0, 2),
                                  blurRadius: 8,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Equation display - bigger text
                                Container(
                                  height: 5.h,
                                  alignment: Alignment.centerRight,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    reverse: true,
                                    child: Text(
                                      equation.isEmpty ? '' : equation,
                                      style: TextStyle(
                                        fontSize: 4.5.w, // Much bigger equation text
                                        color: darkMode
                                          ? Colors.white.withValues(alpha: 0.8)
                                          : Colors.grey.shade700, // Better contrast
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                // Main display - much bigger text
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: darkMode
                                          ? Colors.white24
                                          : Colors.black12, // Subtle divider
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  height: 10.h,
                                  alignment: Alignment.centerRight,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    reverse: true,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        display,
                                        style: TextStyle(
                                          fontSize: 24.sp, // Much bigger main display text
                                          fontWeight: FontWeight.bold,
                                          color: darkMode 
                                            ? Colors.white 
                                            : Colors.grey.shade800, // Better contrast, less glare
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              // Keypad section
              Expanded(
                flex: scientificMode ? 5 : 4, // Less space for keypad in regular mode
                child: Column(
                  children: [
                    // Scientific functions section (only in scientific mode)
                    if (scientificMode) ...[
                      Flexible(
                        flex: 3,
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  _buttonOval(title: 'sin', onTap: () => addFunction('sin')),
                                  _buttonOval(title: 'cos', onTap: () => addFunction('cos')),
                                  _buttonOval(title: 'tan', onTap: () => addFunction('tan')),
                                  _buttonOval(title: 'log', onTap: () => addScientificFunction('log')),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  _buttonOval(title: 'ln', onTap: () => addScientificFunction('ln')),
                                  _buttonOval(title: '√', onTap: () => addScientificFunction('√')),
                                  _buttonOval(title: 'x²', onTap: () => addScientificFunction('x²')),
                                  _buttonOval(title: 'x!', onTap: () => addScientificFunction('x!')),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  _buttonOval(title: 'π', onTap: () => addScientificFunction('π')),
                                  _buttonOval(title: 'e', onTap: () => addScientificFunction('e')),
                                  _buttonOval(title: '^', onTap: () => addCharacter('^')),
                                  _buttonOval(title: '%', onTap: () => addCharacter('%')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else
                      // Basic functions row in regular mode
                      Container(
                        height: 10.w,
                        child: Row(
                          children: [
                            _buttonOval(title: 'sin', onTap: () => addFunction('sin')),
                            _buttonOval(title: 'cos', onTap: () => addFunction('cos')),
                            _buttonOval(title: 'tan', onTap: () => addFunction('tan')),
                            _buttonOval(title: '%', onTap: () => addCharacter('%')),
                          ],
                        ),
                      ),

                    SizedBox(height: 1.h),

                    // Main calculator buttons section
                    Flexible(
                      flex: 5,
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                _buttonRounded(
                                  title: 'C',
                                  textColor: darkMode ? Colors.green : Colors.redAccent,
                                  isClear: true,
                                  onTap: () => clear(),
                                ),
                                _buttonRounded(
                                  title: '(',
                                  isOperator: true,
                                  onTap: () => addCharacter('('),
                                ),
                                _buttonRounded(
                                  title: ')',
                                  isOperator: true,
                                  onTap: () => addCharacter(')'),
                                ),
                                _buttonRounded(
                                  title: '/',
                                  textColor: darkMode ? Colors.green : Colors.redAccent,
                                  isOperator: true,
                                  onTap: () => addCharacter('/'),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                _buttonRounded(title: '7', isNumber: true, onTap: () => addCharacter('7')),
                                _buttonRounded(title: '8', isNumber: true, onTap: () => addCharacter('8')),
                                _buttonRounded(title: '9', isNumber: true, onTap: () => addCharacter('9')),
                                _buttonRounded(
                                  title: 'x',
                                  textColor: darkMode ? Colors.green : Colors.redAccent,
                                  isOperator: true,
                                  onTap: () => addCharacter('*'),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                _buttonRounded(title: '4', isNumber: true, onTap: () => addCharacter('4')),
                                _buttonRounded(title: '5', isNumber: true, onTap: () => addCharacter('5')),
                                _buttonRounded(title: '6', isNumber: true, onTap: () => addCharacter('6')),
                                _buttonRounded(
                                  title: '-',
                                  textColor: darkMode ? Colors.green : Colors.redAccent,
                                  isOperator: true,
                                  onTap: () => addCharacter('-'),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                _buttonRounded(title: '1', isNumber: true, onTap: () => addCharacter('1')),
                                _buttonRounded(title: '2', isNumber: true, onTap: () => addCharacter('2')),
                                _buttonRounded(title: '3', isNumber: true, onTap: () => addCharacter('3')),
                                _buttonRounded(
                                  title: '+',
                                  textColor: darkMode ? Colors.green : Colors.redAccent,
                                  isOperator: true,
                                  onTap: () => addCharacter('+'),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                _buttonRounded(title: '0', isNumber: true, onTap: () => addCharacter('0')),
                                _buttonRounded(
                                  title: '.',
                                  isNumber: true,
                                  onTap: () => addCharacter('.'),
                                ),
                                _buttonRounded(
                                  icon: Icons.backspace_outlined,
                                  iconColor: darkMode ? Colors.green : Colors.redAccent,
                                  onTap: () => removeCharacter(),
                                ),
                                _buttonRounded(
                                  title: '=',
                                  textColor: darkMode ? Colors.green : Colors.redAccent,
                                  isEquals: true,
                                  onTap: () => calculate(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // History Sidebar
      HistorySidebar(
        darkMode: darkMode,
        isOpen: showHistory,
        onHistoryItemTapped: (result) {
          setState(() {
            display = result;
            equation = result;
            shouldResetDisplay = true;
          });
        },
        onClose: () {
          setState(() {
            showHistory = false;
          });
        },
      ),
    ],
    ));
  }

  void clear() {
    setState(() {
      display = '0';
      equation = '';
      shouldResetDisplay = false;
    });
  }

  void addCharacter(String character) {
    setState(() {
      if (shouldResetDisplay) {
        display = '';
        equation = ''; // FIX: Reset equation when starting new calculation
        shouldResetDisplay = false;
      }

      // Validation: Prevent operators at the start (except minus for negative numbers)
      if (equation.isEmpty && ['+', '*', '/', ')'].contains(character)) {
        return; // Don't allow these operators at the start
      }

      // FIX: Handle decimal point at the start
      if (character == '.' && equation.isEmpty) {
        display = '0.';
        equation = '0.';
        return;
      }

      // Validation: Prevent consecutive operators (except minus after an operator for negative numbers)
      if (equation.isNotEmpty && _isOperator(equation[equation.length - 1]) && _isOperator(character)) {
        if (character == '-' && equation[equation.length - 1] != '-') {
          // Allow minus after another operator for negative numbers
        } else {
          // Replace the last operator with the new one
          equation = equation.substring(0, equation.length - 1);
          display = display.substring(0, display.length - 1);
        }
      }

      // Validation: Prevent multiple decimal points in the same number
      if (character == '.') {
        // Get the current number being typed (after the last operator)
        String currentNumber = _getCurrentNumber();
        if (currentNumber.contains('.')) {
          return; // Already has a decimal point
        }
      }

      // FIX: Handle starting with '0' more carefully
      if (display == '0' && equation == '') {
        if (character == '0') {
          return; // Don't add another 0 at the start
        } else if (character != '.') {
          display = character;
          equation = character;
          return;
        }
      }

      // FIX: Prevent extremely long equations
      if (equation.length >= maxEquationLength) {
        return; // Don't allow more characters
      }

      // Normal character addition
      display += character;
      equation += character;
    });
  }

  // Helper method to check if a character is an operator
  bool _isOperator(String char) {
    return ['+', '-', '*', '/', '^', '%'].contains(char);
  }

  // Helper method to get the current number being typed
  String _getCurrentNumber() {
    String current = '';
    for (int i = equation.length - 1; i >= 0; i--) {
      if (_isOperator(equation[i]) || equation[i] == '(' || equation[i] == ')') {
        break;
      }
      current = equation[i] + current;
    }
    return current;
  }

  void removeCharacter() {
    setState(() {
      if (shouldResetDisplay) {
        display = '0';
        equation = '';
        shouldResetDisplay = false;
      } else {
        if (equation.isEmpty) return;

        // Check if we're removing a function (sin(, cos(, tan(, log(, ln(, sqrt()
        List<String> functions = ['sin(', 'cos(', 'tan(', 'log(', 'ln(', 'sqrt('];
        bool removedFunction = false;

        for (String func in functions) {
          if (equation.endsWith(func)) {
            equation = equation.substring(0, equation.length - func.length);
            display = display.substring(0, display.length - func.length);
            removedFunction = true;
            break;
          }
        }

        // If we didn't remove a function, remove single character
        if (!removedFunction) {
          if (display.length > 1) {
            display = display.substring(0, display.length - 1);
          } else {
            display = '0';
          }
          if (equation.isNotEmpty) {
            equation = equation.substring(0, equation.length - 1);
          }
        }

        // Reset to '0' if both are empty
        if (display.isEmpty) {
          display = '0';
        }
      }
    });
  }

  void addFunction(String function) {
    setState(() {
      if (shouldResetDisplay) {
        display = '';
        equation = ''; // FIX: Reset equation when starting new calculation
        shouldResetDisplay = false;
      }

      if (display == '0') {
        display = '$function(';
        equation = '$function(';
      } else {
        display += '$function(';
        equation += '$function(';
      }
    });
  }

  void addScientificFunction(String function) {
    setState(() {
      if (shouldResetDisplay) {
        display = '';
        equation = ''; // FIX: Reset equation when starting new calculation
        shouldResetDisplay = false;
      }

      String functionToAdd = function;

      // Handle special cases
      switch (function) {
        case 'π':
          functionToAdd = '${math.pi}';
          break;
        case 'e':
          functionToAdd = '${math.e}';
          break;
        case 'log':
          functionToAdd = 'log(';
          break;
        case 'ln':
          functionToAdd = 'ln(';
          break;
        case '√':
          functionToAdd = 'sqrt(';
          break;
        case 'x²':
          if (display != '0' && equation.isNotEmpty) {
            display += '^2';
            equation += '^2';
            return;
          }
          break;
        case 'x!':
          // For factorial, we'll handle it in calculation
          if (display != '0' && equation.isNotEmpty) {
            display += '!';
            equation += '!';
            return;
          }
          break;
        default:
          functionToAdd = '$function(';
      }

      if (display == '0' && !['π', 'e'].contains(function)) {
        display = functionToAdd;
        equation = functionToAdd;
      } else {
        display += functionToAdd;
        equation += functionToAdd;
      }
    });
  }

  void calculate() async {
    try {
      if (equation.isEmpty) return;

      String processedEquation = equation;

      // FIX: Validate and auto-close unclosed parentheses
      int openParens = 0;
      for (int i = 0; i < processedEquation.length; i++) {
        if (processedEquation[i] == '(') openParens++;
        if (processedEquation[i] == ')') openParens--;
      }
      // Auto-close unclosed parentheses
      for (int i = 0; i < openParens; i++) {
        processedEquation += ')';
      }

      // FIX: Check for empty function calls like sin() or log()
      if (RegExp(r'(sin|cos|tan|log|ln|sqrt)\(\)').hasMatch(processedEquation)) {
        throw Exception('Empty function call');
      }

      // FIX: Check if equation ends with an operator
      if (processedEquation.isNotEmpty && _isOperator(processedEquation[processedEquation.length - 1])) {
        throw Exception('Equation ends with operator');
      }

      // Handle percentage - convert % to /100
      processedEquation = processedEquation.replaceAllMapped(
        RegExp(r'(\d+\.?\d*)%'),
        (match) {
          double value = double.parse(match.group(1)!);
          return (value / 100).toString();
        },
      );

      // Handle factorial with better validation
      processedEquation = processedEquation.replaceAllMapped(
        RegExp(r'(\d+\.?\d*)!'),
        (match) {
          String numStr = match.group(1)!;
          double num = double.parse(numStr);

          // Check if it's an integer
          if (num != num.floor()) {
            throw Exception('Factorial only works with integers');
          }

          int n = num.toInt();

          // Prevent overflow - limit factorial to reasonable numbers
          if (n < 0) {
            throw Exception('Factorial not defined for negative numbers');
          }
          if (n > 170) {
            throw Exception('Number too large for factorial');
          }

          // Calculate factorial
          double factorial = 1;
          for (int i = 2; i <= n; i++) {
            factorial *= i;
          }
          return factorial.toString();
        },
      );

      Expression exp = parser.parse(processedEquation);
      ContextModel cm = ContextModel();
      final result = exp.evaluate(EvaluationType.REAL, cm);

      String resultString = result.toString();

      // Handle special cases
      if (resultString == 'NaN' || resultString == 'Infinity' || resultString == '-Infinity') {
        throw Exception('Invalid calculation');
      }

      // Remove unnecessary decimal places
      if (resultString.endsWith('.0')) {
        resultString = resultString.substring(0, resultString.length - 2);
      }

      // Save to history
      await HistoryService.addCalculation(equation, resultString);
      await SoundService.playSuccess();

      setState(() {
        display = resultString;
        shouldResetDisplay = true;
      });
    } catch (e) {
      await SoundService.playError();
      setState(() {
        display = 'Error';
        equation = ''; // FIX: Clear equation on error
        shouldResetDisplay = true;
      });
    }
  }

  // Show ASMR settings modal
  void _showASMRSettings() async {
    await SoundService.playButtonTap();

    if (!mounted) return; // FIX: Check if widget is still mounted before using context

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: darkMode ? colorDark : colorLight,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              padding: EdgeInsets.all(6.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    width: 12.w,
                    height: 0.5.h,
                    decoration: BoxDecoration(
                      color: darkMode ? Colors.white24 : Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  
                  // Title
                  Text(
                    'ASMR Settings',
                    style: TextStyle(
                      fontSize: 6.w,
                      fontWeight: FontWeight.bold,
                      color: darkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  
                  // ASMR Mode Toggle
                  _buildSettingRow(
                    'ASMR Mode',
                    'Enhanced satisfying feedback',
                    asmrMode,
                    (value) {
                      setModalState(() {
                        asmrMode = value;
                      });
                      setState(() {
                        asmrMode = value;
                      });
                      _saveASMRPreferences();
                    },
                  ),
                  
                  // Haptic Feedback Toggle
                  _buildSettingRow(
                    'Haptic Feedback',
                    'Physical vibration feedback',
                    hapticEnabled,
                    (value) {
                      setModalState(() {
                        hapticEnabled = value;
                      });
                      setState(() {
                        hapticEnabled = value;
                      });
                      _saveASMRPreferences();
                    },
                  ),
                  
                  // Sound Effects Toggle
                  _buildSettingRow(
                    'Sound Effects',
                    'Audio feedback for button presses',
                    soundEnabled,
                    (value) {
                      setModalState(() {
                        soundEnabled = value;
                      });
                      setState(() {
                        soundEnabled = value;
                      });
                      _saveASMRPreferences();
                    },
                  ),
                  
                  SizedBox(height: 2.h),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Build setting row widget
  Widget _buildSettingRow(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 4.w,
                    fontWeight: FontWeight.w600,
                    color: darkMode ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 3.w,
                    color: darkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              await SoundService.playButtonTap();
              onChanged(!value);
            },
            child: NeuContainer(
              darkMode: darkMode,
              borderRadius: BorderRadius.circular(25),
              padding: EdgeInsets.all(0.5.w),
              child: Container(
                width: 12.w,
                height: 6.w,
                child: AnimatedAlign(
                  duration: Duration(milliseconds: 200),
                  alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: 5.w,
                    height: 5.w,
                    decoration: BoxDecoration(
                      color: value 
                        ? (darkMode ? Colors.green : Colors.redAccent)
                        : (darkMode ? Colors.grey : Colors.grey.shade400),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
