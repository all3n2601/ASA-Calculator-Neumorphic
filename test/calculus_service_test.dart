import 'package:flutter_test/flutter_test.dart';
import 'package:asa_calculator/services/calculus_service.dart';
import 'package:asa_calculator/models/solution_step.dart';

void main() {
  group('Calculus Service - Derivatives', () {
    test('Simple power rule: x^2', () async {
      final steps = await CalculusService.computeDerivative('x^2', 'x');
      
      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('2*x'), true);
    });

    test('Power rule with coefficient: 3*x^2', () async {
      final steps = await CalculusService.computeDerivative('3*x^2', 'x');
      
      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('6*x'), true);
    });

    test('Higher power: x^5', () async {
      final steps = await CalculusService.computeDerivative('x^5', 'x');
      
      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('5*x^4'), true);
    });

    test('Linear function: x', () async {
      final steps = await CalculusService.computeDerivative('x', 'x');
      
      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('1'), true);
    });

    test('Constant: 5', () async {
      final steps = await CalculusService.computeDerivative('5', 'x');
      
      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('0'), true);
    });

    test('Coefficient with x: 7*x', () async {
      final steps = await CalculusService.computeDerivative('7*x', 'x');
      
      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('7'), true);
    });

    test('Trigonometric: sin(x)', () async {
      final steps = await CalculusService.computeDerivative('sin(x)', 'x');
      
      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('cos(x)'), true);
    });

    test('Trigonometric: cos(x)', () async {
      final steps = await CalculusService.computeDerivative('cos(x)', 'x');
      
      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('-sin(x)'), true);
    });

    test('Trigonometric: tan(x)', () async {
      final steps = await CalculusService.computeDerivative('tan(x)', 'x');
      
      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('sec'), true);
    });

    test('Exponential: e^x', () async {
      final steps = await CalculusService.computeDerivative('e^x', 'x');
      
      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('e^x'), true);
    });

    test('Logarithmic: ln(x)', () async {
      final steps = await CalculusService.computeDerivative('ln(x)', 'x');
      
      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('1/x'), true);
    });

    test('Logarithmic: log(x)', () async {
      final steps = await CalculusService.computeDerivative('log(x)', 'x');
      
      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('1/'), true);
    });

    test('Complex: 5*x^3', () async {
      final steps = await CalculusService.computeDerivative('5*x^3', 'x');
      
      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('15*x^2'), true);
    });

    test('Different variable: y^2 with respect to y', () async {
      final steps = await CalculusService.computeDerivative('y^2', 'y');
      
      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('2*y'), true);
    });

    test('Edge case: x^1', () async {
      final steps = await CalculusService.computeDerivative('x^1', 'x');
      
      expect(steps.isNotEmpty, true);
      // x^1 derivative should be 1
      expect(steps.last.equation.contains('1'), true);
    });
  });

  group('Calculus Service - Integrals', () {
    test('Simple power rule: x', () async {
      final steps = await CalculusService.computeIntegral('x', 'x');
      
      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('x²/2'), true);
      expect(steps.last.equation.contains('C'), true);
    });

    test('Power rule: x^2', () async {
      final steps = await CalculusService.computeIntegral('x^2', 'x');
      
      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('x^3/3'), true);
      expect(steps.last.equation.contains('C'), true);
    });

    test('Power rule with coefficient: 3*x', () async {
      final steps = await CalculusService.computeIntegral('3*x', 'x');
      
      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('3*x²/2'), true);
      expect(steps.last.equation.contains('C'), true);
    });

    test('Higher power: x^4', () async {
      final steps = await CalculusService.computeIntegral('x^4', 'x');
      
      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('x^5/5'), true);
    });

    test('Constant: 5', () async {
      final steps = await CalculusService.computeIntegral('5', 'x');
      
      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('5*x'), true);
      expect(steps.last.equation.contains('C'), true);
    });

    test('Constant: 1', () async {
      final steps = await CalculusService.computeIntegral('1', 'x');

      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('x'), true);
    });

    test('Reciprocal: 1/x', () async {
      final steps = await CalculusService.computeIntegral('1/x', 'x');

      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('ln'), true);
    });

    test('Trigonometric: sin(x)', () async {
      final steps = await CalculusService.computeIntegral('sin(x)', 'x');

      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('-cos(x)'), true);
      expect(steps.last.equation.contains('C'), true);
    });

    test('Trigonometric: cos(x)', () async {
      final steps = await CalculusService.computeIntegral('cos(x)', 'x');

      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('sin(x)'), true);
      expect(steps.last.equation.contains('C'), true);
    });

    test('Exponential: e^x', () async {
      final steps = await CalculusService.computeIntegral('e^x', 'x');

      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('e^x'), true);
      expect(steps.last.equation.contains('C'), true);
    });

    test('Complex: 4*x^3', () async {
      final steps = await CalculusService.computeIntegral('4*x^3', 'x');

      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('4*x^4/4'), true);
    });

    test('Different variable: y with respect to y', () async {
      final steps = await CalculusService.computeIntegral('y', 'y');

      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('y²/2'), true);
    });

    test('Edge case: x^1', () async {
      final steps = await CalculusService.computeIntegral('x^1', 'x');

      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('x^2/2'), true);
    });
  });

  group('Calculus Service - Complex Cases', () {
    test('Derivative: Large power x^10', () async {
      final steps = await CalculusService.computeDerivative('x^10', 'x');

      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('10*x^9'), true);
    });

    test('Derivative: Large coefficient 100*x^2', () async {
      final steps = await CalculusService.computeDerivative('100*x^2', 'x');

      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('200*x'), true);
    });

    test('Integral: Large power x^8', () async {
      final steps = await CalculusService.computeIntegral('x^8', 'x');

      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('x^9/9'), true);
    });

    test('Integral: Large coefficient 50*x^2', () async {
      final steps = await CalculusService.computeIntegral('50*x^2', 'x');

      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('50*x^3/3'), true);
    });

    test('Derivative: Zero constant', () async {
      final steps = await CalculusService.computeDerivative('0', 'x');

      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('0'), true);
    });

    test('Integral: Zero constant', () async {
      final steps = await CalculusService.computeIntegral('0', 'x');

      expect(steps.isNotEmpty, true);
      expect(steps.last.equation.contains('0*x'), true);
    });
  });

  group('Calculus Service - Edge Cases', () {
    test('Empty function should handle gracefully', () async {
      try {
        await CalculusService.computeDerivative('', 'x');
        // If it doesn't throw, it should return steps with error
      } catch (e) {
        expect(e, isNotNull);
      }
    });

    test('Whitespace only should handle gracefully', () async {
      try {
        await CalculusService.computeDerivative('   ', 'x');
        // If it doesn't throw, it should return steps with error
      } catch (e) {
        expect(e, isNotNull);
      }
    });

    test('Case insensitivity: X^2', () async {
      final steps = await CalculusService.computeDerivative('X^2', 'x');

      expect(steps.isNotEmpty, true);
    });

    test('Case insensitivity: SIN(X)', () async {
      final steps = await CalculusService.computeDerivative('SIN(X)', 'x');

      expect(steps.isNotEmpty, true);
    });

    test('Multiple steps verification', () async {
      final steps = await CalculusService.computeDerivative('x^2', 'x');

      // Should have at least: original, apply rules, final answer
      expect(steps.length >= 3, true);

      // First step should be original function
      expect(steps[0].description.toLowerCase().contains('original'), true);

      // Last step should be final answer
      expect(steps.last.description.toLowerCase().contains('final'), true);
    });

    test('Step explanations exist', () async {
      final steps = await CalculusService.computeDerivative('x^2', 'x');

      // Each step should have an explanation
      for (var step in steps) {
        expect(step.explanation.isNotEmpty, true);
      }
    });

    test('Integral includes constant of integration', () async {
      final steps = await CalculusService.computeIntegral('x', 'x');

      // Final answer should include + C
      expect(steps.last.equation.contains('C'), true);
    });
  });
}


