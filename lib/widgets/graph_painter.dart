import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class GraphPainter extends CustomPainter {
  final List<String> functions;
  final List<Color> functionColors;
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;
  final bool darkMode;

  GraphPainter({
    required this.functions,
    required this.functionColors,
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    required this.darkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final bgPaint = Paint()
      ..color = darkMode ? const Color(0xFF1A1F2E) : Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Draw grid
    _drawGrid(canvas, size);

    // Draw axes
    _drawAxes(canvas, size);

    // Draw functions
    for (int i = 0; i < functions.length; i++) {
      _drawFunction(
        canvas,
        size,
        functions[i],
        functionColors[i % functionColors.length],
      );
    }

    // Draw axis labels
    _drawLabels(canvas, size);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = (darkMode ? Colors.white : Colors.black).withValues(alpha: 0.1)
      ..strokeWidth = 0.5;

    // Vertical grid lines
    double xStep = (maxX - minX) / 10;
    for (double x = minX; x <= maxX; x += xStep) {
      double screenX = _mapXToScreen(x, size.width);
      canvas.drawLine(
        Offset(screenX, 0),
        Offset(screenX, size.height),
        gridPaint,
      );
    }

    // Horizontal grid lines
    double yStep = (maxY - minY) / 10;
    for (double y = minY; y <= maxY; y += yStep) {
      double screenY = _mapYToScreen(y, size.height);
      canvas.drawLine(
        Offset(0, screenY),
        Offset(size.width, screenY),
        gridPaint,
      );
    }
  }

  void _drawAxes(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = darkMode ? Colors.white : Colors.black
      ..strokeWidth = 2;

    // X-axis (y = 0)
    if (minY <= 0 && maxY >= 0) {
      double y0 = _mapYToScreen(0, size.height);
      canvas.drawLine(
        Offset(0, y0),
        Offset(size.width, y0),
        axisPaint,
      );
    }

    // Y-axis (x = 0)
    if (minX <= 0 && maxX >= 0) {
      double x0 = _mapXToScreen(0, size.width);
      canvas.drawLine(
        Offset(x0, 0),
        Offset(x0, size.height),
        axisPaint,
      );
    }
  }

  String _preprocessFunction(String functionStr) {
    // Convert log(x) to ln(x)/ln(10) for base-10 logarithm
    String processed = functionStr;

    RegExp logRegex = RegExp(r'log\(([^)]+)\)');
    processed = processed.replaceAllMapped(logRegex, (match) {
      String inner = match.group(1)!;
      return '(ln($inner)/ln(10))';
    });

    return processed;
  }

  void _drawFunction(Canvas canvas, Size size, String functionStr, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    try {
      String processed = _preprocessFunction(functionStr);
      Parser parser = Parser();
      Expression exp = parser.parse(processed);

      Path path = Path();
      bool pathStarted = false;

      // Sample points
      int numPoints = 500;
      double step = (maxX - minX) / numPoints;

      for (int i = 0; i <= numPoints; i++) {
        double x = minX + i * step;
        
        try {
          ContextModel cm = ContextModel();
          Variable xVar = Variable('x');
          cm.bindVariable(xVar, Number(x));
          
          double y = exp.evaluate(EvaluationType.REAL, cm);

          // Check if y is valid
          if (y.isFinite && y >= minY && y <= maxY) {
            double screenX = _mapXToScreen(x, size.width);
            double screenY = _mapYToScreen(y, size.height);

            if (!pathStarted) {
              path.moveTo(screenX, screenY);
              pathStarted = true;
            } else {
              path.lineTo(screenX, screenY);
            }
          } else {
            pathStarted = false;
          }
        } catch (e) {
          pathStarted = false;
        }
      }

      canvas.drawPath(path, paint);
    } catch (e) {
      // Invalid function, skip drawing
    }
  }

  void _drawLabels(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      color: darkMode ? Colors.white : Colors.black,
      fontSize: 10,
    );

    // X-axis labels
    double xStep = (maxX - minX) / 5;
    for (double x = minX; x <= maxX; x += xStep) {
      if (x.abs() < 0.01) continue; // Skip 0
      double screenX = _mapXToScreen(x, size.width);
      
      final textSpan = TextSpan(
        text: x.toStringAsFixed(1),
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(screenX - 10, size.height - 20));
    }

    // Y-axis labels
    double yStep = (maxY - minY) / 5;
    for (double y = minY; y <= maxY; y += yStep) {
      if (y.abs() < 0.01) continue; // Skip 0
      double screenY = _mapYToScreen(y, size.height);
      
      final textSpan = TextSpan(
        text: y.toStringAsFixed(1),
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(5, screenY - 10));
    }
  }

  double _mapXToScreen(double x, double width) {
    return (x - minX) / (maxX - minX) * width;
  }

  double _mapYToScreen(double y, double height) {
    return height - (y - minY) / (maxY - minY) * height;
  }

  @override
  bool shouldRepaint(covariant GraphPainter oldDelegate) {
    return oldDelegate.functions != functions ||
           oldDelegate.minX != minX ||
           oldDelegate.maxX != maxX ||
           oldDelegate.minY != minY ||
           oldDelegate.maxY != maxY ||
           oldDelegate.darkMode != darkMode;
  }
}

