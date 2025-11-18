import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'nemorphic_container.dart';
import '../services/sound_service.dart';
import '../services/graphing_service.dart';
import '../widgets/app_drawer.dart';
import '../widgets/graph_painter.dart';

class GraphingCalculatorPage extends StatefulWidget {
  const GraphingCalculatorPage({super.key});

  @override
  State<GraphingCalculatorPage> createState() => _GraphingCalculatorPageState();
}

class _GraphingCalculatorPageState extends State<GraphingCalculatorPage> {
  bool darkMode = false;
  String function = '';
  List<String> functions = [];
  List<Color> functionColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];
  
  double minX = -10;
  double maxX = 10;
  double minY = -10;
  double maxY = 10;
  
  Color colorDark = const Color(0xFF2A3441);
  Color colorLight = const Color(0xFFF5F7FA);

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addFunction() async {
    if (function.trim().isEmpty) return;
    
    await SoundService.playButtonTap();
    
    try {
      // Validate function
      GraphingService.validateFunction(function);
      
      setState(() {
        if (functions.length < 5) {
          functions.add(function);
          _controller.clear();
          function = '';
        }
      });
      
      await SoundService.playSuccess();
    } catch (e) {
      await SoundService.playError();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid function: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeFunction(int index) async {
    await SoundService.playButtonTap();
    setState(() {
      functions.removeAt(index);
    });
  }

  void _clearAll() async {
    await SoundService.playClearTap();
    setState(() {
      functions.clear();
      _controller.clear();
      function = '';
    });
  }

  void _resetZoom() async {
    await SoundService.playButtonTap();
    setState(() {
      minX = -10;
      maxX = 10;
      minY = -10;
      maxY = 10;
    });
  }

  void _zoomIn() async {
    await SoundService.playButtonTap();
    setState(() {
      double rangeX = (maxX - minX) * 0.2;
      double rangeY = (maxY - minY) * 0.2;
      minX += rangeX;
      maxX -= rangeX;
      minY += rangeY;
      maxY -= rangeY;
    });
  }

  void _zoomOut() async {
    await SoundService.playButtonTap();
    setState(() {
      double rangeX = (maxX - minX) * 0.25;
      double rangeY = (maxY - minY) * 0.25;
      minX -= rangeX;
      maxX += rangeX;
      minY -= rangeY;
      maxY += rangeY;
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
        currentRoute: '/graphing',
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
                          'Graphing Calculator',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          'Plot functions and analyze graphs',
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

            // Graph Display
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: NeuContainer(
                  darkMode: darkMode,
                  borderRadius: BorderRadius.circular(16),
                  padding: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CustomPaint(
                      painter: GraphPainter(
                        functions: functions,
                        functionColors: functionColors,
                        minX: minX,
                        maxX: maxX,
                        minY: minY,
                        maxY: maxY,
                        darkMode: darkMode,
                      ),
                      child: Container(),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Zoom Controls
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildControlButton(Icons.zoom_in, 'Zoom In', _zoomIn, textColor),
                  _buildControlButton(Icons.zoom_out, 'Zoom Out', _zoomOut, textColor),
                  _buildControlButton(Icons.refresh, 'Reset', _resetZoom, textColor),
                  _buildControlButton(Icons.clear_all, 'Clear', _clearAll, textColor),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Function Input
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
                      'Enter Function (use x as variable)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: TextStyle(
                              fontSize: 16,
                              color: textColor,
                            ),
                            decoration: InputDecoration(
                              hintText: 'e.g., x^2, sin(x), 2*x+1',
                              hintStyle: TextStyle(color: subtitleColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: darkMode
                                  ? Colors.black.withValues(alpha: 0.2)
                                  : Colors.white.withValues(alpha: 0.5),
                              contentPadding: const EdgeInsets.all(12),
                            ),
                            onChanged: (value) {
                              setState(() {
                                function = value;
                              });
                            },
                            onSubmitted: (_) => _addFunction(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: _addFunction,
                          child: NeuContainer(
                            darkMode: darkMode,
                            borderRadius: BorderRadius.circular(12),
                            padding: const EdgeInsets.all(16),
                            child: Icon(
                              Icons.add,
                              color: darkMode ? Colors.green : Colors.redAccent,
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

            // Function List
            if (functions.isNotEmpty)
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
                        'Active Functions',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(functions.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: functionColors[index % functionColors.length],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'y = ${functions[index]}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textColor,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _removeFunction(index),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(IconData icon, String label, VoidCallback onTap, Color textColor) {
    return GestureDetector(
      onTap: onTap,
      child: NeuContainer(
        darkMode: darkMode,
        borderRadius: BorderRadius.circular(12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

