import '../models/solution_step.dart';
import 'dart:math' as math;

class EquationSolverService {
  /// Solves algebraic equations and returns step-by-step solutions
  static Future<List<SolutionStep>> solveEquation(String equation) async {
    // Simulate processing time for better UX
    await Future.delayed(const Duration(milliseconds: 500));

    List<SolutionStep> steps = [];
    
    try {
      // Clean the equation
      String cleanedEquation = equation.trim().replaceAll(' ', '');
      
      steps.add(SolutionStep(
        stepNumber: 1,
        description: 'Original Equation',
        equation: _formatEquation(cleanedEquation),
        explanation: 'Starting with the given equation',
      ));

      // Check if it's a valid equation with =
      if (!cleanedEquation.contains('=')) {
        throw Exception('Equation must contain an equals sign (=)');
      }

      // Split by equals sign
      List<String> sides = cleanedEquation.split('=');
      if (sides.length != 2) {
        throw Exception('Equation must have exactly one equals sign');
      }

      String leftSide = sides[0];
      String rightSide = sides[1];

      // Detect equation type and solve
      if (_isCubicEquation(leftSide, rightSide)) {
        return _solveCubicEquation(leftSide, rightSide, steps);
      } else if (_isQuadraticEquation(leftSide, rightSide)) {
        return _solveQuadraticEquation(leftSide, rightSide, steps);
      } else if (_isLinearEquation(leftSide, rightSide)) {
        return _solveLinearEquation(leftSide, rightSide, steps);
      } else {
        // Try to solve as simple equation
        return _solveSimpleEquation(leftSide, rightSide, steps);
      }
    } catch (e) {
      throw Exception('Error solving equation: ${e.toString()}');
    }
  }

  static bool _isCubicEquation(String left, String right) {
    String combined = left + right;
    return combined.contains('x³') ||
           combined.contains('x^3') ||
           combined.contains('X³') ||
           combined.contains('X^3');
  }

  static bool _isQuadraticEquation(String left, String right) {
    String combined = left + right;
    return !_isCubicEquation(left, right) &&
           (combined.contains('x²') ||
            combined.contains('x^2') ||
            combined.contains('X²') ||
            combined.contains('X^2'));
  }

  static bool _isLinearEquation(String left, String right) {
    // Check if equation contains x but not x² or x^2 or x³
    String combined = left + right;
    return (combined.contains('x') || combined.contains('X')) &&
           !_isQuadraticEquation(left, right) &&
           !_isCubicEquation(left, right);
  }

  static List<SolutionStep> _solveLinearEquation(
    String left, 
    String right, 
    List<SolutionStep> steps
  ) {
    // Parse linear equation: ax + b = c
    // Simplified parser for common cases
    
    try {
      // Move all terms to left side
      steps.add(SolutionStep(
        stepNumber: steps.length + 1,
        description: 'Move all terms to one side',
        equation: '$left - ($right) = 0',
        explanation: 'Subtract right side from both sides',
      ));

      // Extract coefficients (simplified)
      double a = _extractCoefficient(left, right);
      double b = _extractConstant(left, right);

      if (a == 0) {
        if (b == 0) {
          steps.add(SolutionStep(
            stepNumber: steps.length + 1,
            description: 'Solution',
            equation: 'x can be any value',
            explanation: 'The equation is true for all values of x',
          ));
        } else {
          steps.add(SolutionStep(
            stepNumber: steps.length + 1,
            description: 'No Solution',
            equation: 'No solution exists',
            explanation: 'The equation has no solution',
          ));
        }
        return steps;
      }

      // Isolate x
      steps.add(SolutionStep(
        stepNumber: steps.length + 1,
        description: 'Isolate the variable',
        equation: '${a}x = ${-b}',
        explanation: 'Move constant term to the right side',
      ));

      // Solve for x
      double solution = -b / a;
      String solutionStr = _formatNumber(solution);

      steps.add(SolutionStep(
        stepNumber: steps.length + 1,
        description: 'Divide both sides',
        equation: 'x = $solutionStr',
        explanation: 'Divide both sides by $a',
      ));

      steps.add(SolutionStep(
        stepNumber: steps.length + 1,
        description: 'Final Answer',
        equation: 'x = $solutionStr',
        explanation: 'The solution to the equation',
      ));

      return steps;
    } catch (e) {
      throw Exception('Could not solve linear equation: ${e.toString()}');
    }
  }

