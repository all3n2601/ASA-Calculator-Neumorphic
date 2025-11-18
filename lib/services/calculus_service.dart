import '../models/solution_step.dart';

class CalculusService {
  /// Computes the derivative of a function with step-by-step explanation
  static Future<List<SolutionStep>> computeDerivative(String functionStr, String variable) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    List<SolutionStep> steps = [];
    
    try {
      functionStr = functionStr.trim().toLowerCase();
      
      steps.add(SolutionStep(
        stepNumber: 1,
        description: 'Original Function',
        equation: 'f($variable) = $functionStr',
        explanation: 'We need to find the derivative d/d$variable',
      ));

      String derivative = _computeDerivativeSymbolic(functionStr, variable);
      
      steps.add(SolutionStep(
        stepNumber: 2,
        description: 'Apply Differentiation Rules',
        equation: "f'($variable) = $derivative",
        explanation: _getDerivativeExplanation(functionStr, variable),
      ));

      String simplified = _simplifyExpression(derivative);
      if (simplified != derivative) {
        steps.add(SolutionStep(
          stepNumber: 3,
          description: 'Simplify',
          equation: "f'($variable) = $simplified",
          explanation: 'Simplify the expression',
        ));
      }

      steps.add(SolutionStep(
        stepNumber: steps.length + 1,
        description: 'Final Answer',
        equation: "d/d$variable [$functionStr] = $simplified",
        explanation: 'The derivative of the function',
      ));

      return steps;
    } catch (e) {
      throw Exception('Could not compute derivative: ${e.toString()}');
    }
  }

  /// Computes the integral of a function with step-by-step explanation
  static Future<List<SolutionStep>> computeIntegral(String functionStr, String variable) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    List<SolutionStep> steps = [];
    
    try {
      functionStr = functionStr.trim().toLowerCase();
      
      steps.add(SolutionStep(
        stepNumber: 1,
        description: 'Original Function',
        equation: 'f($variable) = $functionStr',
        explanation: 'We need to find the indefinite integral ∫ f($variable) d$variable',
      ));

      String integral = _computeIntegralSymbolic(functionStr, variable);
      
      steps.add(SolutionStep(
        stepNumber: 2,
        description: 'Apply Integration Rules',
        equation: '∫ $functionStr d$variable = $integral',
        explanation: _getIntegralExplanation(functionStr, variable),
      ));

      String simplified = _simplifyExpression(integral);
      if (simplified != integral) {
        steps.add(SolutionStep(
          stepNumber: 3,
          description: 'Simplify',
          equation: '∫ $functionStr d$variable = $simplified',
          explanation: 'Simplify the expression',
        ));
      }

      steps.add(SolutionStep(
        stepNumber: steps.length + 1,
        description: 'Final Answer',
        equation: '∫ $functionStr d$variable = $simplified + C',
        explanation: 'The indefinite integral (don\'t forget the constant of integration C)',
      ));

      return steps;
    } catch (e) {
      throw Exception('Could not compute integral: ${e.toString()}');
    }
  }

  /// Symbolic derivative computation
  static String _computeDerivativeSymbolic(String expr, String variable) {
    expr = expr.replaceAll(' ', '');
    
    // Power rule: x^n -> n*x^(n-1)
    if (RegExp(r'^' + variable + r'\^(\d+)$').hasMatch(expr)) {
      Match? match = RegExp(r'^' + variable + r'\^(\d+)$').firstMatch(expr);
      int n = int.parse(match!.group(1)!);
      if (n == 1) return '1';
      if (n == 2) return '2*$variable';
      return '$n*$variable^${n - 1}';
    }
    
    // Constant rule
    if (!expr.contains(variable)) {
      return '0';
    }
    
    // Linear: x -> 1
    if (expr == variable) {
      return '1';
    }
    
    // Coefficient: c*x -> c
    if (RegExp(r'^(\d+)\*' + variable + r'$').hasMatch(expr)) {
      Match? match = RegExp(r'^(\d+)\*' + variable + r'$').firstMatch(expr);
      return match!.group(1)!;
    }
    
    // Coefficient with power: c*x^n -> c*n*x^(n-1)
    if (RegExp(r'^(\d+)\*' + variable + r'\^(\d+)$').hasMatch(expr)) {
      Match? match = RegExp(r'^(\d+)\*' + variable + r'\^(\d+)$').firstMatch(expr);
      int c = int.parse(match!.group(1)!);
      int n = int.parse(match.group(2)!);
      if (n == 1) return '$c';
      if (n == 2) return '${c * 2}*$variable';
      return '${c * n}*$variable^${n - 1}';
    }
    
    // Trigonometric functions
    if (expr.startsWith('sin($variable)')) return 'cos($variable)';
    if (expr.startsWith('cos($variable)')) return '-sin($variable)';
    if (expr.startsWith('tan($variable)')) return 'sec²($variable)';
    
    // Exponential
    if (expr == 'e^$variable') return 'e^$variable';
    if (expr.startsWith('e^')) return expr; // e^x -> e^x
    
    // Logarithmic
    if (expr == 'ln($variable)') return '1/$variable';
    if (expr == 'log($variable)') return '1/($variable*ln(10))';
    
    // Default: show symbolic derivative
    return "d/d$variable[$expr]";
  }

  static String _getDerivativeExplanation(String expr, String variable) {
    if (expr.contains('^')) return 'Using the power rule: d/dx[x^n] = n*x^(n-1)';
    if (expr.contains('sin')) return 'Using the rule: d/dx[sin(x)] = cos(x)';
    if (expr.contains('cos')) return 'Using the rule: d/dx[cos(x)] = -sin(x)';
    if (expr.contains('tan')) return 'Using the rule: d/dx[tan(x)] = sec²(x)';
    if (expr.contains('e^')) return 'Using the rule: d/dx[e^x] = e^x';
    if (expr.contains('ln')) return 'Using the rule: d/dx[ln(x)] = 1/x';
    if (expr == variable) return 'Using the rule: d/dx[x] = 1';
    if (!expr.contains(variable)) return 'The derivative of a constant is 0';
    return 'Applying differentiation rules';
  }

  /// Symbolic integral computation
  static String _computeIntegralSymbolic(String expr, String variable) {
    expr = expr.replaceAll(' ', '');

    // Power rule: x^n -> x^(n+1)/(n+1)
    if (RegExp(r'^' + variable + r'\^(\d+)$').hasMatch(expr)) {
      Match? match = RegExp(r'^' + variable + r'\^(\d+)$').firstMatch(expr);
      int n = int.parse(match!.group(1)!);
      int newPower = n + 1;
      return '$variable^$newPower/$newPower';
    }

    // Constant
    if (!expr.contains(variable)) {
      return '$expr*$variable';
    }

    // Linear: x -> x^2/2
    if (expr == variable) {
      return '$variable²/2';
    }

    // Constant: 1 -> x
    if (expr == '1') {
      return variable;
    }

    // Coefficient: c*x -> c*x^2/2
    if (RegExp(r'^(\d+)\*' + variable + r'$').hasMatch(expr)) {
      Match? match = RegExp(r'^(\d+)\*' + variable + r'$').firstMatch(expr);
      String c = match!.group(1)!;
      return '$c*$variable²/2';
    }

    // Coefficient with power: c*x^n -> c*x^(n+1)/(n+1)
    if (RegExp(r'^(\d+)\*' + variable + r'\^(\d+)$').hasMatch(expr)) {
      Match? match = RegExp(r'^(\d+)\*' + variable + r'\^(\d+)$').firstMatch(expr);
      int c = int.parse(match!.group(1)!);
      int n = int.parse(match.group(2)!);
      int newPower = n + 1;
      return '${c}*$variable^$newPower/$newPower';
    }

    // 1/x -> ln|x|
    if (expr == '1/$variable') {
      return 'ln|$variable|';
    }

    // Trigonometric functions
    if (expr == 'sin($variable)') return '-cos($variable)';
    if (expr == 'cos($variable)') return 'sin($variable)';
    if (expr == 'tan($variable)') return '-ln|cos($variable)|';
    if (expr == 'sec($variable)') return 'ln|sec($variable)+tan($variable)|';

    // Exponential
    if (expr == 'e^$variable') return 'e^$variable';

    // 1/x -> ln(x)
    if (expr.contains('1/$variable')) return 'ln|$variable|';

    // Default: show symbolic integral
    return "∫ $expr d$variable";
  }

  static String _getIntegralExplanation(String expr, String variable) {
    if (expr.contains('^')) return 'Using the power rule: ∫ x^n dx = x^(n+1)/(n+1) + C';
    if (expr.contains('sin')) return 'Using the rule: ∫ sin(x) dx = -cos(x) + C';
    if (expr.contains('cos')) return 'Using the rule: ∫ cos(x) dx = sin(x) + C';
    if (expr.contains('tan')) return 'Using the rule: ∫ tan(x) dx = -ln|cos(x)| + C';
    if (expr.contains('e^')) return 'Using the rule: ∫ e^x dx = e^x + C';
    if (expr.contains('1/$variable')) return 'Using the rule: ∫ 1/x dx = ln|x| + C';
    if (expr == variable) return 'Using the rule: ∫ x dx = x²/2 + C';
    if (!expr.contains(variable)) return 'The integral of a constant k is k*x + C';
    return 'Applying integration rules';
  }

  static String _simplifyExpression(String expr) {
    // Remove unnecessary parentheses and simplify
    expr = expr.replaceAll('1*', '');
    expr = expr.replaceAll('*1', '');
    expr = expr.replaceAll('+0', '');
    expr = expr.replaceAll('-0', '');

    // Simplify x^1 to x
    expr = expr.replaceAll(RegExp(r'([a-z])\^1(?!\d)'), r'\1');

    return expr;
  }
}

