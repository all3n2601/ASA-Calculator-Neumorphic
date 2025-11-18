import 'package:flutter_test/flutter_test.dart';
import 'package:asa_calculator/services/graphing_service.dart';

void main() {
  group('Graphing Service - Function Validation', () {
    test('Valid simple function: x', () {
      expect(() => GraphingService.validateFunction('x'), returnsNormally);
    });

    test('Valid power function: x^2', () {
      expect(() => GraphingService.validateFunction('x^2'), returnsNormally);
    });

    test('Valid trigonometric: sin(x)', () {
      expect(() => GraphingService.validateFunction('sin(x)'), returnsNormally);
    });

    test('Valid exponential: e^x', () {
      expect(() => GraphingService.validateFunction('e^x'), returnsNormally);
    });

    test('Valid logarithmic: ln(x)', () {
      expect(() => GraphingService.validateFunction('ln(x)'), returnsNormally);
    });

    test('Valid complex: 2*x+1', () {
      expect(() => GraphingService.validateFunction('2*x+1'), returnsNormally);
    });

    test('Valid nested: sin(x^2)', () {
      expect(() => GraphingService.validateFunction('sin(x^2)'), returnsNormally);
    });

    test('Empty function throws error', () {
      expect(() => GraphingService.validateFunction(''), throwsException);
    });

    test('Whitespace only throws error', () {
      expect(() => GraphingService.validateFunction('   '), throwsException);
    });

    test('Invalid syntax throws error', () {
      expect(() => GraphingService.validateFunction('x +* 2'), throwsException);
    });
  });

  group('Graphing Service - Function Evaluation', () {
    test('Evaluate linear: x at x=5', () {
      final result = GraphingService.evaluateFunction('x', 5);
      expect(result, equals(5.0));
    });

    test('Evaluate quadratic: x^2 at x=3', () {
      final result = GraphingService.evaluateFunction('x^2', 3);
      expect(result, equals(9.0));
    });

    test('Evaluate cubic: x^3 at x=2', () {
      final result = GraphingService.evaluateFunction('x^3', 2);
      expect(result, equals(8.0));
    });

    test('Evaluate constant: 5 at x=10', () {
      final result = GraphingService.evaluateFunction('5', 10);
      expect(result, equals(5.0));
    });

    test('Evaluate with coefficient: 2*x at x=4', () {
      final result = GraphingService.evaluateFunction('2*x', 4);
      expect(result, equals(8.0));
    });

    test('Evaluate addition: x+5 at x=3', () {
      final result = GraphingService.evaluateFunction('x+5', 3);
      expect(result, equals(8.0));
    });

    test('Evaluate subtraction: x-2 at x=7', () {
      final result = GraphingService.evaluateFunction('x-2', 7);
      expect(result, equals(5.0));
    });

    test('Evaluate multiplication: 3*x at x=4', () {
      final result = GraphingService.evaluateFunction('3*x', 4);
      expect(result, equals(12.0));
    });

    test('Evaluate division: x/2 at x=10', () {
      final result = GraphingService.evaluateFunction('x/2', 10);
      expect(result, equals(5.0));
    });

    test('Evaluate negative: -x at x=5', () {
      final result = GraphingService.evaluateFunction('-x', 5);
      expect(result, equals(-5.0));
    });

    test('Evaluate at zero: x^2 at x=0', () {
      final result = GraphingService.evaluateFunction('x^2', 0);
      expect(result, equals(0.0));
    });

    test('Evaluate at negative: x^2 at x=-3', () {
      final result = GraphingService.evaluateFunction('x^2', -3);
      expect(result, equals(9.0));
    });
  });

  group('Graphing Service - Trigonometric Functions', () {
    test('Evaluate sin(0)', () {
      final result = GraphingService.evaluateFunction('sin(x)', 0);
      expect(result, closeTo(0.0, 0.001));
    });

    test('Evaluate cos(0)', () {
      final result = GraphingService.evaluateFunction('cos(x)', 0);
      expect(result, closeTo(1.0, 0.001));
    });

    test('Evaluate tan(0)', () {
      final result = GraphingService.evaluateFunction('tan(x)', 0);
      expect(result, closeTo(0.0, 0.001));
    });

    test('Evaluate sin(π/2)', () {
      final result = GraphingService.evaluateFunction('sin(x)', 3.14159265359 / 2);
      expect(result, closeTo(1.0, 0.001));
    });

    test('Evaluate cos(π)', () {
      final result = GraphingService.evaluateFunction('cos(x)', 3.14159265359);
      expect(result, closeTo(-1.0, 0.001));
    });
  });

  group('Graphing Service - Exponential and Logarithmic', () {
    test('Evaluate e^0', () {
      final result = GraphingService.evaluateFunction('e^x', 0);
      expect(result, closeTo(1.0, 0.001));
    });

    test('Evaluate e^1', () {
      final result = GraphingService.evaluateFunction('e^x', 1);
      expect(result, closeTo(2.71828, 0.001));
    });

    test('Evaluate ln(1)', () {
      final result = GraphingService.evaluateFunction('ln(x)', 1);
      expect(result, closeTo(0.0, 0.001));
    });

    test('Evaluate ln(e)', () {
      final result = GraphingService.evaluateFunction('ln(x)', 2.71828);
      expect(result, closeTo(1.0, 0.001));
    });

    test('Evaluate log(10)', () {
      final result = GraphingService.evaluateFunction('log(x)', 10);
      expect(result, closeTo(1.0, 0.001));
    });

    test('Evaluate log(100)', () {
      final result = GraphingService.evaluateFunction('log(x)', 100);
      expect(result, closeTo(2.0, 0.001));
    });

    test('Evaluate log(1000)', () {
      final result = GraphingService.evaluateFunction('log(x)', 1000);
      expect(result, closeTo(3.0, 0.001));
    });

    test('Evaluate log(x) at x=1', () {
      final result = GraphingService.evaluateFunction('log(x)', 1);
      expect(result, closeTo(0.0, 0.001));
    });

    test('Evaluate complex with log: log(x^2) at x=10', () {
      final result = GraphingService.evaluateFunction('log(x^2)', 10);
      expect(result, closeTo(2.0, 0.001)); // log(100) = 2
    });

    test('Validate log function', () {
      expect(() => GraphingService.validateFunction('log(x)'), returnsNormally);
    });
  });

  group('Graphing Service - Complex Functions', () {
    test('Evaluate polynomial: x^3 - 2*x^2 + x - 1 at x=2', () {
      final result = GraphingService.evaluateFunction('x^3 - 2*x^2 + x - 1', 2);
      expect(result, closeTo(1.0, 0.001)); // 8 - 8 + 2 - 1 = 1
    });

    test('Evaluate rational: 1/x at x=2', () {
      final result = GraphingService.evaluateFunction('1/x', 2);
      expect(result, closeTo(0.5, 0.001));
    });

    test('Evaluate square root: sqrt(x) at x=4', () {
      final result = GraphingService.evaluateFunction('sqrt(x)', 4);
      expect(result, closeTo(2.0, 0.001));
    });

    test('Evaluate square root: sqrt(x) at x=9', () {
      final result = GraphingService.evaluateFunction('sqrt(x)', 9);
      expect(result, closeTo(3.0, 0.001));
    });

    test('Evaluate absolute value: abs(x) at x=-5', () {
      final result = GraphingService.evaluateFunction('abs(x)', -5);
      expect(result, closeTo(5.0, 0.001));
    });

    test('Evaluate composite: sin(x^2) at x=1', () {
      final result = GraphingService.evaluateFunction('sin(x^2)', 1);
      expect(result, closeTo(0.8414, 0.001));
    });

    test('Evaluate composite: e^(-x^2) at x=0', () {
      final result = GraphingService.evaluateFunction('e^(-x^2)', 0);
      expect(result, closeTo(1.0, 0.001));
    });

    test('Evaluate product: x*sin(x) at x=1', () {
      final result = GraphingService.evaluateFunction('x*sin(x)', 1);
      expect(result, closeTo(0.8414, 0.001));
    });
  });

  group('Graphing Service - Root Finding', () {
    test('Find roots of x-2 in range [0, 5]', () {
      final roots = GraphingService.findRoots('x-2', 0, 5);
      expect(roots.isNotEmpty, true);
      expect(roots[0], closeTo(2.0, 0.1));
    });

    test('Find roots of x^2-4 in range [-5, 5]', () {
      final roots = GraphingService.findRoots('x^2-4', -5, 5);
      expect(roots.length >= 2, true);
      // Should find roots near -2 and 2
    });

    test('Find roots of sin(x) in range [0, 7]', () {
      final roots = GraphingService.findRoots('sin(x)', 0, 7);
      expect(roots.isNotEmpty, true);
      // Should find roots near 0, π, 2π
    });

    test('No roots for x^2+1 in range [-5, 5]', () {
      final roots = GraphingService.findRoots('x^2+1', -5, 5);
      expect(roots.isEmpty, true);
    });
  });

  group('Graphing Service - Extrema Finding', () {
    test('Find extrema of x^2 in range [-5, 5]', () {
      final extrema = GraphingService.findExtrema('x^2', -5, 5);
      expect(extrema.containsKey('minima'), true);
      expect(extrema.containsKey('maxima'), true);

      // x^2 has a minimum at x=0
      expect(extrema['minima']!.isNotEmpty, true);
    });

    test('Find extrema of -x^2 in range [-5, 5]', () {
      final extrema = GraphingService.findExtrema('-x^2', -5, 5);

      // -x^2 has a maximum at x=0
      expect(extrema['maxima']!.isNotEmpty, true);
    });

    test('Find extrema of sin(x) in range [0, 7]', () {
      final extrema = GraphingService.findExtrema('sin(x)', 0, 7);

      // sin(x) has both maxima and minima
      expect(extrema['maxima']!.isNotEmpty, true);
      expect(extrema['minima']!.isNotEmpty, true);
    });
  });

  group('Graphing Service - Derivative', () {
    test('Numerical derivative of x^2 at x=2', () {
      final result = GraphingService.derivative('x^2', 2);
      expect(result, closeTo(4.0, 0.01)); // d/dx[x^2] = 2x, at x=2 is 4
    });

    test('Numerical derivative of x^3 at x=1', () {
      final result = GraphingService.derivative('x^3', 1);
      expect(result, closeTo(3.0, 0.01)); // d/dx[x^3] = 3x^2, at x=1 is 3
    });

    test('Numerical derivative of sin(x) at x=0', () {
      final result = GraphingService.derivative('sin(x)', 0);
      expect(result, closeTo(1.0, 0.01)); // d/dx[sin(x)] = cos(x), at x=0 is 1
    });

    test('Numerical derivative of constant at x=5', () {
      final result = GraphingService.derivative('5', 5);
      expect(result, closeTo(0.0, 0.01)); // d/dx[5] = 0
    });
  });

  group('Graphing Service - Integration', () {
    test('Integrate x from 0 to 1', () {
      final result = GraphingService.integrate('x', 0, 1);
      expect(result, closeTo(0.5, 0.01)); // ∫x dx from 0 to 1 = 0.5
    });

    test('Integrate x^2 from 0 to 1', () {
      final result = GraphingService.integrate('x^2', 0, 1);
      expect(result, closeTo(0.333, 0.01)); // ∫x^2 dx from 0 to 1 = 1/3
    });

    test('Integrate constant 5 from 0 to 2', () {
      final result = GraphingService.integrate('5', 0, 2);
      expect(result, closeTo(10.0, 0.01)); // ∫5 dx from 0 to 2 = 10
    });

    test('Integrate sin(x) from 0 to π', () {
      final result = GraphingService.integrate('sin(x)', 0, 3.14159);
      expect(result, closeTo(2.0, 0.1)); // ∫sin(x) dx from 0 to π ≈ 2
    });
  });

  group('Graphing Service - Edge Cases', () {
    test('Evaluate at very large x', () {
      final result = GraphingService.evaluateFunction('x', 1000000);
      expect(result, equals(1000000.0));
    });

    test('Evaluate at very small x', () {
      final result = GraphingService.evaluateFunction('x', 0.000001);
      expect(result, closeTo(0.000001, 0.0000001));
    });

    test('Evaluate undefined: 1/x at x=0', () {
      final result = GraphingService.evaluateFunction('1/x', 0);
      expect(result, isNull); // Should return null for undefined
    });

    test('Evaluate undefined: ln(x) at x=0', () {
      final result = GraphingService.evaluateFunction('ln(x)', 0);
      expect(result, isNull); // Should return null for undefined
    });

    test('Evaluate undefined: sqrt(x) at x=-1', () {
      final result = GraphingService.evaluateFunction('sqrt(x)', -1);
      expect(result, isNull); // Should return null for complex result
    });

    test('Invalid function returns null', () {
      final result = GraphingService.evaluateFunction('invalid', 5);
      expect(result, isNull);
    });
  });

  group('Graphing Service - Performance', () {
    test('Evaluate function 1000 times', () {
      for (int i = 0; i < 1000; i++) {
        final result = GraphingService.evaluateFunction('x^2', i.toDouble());
        expect(result, isNotNull);
      }
    });

    test('Validate multiple functions', () {
      final functions = ['x', 'x^2', 'sin(x)', 'cos(x)', 'e^x', 'ln(x)'];
      for (var func in functions) {
        expect(() => GraphingService.validateFunction(func), returnsNormally);
      }
    });
  });
}


