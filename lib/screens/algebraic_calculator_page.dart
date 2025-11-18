import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'nemorphic_container.dart';
import '../services/sound_service.dart';
import '../services/equation_solver_service.dart';
import '../models/solution_step.dart';
import '../widgets/app_drawer.dart';

class AlgebraicCalculatorPage extends StatefulWidget {
  const AlgebraicCalculatorPage({super.key});

  @override
  State<AlgebraicCalculatorPage> createState() => _AlgebraicCalculatorPageState();
}

class _AlgebraicCalculatorPageState extends State<AlgebraicCalculatorPage> {
  bool darkMode = false;
  String equation = '';
  List<SolutionStep> steps = [];
  bool isLoading = false;
  Color colorDark = const Color(0xFF2A3441);
  Color colorLight = const Color(0xFFF5F7FA);

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _solveEquation() async {
    if (equation.trim().isEmpty) return;

    setState(() {
      isLoading = true;
      steps = [];
    });

    await SoundService.playButtonTap();

    try {
      final solution = await EquationSolverService.solveEquation(equation);
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
            equation: 'Could not solve equation. Please check your input.',
            explanation: e.toString(),
          ),
        ];
        isLoading = false;
      });
    }
  }

  void _clearEquation() async {
    await SoundService.playClearTap();
    setState(() {
      equation = '';
      steps = [];
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = darkMode ? Colors.white : Colors.grey.shade800;
    Color subtitleColor = darkMode 
        ? Colors.white.withValues(alpha: 0.7) 
        : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: darkMode ? colorDark : colorLight,
      drawer: AppDrawer(
        darkMode: darkMode,
        currentRoute: '/algebraic',
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
                          'Algebraic Solver',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          'Solve equations step-by-step',
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
                        color: darkMode ? Colors.green : Colors.redAccent,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

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
                      'Enter Equation',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _controller,
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'e.g., 2x + 5 = 15',
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
                          equation = value;
                        });
                      },
                      onSubmitted: (_) => _solveEquation(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: _solveEquation,
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
                                    color: darkMode ? Colors.green : Colors.redAccent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: _clearEquation,
                          child: NeuContainer(
                            darkMode: darkMode,
                            borderRadius: BorderRadius.circular(12),
                            padding: const EdgeInsets.all(16),
                            child: Icon(
                              Icons.clear,
                              color: darkMode ? Colors.red : Colors.redAccent,
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
                        color: darkMode ? Colors.green : Colors.redAccent,
                      ),
                    )
                  : steps.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.functions,
                                size: 64,
                                color: subtitleColor,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Enter an equation to solve',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: subtitleColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Linear: 2x+5=15, 3x-7=2x+3',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: subtitleColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Quadratic: x²-4=0, x²+2x+5=0 (complex)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: subtitleColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Cubic: x³-8=0, x³+2x²-x-2=0',
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
                                            color: (darkMode ? Colors.green : Colors.redAccent)
                                                .withValues(alpha: 0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            '${step.stepNumber}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: darkMode ? Colors.green : Colors.redAccent,
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

