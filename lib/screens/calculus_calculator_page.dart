import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'nemorphic_container.dart';
import '../services/sound_service.dart';
import '../services/calculus_service.dart';
import '../models/solution_step.dart';
import '../widgets/app_drawer.dart';

class CalculusCalculatorPage extends StatefulWidget {
  const CalculusCalculatorPage({super.key});

  @override
  State<CalculusCalculatorPage> createState() => _CalculusCalculatorPageState();
}

class _CalculusCalculatorPageState extends State<CalculusCalculatorPage> {
  bool darkMode = false;
  String selectedOperation = 'Derivative';
  String function = '';
  String variable = 'x';
  List<SolutionStep> steps = [];
  bool isLoading = false;
  Color colorDark = const Color(0xFF2A3441);
  Color colorLight = const Color(0xFFF5F7FA);

  final TextEditingController _functionController = TextEditingController();
  final TextEditingController _variableController = TextEditingController(text: 'x');

  @override
  void dispose() {
    _functionController.dispose();
    _variableController.dispose();
    super.dispose();
  }

  void _solve() async {
    if (function.trim().isEmpty) return;

    setState(() {
      isLoading = true;
      steps = [];
    });

    await SoundService.playButtonTap();

    try {
      List<SolutionStep> solution;
      
      if (selectedOperation == 'Derivative') {
        solution = await CalculusService.computeDerivative(function, variable);
      } else {
        solution = await CalculusService.computeIntegral(function, variable);
      }
      
      setState(() {
        steps = solution;
        isLoading = false;
      });
      await SoundService.playSuccess();
    } catch (e) {
      await SoundService.playError();
      setState(() {
        steps = [
          SolutionStep(
            stepNumber: 0,
            description: 'Error',
            equation: 'Could not solve. Please check your input.',
            explanation: e.toString(),
          ),
        ];
        isLoading = false;
      });
    }
  }

  void _clear() async {
    await SoundService.playClearTap();
    setState(() {
      function = '';
      steps = [];
      _functionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = darkMode ? Colors.white : Colors.grey.shade800;
    Color subtitleColor = darkMode 
        ? Colors.white.withValues(alpha: 0.7) 
        : Colors.grey.shade600;
    Color accentColor = darkMode ? Colors.green : Colors.redAccent;

    return Scaffold(
      backgroundColor: darkMode ? colorDark : colorLight,
      drawer: AppDrawer(
        darkMode: darkMode,
        currentRoute: '/calculus',
        onClose: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
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
                          padding: const EdgeInsets.all(12),
                          borderRadius: BorderRadius.circular(12),
                          child: Icon(
                            Icons.menu,
                            color: textColor,
                            size: 24,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Calculus Calculator',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          'Derivatives & Integrals with steps',
                          style: TextStyle(
                            fontSize: 12,
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await SoundService.playButtonTap();
                      setState(() {
                        darkMode = !darkMode;
                      });
                    },
                    child: NeuContainer(
                      darkMode: darkMode,
                      padding: const EdgeInsets.all(12),
                      borderRadius: BorderRadius.circular(12),
                      child: Icon(
                        darkMode ? Icons.nightlight_round : Icons.wb_sunny,
                        color: accentColor,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Operation Selector
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        await SoundService.playButtonTap();
                        setState(() {
                          selectedOperation = 'Derivative';
                          steps = [];
                        });
                      },
                      child: NeuContainer(
                        darkMode: darkMode,
                        borderRadius: BorderRadius.circular(12),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.trending_up,
                                color: selectedOperation == 'Derivative' ? accentColor : textColor,
                                size: 28,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Derivative',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: selectedOperation == 'Derivative'
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: selectedOperation == 'Derivative' ? accentColor : textColor,
                                ),
                              ),
                              Text(
                                'd/dx',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: subtitleColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        await SoundService.playButtonTap();
                        setState(() {
                          selectedOperation = 'Integral';
                          steps = [];
                        });
                      },
                      child: NeuContainer(
                        darkMode: darkMode,
                        borderRadius: BorderRadius.circular(12),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.functions,
                                color: selectedOperation == 'Integral' ? accentColor : textColor,
                                size: 28,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Integral',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: selectedOperation == 'Integral'
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: selectedOperation == 'Integral' ? accentColor : textColor,
                                ),
                              ),
                              Text(
                                '∫ dx',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: subtitleColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Input Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: NeuContainer(
                darkMode: darkMode,
                borderRadius: BorderRadius.circular(16),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter Function',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _functionController,
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'e.g., x^2, sin(x), e^x',
                        hintStyle: TextStyle(color: subtitleColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: darkMode
                            ? Colors.black.withValues(alpha: 0.2)
                            : Colors.white.withValues(alpha: 0.5),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      onChanged: (value) {
                        setState(() {
                          function = value;
                        });
                      },
                      onSubmitted: (_) => _solve(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          'With respect to:',
                          style: TextStyle(
                            fontSize: 12,
                            color: subtitleColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 60,
                          child: TextField(
                            controller: _variableController,
                            style: TextStyle(
                              fontSize: 16,
                              color: textColor,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: darkMode
                                  ? Colors.black.withValues(alpha: 0.2)
                                  : Colors.white.withValues(alpha: 0.5),
                              contentPadding: const EdgeInsets.all(8),
                            ),
                            onChanged: (value) {
                              setState(() {
                                variable = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: _solve,
                            child: NeuContainer(
                              darkMode: darkMode,
                              borderRadius: BorderRadius.circular(12),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: Text(
                                  'Solve',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: accentColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: _clear,
                          child: NeuContainer(
                            darkMode: darkMode,
                            borderRadius: BorderRadius.circular(12),
                            padding: const EdgeInsets.all(16),
                            child: Icon(
                              Icons.clear,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Solution Steps
            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: accentColor,
                      ),
                    )
                  : steps.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                selectedOperation == 'Derivative'
                                    ? Icons.trending_up
                                    : Icons.functions,
                                size: 64,
                                color: subtitleColor,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Enter a function to ${selectedOperation.toLowerCase()}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: subtitleColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                selectedOperation == 'Derivative'
                                    ? 'Examples: x^2, sin(x), e^x, ln(x)'
                                    : 'Examples: x, x^2, sin(x), 1/x',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: subtitleColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          itemCount: steps.length,
                          itemBuilder: (context, index) {
                            final step = steps[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: NeuContainer(
                                darkMode: darkMode,
                                borderRadius: BorderRadius.circular(16),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: accentColor.withValues(alpha: 0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            '${step.stepNumber}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: accentColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            step.description,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: textColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: darkMode
                                            ? Colors.black.withValues(alpha: 0.2)
                                            : Colors.white.withValues(alpha: 0.5),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        step.equation,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    ),
                                    if (step.explanation.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        step.explanation,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: subtitleColor,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