  static List<SolutionStep> _solveQuadraticEquation(
    String left,
    String right,
    List<SolutionStep> steps
  ) {
    try {
      steps.add(SolutionStep(
        stepNumber: steps.length + 1,
        description: 'Quadratic Equation Detected',
        equation: 'ax² + bx + c = 0',
        explanation: 'This is a quadratic equation of the form ax² + bx + c = 0',
      ));

      // Extract coefficients a, b, c
      double a = _getQuadraticCoefficient(left, right);
      double b = _getLinearCoefficient(left, right);
      double c = _getConstantCoefficient(left, right);

      steps.add(SolutionStep(
        stepNumber: steps.length + 1,
        description: 'Identify Coefficients',
        equation: 'a = $a, b = $b, c = $c',
        explanation: 'Extract the coefficients from the equation',
      ));

      // Calculate discriminant
      double discriminant = b * b - 4 * a * c;

      steps.add(SolutionStep(
        stepNumber: steps.length + 1,
        description: 'Calculate Discriminant',
        equation: 'Δ = b² - 4ac = ${b}² - 4(${a})(${c}) = ${_formatNumber(discriminant)}',
        explanation: 'The discriminant determines the nature of the roots',
      ));

      if (discriminant > 0) {
        // Two real solutions
        double x1 = (-b + math.sqrt(discriminant)) / (2 * a);
        double x2 = (-b - math.sqrt(discriminant)) / (2 * a);

        steps.add(SolutionStep(
          stepNumber: steps.length + 1,
          description: 'Two Real Solutions',
          equation: 'Δ > 0',
          explanation: 'Since discriminant is positive, there are two distinct real solutions',
        ));

        steps.add(SolutionStep(
          stepNumber: steps.length + 1,
          description: 'Apply Quadratic Formula',
          equation: 'x = (-b ± √Δ) / 2a',
          explanation: 'Use the quadratic formula to find both solutions',
        ));

        steps.add(SolutionStep(
          stepNumber: steps.length + 1,
          description: 'Solution 1',
          equation: 'x₁ = (-${b} + √${_formatNumber(discriminant)}) / ${2 * a} = ${_formatNumber(x1)}',
          explanation: 'First solution using the positive square root',
        ));

        steps.add(SolutionStep(
          stepNumber: steps.length + 1,
          description: 'Solution 2',
          equation: 'x₂ = (-${b} - √${_formatNumber(discriminant)}) / ${2 * a} = ${_formatNumber(x2)}',
          explanation: 'Second solution using the negative square root',
        ));

        steps.add(SolutionStep(
          stepNumber: steps.length + 1,
          description: 'Final Answer',
          equation: 'x = ${_formatNumber(x1)} or x = ${_formatNumber(x2)}',
          explanation: 'The equation has two real solutions',
        ));

      } else if (discriminant == 0) {
        // One real solution (repeated root)
        double x = -b / (2 * a);

        steps.add(SolutionStep(
          stepNumber: steps.length + 1,
          description: 'One Real Solution',
          equation: 'Δ = 0',
          explanation: 'Since discriminant is zero, there is one repeated real solution',
        ));

        steps.add(SolutionStep(
          stepNumber: steps.length + 1,
          description: 'Apply Quadratic Formula',
          equation: 'x = -b / 2a',
          explanation: 'When Δ = 0, the formula simplifies',
        ));

        steps.add(SolutionStep(
          stepNumber: steps.length + 1,
          description: 'Final Answer',
          equation: 'x = -${b} / ${2 * a} = ${_formatNumber(x)}',
          explanation: 'The equation has one repeated real solution',
        ));

      } else {
        // Complex solutions
        double realPart = -b / (2 * a);
        double imaginaryPart = math.sqrt(-discriminant) / (2 * a);

        steps.add(SolutionStep(
          stepNumber: steps.length + 1,
          description: 'Complex Solutions',
          equation: 'Δ < 0',
          explanation: 'Since discriminant is negative, there are two complex conjugate solutions',
        ));

        steps.add(SolutionStep(
          stepNumber: steps.length + 1,
          description: 'Apply Quadratic Formula',
          equation: 'x = (-b ± i√|Δ|) / 2a',
          explanation: 'Use the quadratic formula with imaginary unit i',
        ));

        String x1Str = _formatComplexNumber(realPart, imaginaryPart);
        String x2Str = _formatComplexNumber(realPart, -imaginaryPart);

        steps.add(SolutionStep(
          stepNumber: steps.length + 1,
          description: 'Solution 1',
          equation: 'x₁ = $x1Str',
          explanation: 'First complex solution',
        ));

        steps.add(SolutionStep(
          stepNumber: steps.length + 1,
          description: 'Solution 2',
          equation: 'x₂ = $x2Str',
          explanation: 'Second complex solution (conjugate of the first)',
        ));

        steps.add(SolutionStep(
          stepNumber: steps.length + 1,
          description: 'Final Answer',
          equation: 'x = $x1Str or x = $x2Str',
          explanation: 'The equation has two complex conjugate solutions',
        ));
      }

      return steps;
    } catch (e) {
      throw Exception('Could not solve quadratic equation: ${e.toString()}');
    }
  }

