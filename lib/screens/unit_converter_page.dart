import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'nemorphic_container.dart';
import '../services/sound_service.dart';
import '../services/unit_conversion_service.dart';
import '../widgets/app_drawer.dart';

class UnitConverterPage extends StatefulWidget {
  const UnitConverterPage({super.key});

  @override
  State<UnitConverterPage> createState() => _UnitConverterPageState();
}

class _UnitConverterPageState extends State<UnitConverterPage> {
  bool darkMode = false;
  String selectedCategory = 'Length';
  String fromUnit = 'Meter';
  String toUnit = 'Kilometer';
  double inputValue = 1.0;
  double outputValue = 0.001;
  
  Color colorDark = const Color(0xFF2A3441);
  Color colorLight = const Color(0xFFF5F7FA);

  final TextEditingController _controller = TextEditingController(text: '1');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _convert() {
    try {
      double result = UnitConversionService.convert(
        inputValue,
        fromUnit,
        toUnit,
        selectedCategory,
      );
      
      setState(() {
        outputValue = result;
      });
    } catch (e) {
      // Handle error
    }
  }

  void _swapUnits() async {
    await SoundService.playButtonTap();
    setState(() {
      String temp = fromUnit;
      fromUnit = toUnit;
      toUnit = temp;
      _convert();
    });
  }

  void _changeCategory(String category) async {
    await SoundService.playButtonTap();
    setState(() {
      selectedCategory = category;
      List<String> units = UnitConversionService.getUnitsForCategory(category);
      fromUnit = units[0];
      toUnit = units[1];
      _convert();
    });
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = darkMode ? Colors.white : Colors.grey.shade800;
    Color subtitleColor = darkMode 
        ? Colors.white.withValues(alpha: 0.7) 
        : Colors.grey.shade600;
    Color accentColor = darkMode ? Colors.green : Colors.redAccent;

    List<String> categories = UnitConversionService.categories;
    List<String> units = UnitConversionService.getUnitsForCategory(selectedCategory);

    return Scaffold(
      backgroundColor: darkMode ? colorDark : colorLight,
      drawer: AppDrawer(
        darkMode: darkMode,
        currentRoute: '/converter',
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
                          'Unit Converter',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          'Convert between different units',
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

            // Category Selection
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    bool isSelected = categories[index] == selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () => _changeCategory(categories[index]),
                        child: NeuContainer(
                          darkMode: darkMode,
                          borderRadius: BorderRadius.circular(12),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Center(
                            child: Text(
                              categories[index],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? accentColor : textColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // From Unit
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
                      'From',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: subtitleColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _controller,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '0',
                        hintStyle: TextStyle(color: subtitleColor),
                      ),
                      onChanged: (value) {
                        setState(() {
                          inputValue = double.tryParse(value) ?? 0;
                          _convert();
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: darkMode
                            ? Colors.black.withValues(alpha: 0.2)
                            : Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: fromUnit,
                        isExpanded: true,
                        underline: Container(),
                        dropdownColor: darkMode ? colorDark : colorLight,
                        style: TextStyle(color: textColor, fontSize: 16),
                        items: units.map((String unit) {
                          return DropdownMenuItem<String>(
                            value: unit,
                            child: Text(unit),
                          );
                        }).toList(),
                        onChanged: (String? newValue) async {
                          if (newValue != null) {
                            await SoundService.playButtonTap();
                            setState(() {
                              fromUnit = newValue;
                              _convert();
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Swap Button
            GestureDetector(
              onTap: _swapUnits,
              child: NeuContainer(
                darkMode: darkMode,
                borderRadius: BorderRadius.circular(12),
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.swap_vert,
                  color: accentColor,
                  size: 32,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // To Unit
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
                      'To',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: subtitleColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      outputValue.toStringAsFixed(6).replaceAll(RegExp(r'\.?0+$'), ''),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: darkMode
                            ? Colors.black.withValues(alpha: 0.2)
                            : Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: toUnit,
                        isExpanded: true,
                        underline: Container(),
                        dropdownColor: darkMode ? colorDark : colorLight,
                        style: TextStyle(color: textColor, fontSize: 16),
                        items: units.map((String unit) {
                          return DropdownMenuItem<String>(
                            value: unit,
                            child: Text(unit),
                          );
                        }).toList(),
                        onChanged: (String? newValue) async {
                          if (newValue != null) {
                            await SoundService.playButtonTap();
                            setState(() {
                              toUnit = newValue;
                              _convert();
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Quick Conversions
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: NeuContainer(
                  darkMode: darkMode,
                  borderRadius: BorderRadius.circular(16),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Conversions',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          itemCount: units.length,
                          itemBuilder: (context, index) {
                            if (units[index] == fromUnit) return Container();

                            double converted = UnitConversionService.convert(
                              inputValue,
                              fromUnit,
                              units[index],
                              selectedCategory,
                            );

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    units[index],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: textColor,
                                    ),
                                  ),
                                  Text(
                                    converted.toStringAsFixed(6).replaceAll(RegExp(r'\.?0+$'), ''),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: subtitleColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

