import 'package:flutter_test/flutter_test.dart';
import 'package:asa_calculator/services/unit_conversion_service.dart';

void main() {
  group('Unit Conversion - Length', () {
    test('Meter to Kilometer', () {
      final result = UnitConversionService.convert(1000, 'Meter', 'Kilometer', 'Length');
      expect(result, closeTo(1.0, 0.001));
    });

    test('Kilometer to Meter', () {
      final result = UnitConversionService.convert(1, 'Kilometer', 'Meter', 'Length');
      expect(result, closeTo(1000.0, 0.001));
    });

    test('Meter to Centimeter', () {
      final result = UnitConversionService.convert(1, 'Meter', 'Centimeter', 'Length');
      expect(result, closeTo(100.0, 0.001));
    });

    test('Meter to Millimeter', () {
      final result = UnitConversionService.convert(1, 'Meter', 'Millimeter', 'Length');
      expect(result, closeTo(1000.0, 0.001));
    });

    test('Mile to Kilometer', () {
      final result = UnitConversionService.convert(1, 'Mile', 'Kilometer', 'Length');
      expect(result, closeTo(1.60934, 0.001));
    });

    test('Foot to Meter', () {
      final result = UnitConversionService.convert(1, 'Foot', 'Meter', 'Length');
      expect(result, closeTo(0.3048, 0.001));
    });

    test('Inch to Centimeter', () {
      final result = UnitConversionService.convert(1, 'Inch', 'Centimeter', 'Length');
      expect(result, closeTo(2.54, 0.001));
    });

    test('Yard to Meter', () {
      final result = UnitConversionService.convert(1, 'Yard', 'Meter', 'Length');
      expect(result, closeTo(0.9144, 0.001));
    });

    test('Same unit returns same value', () {
      final result = UnitConversionService.convert(5, 'Meter', 'Meter', 'Length');
      expect(result, equals(5.0));
    });
  });

  group('Unit Conversion - Weight', () {
    test('Kilogram to Gram', () {
      final result = UnitConversionService.convert(1, 'Kilogram', 'Gram', 'Weight');
      expect(result, closeTo(1000.0, 0.001));
    });

    test('Gram to Kilogram', () {
      final result = UnitConversionService.convert(1000, 'Gram', 'Kilogram', 'Weight');
      expect(result, closeTo(1.0, 0.001));
    });

    test('Kilogram to Pound', () {
      final result = UnitConversionService.convert(1, 'Kilogram', 'Pound', 'Weight');
      expect(result, closeTo(2.20462, 0.001));
    });

    test('Pound to Kilogram', () {
      final result = UnitConversionService.convert(1, 'Pound', 'Kilogram', 'Weight');
      expect(result, closeTo(0.453592, 0.001));
    });

    test('Ounce to Gram', () {
      final result = UnitConversionService.convert(1, 'Ounce', 'Gram', 'Weight');
      expect(result, closeTo(28.3495, 0.001));
    });

    test('Ton to Kilogram', () {
      final result = UnitConversionService.convert(1, 'Ton', 'Kilogram', 'Weight');
      expect(result, closeTo(1000.0, 0.001));
    });

    test('Milligram to Gram', () {
      final result = UnitConversionService.convert(1000, 'Milligram', 'Gram', 'Weight');
      expect(result, closeTo(1.0, 0.001));
    });
  });

  group('Unit Conversion - Temperature', () {
    test('Celsius to Fahrenheit: 0°C', () {
      final result = UnitConversionService.convert(0, 'Celsius', 'Fahrenheit', 'Temperature');
      expect(result, closeTo(32.0, 0.001));
    });

    test('Celsius to Fahrenheit: 100°C', () {
      final result = UnitConversionService.convert(100, 'Celsius', 'Fahrenheit', 'Temperature');
      expect(result, closeTo(212.0, 0.001));
    });

    test('Fahrenheit to Celsius: 32°F', () {
      final result = UnitConversionService.convert(32, 'Fahrenheit', 'Celsius', 'Temperature');
      expect(result, closeTo(0.0, 0.001));
    });

    test('Fahrenheit to Celsius: 212°F', () {
      final result = UnitConversionService.convert(212, 'Fahrenheit', 'Celsius', 'Temperature');
      expect(result, closeTo(100.0, 0.001));
    });

    test('Celsius to Kelvin: 0°C', () {
      final result = UnitConversionService.convert(0, 'Celsius', 'Kelvin', 'Temperature');
      expect(result, closeTo(273.15, 0.001));
    });

    test('Kelvin to Celsius: 273.15K', () {
      final result = UnitConversionService.convert(273.15, 'Kelvin', 'Celsius', 'Temperature');
      expect(result, closeTo(0.0, 0.001));
    });

    test('Fahrenheit to Kelvin', () {
      final result = UnitConversionService.convert(32, 'Fahrenheit', 'Kelvin', 'Temperature');
      expect(result, closeTo(273.15, 0.001));
    });

    test('Same temperature unit', () {
      final result = UnitConversionService.convert(25, 'Celsius', 'Celsius', 'Temperature');
      expect(result, equals(25.0));
    });
  });

  group('Unit Conversion - Volume', () {
    test('Liter to Milliliter', () {
      final result = UnitConversionService.convert(1, 'Liter', 'Milliliter', 'Volume');
      expect(result, closeTo(1000.0, 0.001));
    });

    test('Gallon to Liter', () {
      final result = UnitConversionService.convert(1, 'Gallon', 'Liter', 'Volume');
      expect(result, closeTo(3.78541, 0.001));
    });

    test('Liter to Gallon', () {
      final result = UnitConversionService.convert(1, 'Liter', 'Gallon', 'Volume');
      expect(result, closeTo(0.264172, 0.001));
    });

    test('Quart to Liter', () {
      final result = UnitConversionService.convert(1, 'Quart', 'Liter', 'Volume');
      expect(result, closeTo(0.946353, 0.001));
    });

    test('Cup to Milliliter', () {
      final result = UnitConversionService.convert(1, 'Cup', 'Milliliter', 'Volume');
      expect(result, closeTo(236.588, 0.001));
    });
  });

  group('Unit Conversion - Area', () {
    test('Square Meter to Square Kilometer', () {
      final result = UnitConversionService.convert(1000000, 'Square Meter', 'Square Kilometer', 'Area');
      expect(result, closeTo(1.0, 0.001));
    });

    test('Square Kilometer to Square Meter', () {
      final result = UnitConversionService.convert(1, 'Square Kilometer', 'Square Meter', 'Area');
      expect(result, closeTo(1000000.0, 0.001));
    });

    test('Acre to Square Meter', () {
      final result = UnitConversionService.convert(1, 'Acre', 'Square Meter', 'Area');
      expect(result, closeTo(4046.86, 0.1));
    });

    test('Hectare to Square Meter', () {
      final result = UnitConversionService.convert(1, 'Hectare', 'Square Meter', 'Area');
      expect(result, closeTo(10000.0, 0.001));
    });

    test('Square Foot to Square Meter', () {
      final result = UnitConversionService.convert(1, 'Square Foot', 'Square Meter', 'Area');
      expect(result, closeTo(0.092903, 0.001));
    });
  });

  group('Unit Conversion - Speed', () {
    test('Meter/Second to Kilometer/Hour', () {
      final result = UnitConversionService.convert(1, 'Meter/Second', 'Kilometer/Hour', 'Speed');
      expect(result, closeTo(3.6, 0.001));
    });

    test('Kilometer/Hour to Meter/Second', () {
      final result = UnitConversionService.convert(3.6, 'Kilometer/Hour', 'Meter/Second', 'Speed');
      expect(result, closeTo(1.0, 0.001));
    });

    test('Mile/Hour to Kilometer/Hour', () {
      final result = UnitConversionService.convert(60, 'Mile/Hour', 'Kilometer/Hour', 'Speed');
      expect(result, closeTo(96.56, 0.1));
    });

    test('Knot to Meter/Second', () {
      final result = UnitConversionService.convert(1, 'Knot', 'Meter/Second', 'Speed');
      expect(result, closeTo(0.514444, 0.001));
    });
  });

  group('Unit Conversion - Time', () {
    test('Hour to Minute', () {
      final result = UnitConversionService.convert(1, 'Hour', 'Minute', 'Time');
      expect(result, closeTo(60.0, 0.001));
    });

    test('Minute to Second', () {
      final result = UnitConversionService.convert(1, 'Minute', 'Second', 'Time');
      expect(result, closeTo(60.0, 0.001));
    });

    test('Day to Hour', () {
      final result = UnitConversionService.convert(1, 'Day', 'Hour', 'Time');
      expect(result, closeTo(24.0, 0.001));
    });

    test('Week to Day', () {
      final result = UnitConversionService.convert(1, 'Week', 'Day', 'Time');
      expect(result, closeTo(7.0, 0.001));
    });

    test('Year to Day', () {
      final result = UnitConversionService.convert(1, 'Year', 'Day', 'Time');
      expect(result, closeTo(365.0, 0.001));
    });
  });

  group('Unit Conversion - Data', () {
    test('Kilobyte to Byte', () {
      final result = UnitConversionService.convert(1, 'Kilobyte', 'Byte', 'Data');
      expect(result, closeTo(1024.0, 0.001));
    });

    test('Megabyte to Kilobyte', () {
      final result = UnitConversionService.convert(1, 'Megabyte', 'Kilobyte', 'Data');
      expect(result, closeTo(1024.0, 0.001));
    });

    test('Gigabyte to Megabyte', () {
      final result = UnitConversionService.convert(1, 'Gigabyte', 'Megabyte', 'Data');
      expect(result, closeTo(1024.0, 0.001));
    });

    test('Terabyte to Gigabyte', () {
      final result = UnitConversionService.convert(1, 'Terabyte', 'Gigabyte', 'Data');
      expect(result, closeTo(1024.0, 0.001));
    });

    test('Byte to Bit', () {
      final result = UnitConversionService.convert(1, 'Byte', 'Bit', 'Data');
      expect(result, closeTo(8.0, 0.001));
    });

    test('Bit to Byte', () {
      final result = UnitConversionService.convert(8, 'Bit', 'Byte', 'Data');
      expect(result, closeTo(1.0, 0.001));
    });
  });

  group('Unit Conversion - Complex Cases', () {
    test('Large value: 1000000 meters to kilometers', () {
      final result = UnitConversionService.convert(1000000, 'Meter', 'Kilometer', 'Length');
      expect(result, closeTo(1000.0, 0.001));
    });

    test('Small value: 0.001 kilometer to meter', () {
      final result = UnitConversionService.convert(0.001, 'Kilometer', 'Meter', 'Length');
      expect(result, closeTo(1.0, 0.001));
    });

    test('Decimal value: 2.5 hours to minutes', () {
      final result = UnitConversionService.convert(2.5, 'Hour', 'Minute', 'Time');
      expect(result, closeTo(150.0, 0.001));
    });

    test('Negative temperature: -40°C to Fahrenheit', () {
      final result = UnitConversionService.convert(-40, 'Celsius', 'Fahrenheit', 'Temperature');
      expect(result, closeTo(-40.0, 0.001)); // -40°C = -40°F
    });

    test('Zero value conversion', () {
      final result = UnitConversionService.convert(0, 'Meter', 'Kilometer', 'Length');
      expect(result, equals(0.0));
    });

    test('Chain conversion: Mile to Meter to Kilometer', () {
      final mileToMeter = UnitConversionService.convert(1, 'Mile', 'Meter', 'Length');
      final meterToKm = UnitConversionService.convert(mileToMeter, 'Meter', 'Kilometer', 'Length');
      expect(meterToKm, closeTo(1.60934, 0.001));
    });

    test('Reverse conversion accuracy: Meter to Foot to Meter', () {
      final original = 100.0;
      final toFoot = UnitConversionService.convert(original, 'Meter', 'Foot', 'Length');
      final backToMeter = UnitConversionService.convert(toFoot, 'Foot', 'Meter', 'Length');
      expect(backToMeter, closeTo(original, 0.001));
    });

    test('Multiple conversions: 1 GB in different units', () {
      final gbToMb = UnitConversionService.convert(1, 'Gigabyte', 'Megabyte', 'Data');
      final gbToKb = UnitConversionService.convert(1, 'Gigabyte', 'Kilobyte', 'Data');
      final gbToByte = UnitConversionService.convert(1, 'Gigabyte', 'Byte', 'Data');

      expect(gbToMb, closeTo(1024.0, 0.001));
      expect(gbToKb, closeTo(1048576.0, 0.001));
      expect(gbToByte, closeTo(1073741824.0, 0.001));
    });
  });

  group('Unit Conversion - Edge Cases', () {
    test('Same unit conversion returns same value', () {
      final result = UnitConversionService.convert(42, 'Meter', 'Meter', 'Length');
      expect(result, equals(42.0));
    });

    test('Categories list is not empty', () {
      expect(UnitConversionService.categories.isNotEmpty, true);
    });

    test('All categories have units', () {
      for (var category in UnitConversionService.categories) {
        final units = UnitConversionService.getUnitsForCategory(category);
        expect(units.isNotEmpty, true);
      }
    });

    test('Length category has expected units', () {
      final units = UnitConversionService.getUnitsForCategory('Length');
      expect(units.contains('Meter'), true);
      expect(units.contains('Kilometer'), true);
      expect(units.contains('Mile'), true);
    });

    test('Temperature category has expected units', () {
      final units = UnitConversionService.getUnitsForCategory('Temperature');
      expect(units.contains('Celsius'), true);
      expect(units.contains('Fahrenheit'), true);
      expect(units.contains('Kelvin'), true);
    });
  });
}


