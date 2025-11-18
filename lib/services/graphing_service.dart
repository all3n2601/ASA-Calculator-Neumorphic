import 'package:math_expressions/math_expressions.dart';

class GraphingService {
  /// Preprocesses function string to handle log10 and other custom functions
  static String _preprocessFunction(String functionStr) {
    // Convert log(x) to ln(x)/ln(10) for base-10 logarithm
    // Use regex to find log(...) patterns and replace them
    String processed = functionStr;

    // Handle log10 - convert log(expression) to ln(expression)/ln(10)
    // This regex matches log followed by parentheses with content
    RegExp logRegex = RegExp(r'log\(([^)]+)\)');
    processed = processed.replaceAllMapped(logRegex, (match) {
      String inner = match.group(1)!;
      return '(ln($inner)/ln(10))';
    });

    return processed;
  }

  /// Validates if a function string is valid
  static void validateFunction(String functionStr) {
    if (functionStr.trim().isEmpty) {
      throw Exception('Function cannot be empty');
    }

    try {
      String processed = _preprocessFunction(functionStr);
      Parser parser = Parser();
      Expression exp = parser.parse(processed);

      // Test with a sample value
      ContextModel cm = ContextModel();
      Variable xVar = Variable('x');
      cm.bindVariable(xVar, Number(1)); // Use 1 instead of 0 to avoid log(0)

      exp.evaluate(EvaluationType.REAL, cm);
    } catch (e) {
      throw Exception('Invalid function syntax');
    }
  }

  /// Evaluates a function at a given x value
  static double? evaluateFunction(String functionStr, double x) {
    try {
      String processed = _preprocessFunction(functionStr);
      Parser parser = Parser();
      Expression exp = parser.parse(processed);

      ContextModel cm = ContextModel();
      Variable xVar = Variable('x');
      cm.bindVariable(xVar, Number(x));

      double result = exp.evaluate(EvaluationType.REAL, cm);

      if (result.isFinite) {
        return result;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Finds the roots (zeros) of a function in a given range
  static List<double> findRoots(String functionStr, double minX, double maxX) {
    List<double> roots = [];
    double step = (maxX - minX) / 1000;
    
    double? prevY;
    double prevX = minX;
    
    for (double x = minX; x <= maxX; x += step) {
      double? y = evaluateFunction(functionStr, x);
      
      if (y != null) {
        if (y.abs() < 0.001) {
          // Very close to zero
          roots.add(x);
        } else if (prevY != null && prevY * y < 0) {
          // Sign change detected, root between prevX and x
          roots.add((prevX + x) / 2);
        }
        prevY = y;
        prevX = x;
      }
    }
    
    return roots;
  }

  /// Finds local maxima and minima
  static Map<String, List<double>> findExtrema(String functionStr, double minX, double maxX) {
    List<double> maxima = [];
    List<double> minima = [];
    
    double step = (maxX - minX) / 1000;
    
    double? prevY;
    double? prevPrevY;
    double prevX = minX;
    
    for (double x = minX + step; x <= maxX - step; x += step) {
      double? y = evaluateFunction(functionStr, x);
      
      if (y != null && prevY != null && prevPrevY != null) {
        // Check for local maximum
        if (prevY > y && prevY > prevPrevY) {
          maxima.add(prevX);
        }
        // Check for local minimum
        if (prevY < y && prevY < prevPrevY) {
          minima.add(prevX);
        }
      }
      
      prevPrevY = prevY;
      prevY = y;
      prevX = x;
    }
    
    return {
      'maxima': maxima,
      'minima': minima,
    };
  }

  /// Calculates the derivative at a point (numerical approximation)
  static double? derivative(String functionStr, double x) {
    double h = 0.0001;
    double? y1 = evaluateFunction(functionStr, x - h);
    double? y2 = evaluateFunction(functionStr, x + h);
    
    if (y1 != null && y2 != null) {
      return (y2 - y1) / (2 * h);
    }
    return null;
  }

  /// Calculates the integral (area under curve) using trapezoidal rule
  static double? integrate(String functionStr, double a, double b, {int steps = 1000}) {
    double h = (b - a) / steps;
    double sum = 0;
    
    double? y0 = evaluateFunction(functionStr, a);
    if (y0 == null) return null;
    
    for (int i = 1; i <= steps; i++) {
      double x = a + i * h;
      double? y = evaluateFunction(functionStr, x);
      
      if (y == null) return null;
      
      sum += y;
    }
    
    return h * (y0 / 2 + sum + (evaluateFunction(functionStr, b) ?? 0) / 2);
  }
}