  static List<SolutionStep> _solveCubicEquation(
    String left,
    String right,
    List<SolutionStep> steps
  ) {
    steps.add(SolutionStep(
      stepNumber: steps.length + 1,
      description: 'Cubic Equation Detected',
      equation: 'ax³ + bx² + cx + d = 0',
      explanation: 'This is a cubic equation of degree 3',
    ));

    steps.add(SolutionStep(
      stepNumber: steps.length + 1,
      description: 'Solving Cubic Equations',
      equation: 'Cubic equations can have 1, 2, or 3 real solutions',
      explanation: 'The general solution involves Cardano\'s formula or numerical methods',
    ));

    steps.add(SolutionStep(
      stepNumber: steps.length + 1,
      description: 'Advanced Solution Required',
      equation: 'Use numerical methods or factoring',
      explanation: 'For exact solutions, try factoring or use the cubic formula. Common forms: (x-a)(x²+bx+c)=0',
    ));

    return steps;
  }

  static List<SolutionStep> _solveSimpleEquation(
    String left,
    String right,
    List<SolutionStep> steps
  ) {
    steps.add(SolutionStep(
      stepNumber: steps.length + 1,
      description: 'Complex Equation',
      equation: 'This equation requires advanced solving techniques',
      explanation: 'Try simplifying the equation or use numerical methods',
    ));

    return steps;
  }

  // Helper methods
  static double _extractCoefficient(String left, String right) {
    // Extract coefficient of x from both sides
    double leftCoeff = _getXCoefficient(left);
    double rightCoeff = _getXCoefficient(right);
    return leftCoeff - rightCoeff;
  }

  static double _extractConstant(String left, String right) {
    // Extract constant terms from both sides
    double leftConst = _getConstantTerm(left);
    double rightConst = _getConstantTerm(right);
    return leftConst - rightConst;
  }

  static double _getXCoefficient(String expr) {
    // Simple parser for coefficient of x
    expr = expr.toLowerCase().replaceAll(' ', '');

    if (!expr.contains('x')) return 0.0;

    // Handle cases like: 2x, -3x, x, -x
    RegExp coeffRegex = RegExp(r'([+-]?\d*\.?\d*)x');
    Match? match = coeffRegex.firstMatch(expr);

    if (match != null) {
      String coeffStr = match.group(1) ?? '';
      if (coeffStr.isEmpty || coeffStr == '+') return 1.0;
      if (coeffStr == '-') return -1.0;
      return double.tryParse(coeffStr) ?? 1.0;
    }

    return 0.0;
  }

  static double _getConstantTerm(String expr) {
    // Extract constant term (number without x)
    expr = expr.toLowerCase().replaceAll(' ', '');

    // Remove all terms with x
    String withoutX = expr.replaceAll(RegExp(r'[+-]?\d*\.?\d*x'), '');

    if (withoutX.isEmpty) return 0.0;

    // Try to parse what's left
    try {
      // Handle multiple terms
      double sum = 0.0;
      RegExp numRegex = RegExp(r'[+-]?\d+\.?\d*');
      Iterable<Match> matches = numRegex.allMatches(withoutX);

      for (Match match in matches) {
        String numStr = match.group(0) ?? '0';
        sum += double.tryParse(numStr) ?? 0.0;
      }

      return sum;
    } catch (e) {
      return 0.0;
    }
  }

  static double _getQuadraticCoefficient(String left, String right) {
    // Extract coefficient of x² from both sides
    double leftCoeff = _getX2Coefficient(left);
    double rightCoeff = _getX2Coefficient(right);
    return leftCoeff - rightCoeff;
  }

  static double _getLinearCoefficient(String left, String right) {
    // Extract coefficient of x from both sides (for quadratic)
    return _extractCoefficient(left, right);
  }

  static double _getConstantCoefficient(String left, String right) {
    // Extract constant term from both sides
    return _extractConstant(left, right);
  }

  static double _getX2Coefficient(String expr) {
    // Extract coefficient of x² or x^2
    expr = expr.toLowerCase().replaceAll(' ', '');

    if (!expr.contains('x²') && !expr.contains('x^2')) return 0.0;

    // Normalize x^2 to x²
    expr = expr.replaceAll('x^2', 'x²');

    // Handle cases like: 2x², -3x², x², -x²
    RegExp coeffRegex = RegExp(r'([+-]?\d*\.?\d*)x²');
    Match? match = coeffRegex.firstMatch(expr);

    if (match != null) {
      String coeffStr = match.group(1) ?? '';
      if (coeffStr.isEmpty || coeffStr == '+') return 1.0;
      if (coeffStr == '-') return -1.0;
      return double.tryParse(coeffStr) ?? 1.0;
    }

    return 0.0;
  }

  static String _formatComplexNumber(double real, double imaginary) {
    String realStr = _formatNumber(real);
    String imagStr = _formatNumber(imaginary.abs());

    if (imaginary >= 0) {
      return '$realStr + ${imagStr}i';
    } else {
      return '$realStr - ${imagStr}i';
    }
  }

  static String _formatEquation(String eq) {
    return eq.replaceAll('*', '×').replaceAll('/', '÷');
  }

  static String _formatNumber(double num) {
    if (num == num.roundToDouble()) {
      return num.round().toString();
    }
    return num.toStringAsFixed(2);
  }
}

