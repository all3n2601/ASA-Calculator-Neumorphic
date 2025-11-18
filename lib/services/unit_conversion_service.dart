class UnitConversionService {
  static final List<String> categories = [
    'Length',
    'Weight',
    'Temperature',
    'Volume',
    'Area',
    'Speed',
    'Time',
    'Data',
  ];

  static List<String> getUnitsForCategory(String category) {
    switch (category) {
      case 'Length':
        return ['Meter', 'Kilometer', 'Centimeter', 'Millimeter', 'Mile', 'Yard', 'Foot', 'Inch'];
      case 'Weight':
        return ['Kilogram', 'Gram', 'Milligram', 'Pound', 'Ounce', 'Ton'];
      case 'Temperature':
        return ['Celsius', 'Fahrenheit', 'Kelvin'];
      case 'Volume':
        return ['Liter', 'Milliliter', 'Gallon', 'Quart', 'Pint', 'Cup', 'Fluid Ounce'];
      case 'Area':
        return ['Square Meter', 'Square Kilometer', 'Square Mile', 'Square Yard', 'Square Foot', 'Acre', 'Hectare'];
      case 'Speed':
        return ['Meter/Second', 'Kilometer/Hour', 'Mile/Hour', 'Knot'];
      case 'Time':
        return ['Second', 'Minute', 'Hour', 'Day', 'Week', 'Month', 'Year'];
      case 'Data':
        return ['Byte', 'Kilobyte', 'Megabyte', 'Gigabyte', 'Terabyte', 'Bit'];
      default:
        return ['Meter', 'Kilometer'];
    }
  }

  static double convert(double value, String fromUnit, String toUnit, String category) {
    if (fromUnit == toUnit) return value;

    switch (category) {
      case 'Length':
        return _convertLength(value, fromUnit, toUnit);
      case 'Weight':
        return _convertWeight(value, fromUnit, toUnit);
      case 'Temperature':
        return _convertTemperature(value, fromUnit, toUnit);
      case 'Volume':
        return _convertVolume(value, fromUnit, toUnit);
      case 'Area':
        return _convertArea(value, fromUnit, toUnit);
      case 'Speed':
        return _convertSpeed(value, fromUnit, toUnit);
      case 'Time':
        return _convertTime(value, fromUnit, toUnit);
      case 'Data':
        return _convertData(value, fromUnit, toUnit);
      default:
        return value;
    }
  }

  static double _convertLength(double value, String from, String to) {
    // Convert to meters first
    double meters = value;
    switch (from) {
      case 'Kilometer':
        meters = value * 1000;
        break;
      case 'Centimeter':
        meters = value / 100;
        break;
      case 'Millimeter':
        meters = value / 1000;
        break;
      case 'Mile':
        meters = value * 1609.34;
        break;
      case 'Yard':
        meters = value * 0.9144;
        break;
      case 'Foot':
        meters = value * 0.3048;
        break;
      case 'Inch':
        meters = value * 0.0254;
        break;
    }

    // Convert from meters to target unit
    switch (to) {
      case 'Meter':
        return meters;
      case 'Kilometer':
        return meters / 1000;
      case 'Centimeter':
        return meters * 100;
      case 'Millimeter':
        return meters * 1000;
      case 'Mile':
        return meters / 1609.34;
      case 'Yard':
        return meters / 0.9144;
      case 'Foot':
        return meters / 0.3048;
      case 'Inch':
        return meters / 0.0254;
      default:
        return meters;
    }
  }

  static double _convertWeight(double value, String from, String to) {
    // Convert to kilograms first
    double kg = value;
    switch (from) {
      case 'Gram':
        kg = value / 1000;
        break;
      case 'Milligram':
        kg = value / 1000000;
        break;
      case 'Pound':
        kg = value * 0.453592;
        break;
      case 'Ounce':
        kg = value * 0.0283495;
        break;
      case 'Ton':
        kg = value * 1000;
        break;
    }

    // Convert from kg to target unit
    switch (to) {
      case 'Kilogram':
        return kg;
      case 'Gram':
        return kg * 1000;
      case 'Milligram':
        return kg * 1000000;
      case 'Pound':
        return kg / 0.453592;
      case 'Ounce':
        return kg / 0.0283495;
      case 'Ton':
        return kg / 1000;
      default:
        return kg;
    }
  }

  static double _convertTemperature(double value, String from, String to) {
    // Convert to Celsius first
    double celsius = value;
    switch (from) {
      case 'Fahrenheit':
        celsius = (value - 32) * 5 / 9;
        break;
      case 'Kelvin':
        celsius = value - 273.15;
        break;
    }

    // Convert from Celsius to target unit
    switch (to) {
      case 'Celsius':
        return celsius;
      case 'Fahrenheit':
        return celsius * 9 / 5 + 32;
      case 'Kelvin':
        return celsius + 273.15;
      default:
        return celsius;
    }
  }

  static double _convertVolume(double value, String from, String to) {
    // Convert to liters first
    double liters = value;
    switch (from) {
      case 'Milliliter':
        liters = value / 1000;
        break;
      case 'Gallon':
        liters = value * 3.78541;
        break;
      case 'Quart':
        liters = value * 0.946353;
        break;
      case 'Pint':
        liters = value * 0.473176;
        break;
      case 'Cup':
        liters = value * 0.236588;
        break;
      case 'Fluid Ounce':
        liters = value * 0.0295735;
        break;
    }

    // Convert from liters to target unit
    switch (to) {
      case 'Liter':
        return liters;
      case 'Milliliter':
        return liters * 1000;
      case 'Gallon':
        return liters / 3.78541;
      case 'Quart':
        return liters / 0.946353;
      case 'Pint':
        return liters / 0.473176;
      case 'Cup':
        return liters / 0.236588;
      case 'Fluid Ounce':
        return liters / 0.0295735;
      default:
        return liters;
    }
  }

  static double _convertArea(double value, String from, String to) {
    // Convert to square meters first
    double sqm = value;
    switch (from) {
      case 'Square Kilometer':
        sqm = value * 1000000;
        break;
      case 'Square Mile':
        sqm = value * 2589988.11;
        break;
      case 'Square Yard':
        sqm = value * 0.836127;
        break;
      case 'Square Foot':
        sqm = value * 0.092903;
        break;
      case 'Acre':
        sqm = value * 4046.86;
        break;
      case 'Hectare':
        sqm = value * 10000;
        break;
    }

    // Convert from sqm to target unit
    switch (to) {
      case 'Square Meter':
        return sqm;
      case 'Square Kilometer':
        return sqm / 1000000;
      case 'Square Mile':
        return sqm / 2589988.11;
      case 'Square Yard':
        return sqm / 0.836127;
      case 'Square Foot':
        return sqm / 0.092903;
      case 'Acre':
        return sqm / 4046.86;
      case 'Hectare':
        return sqm / 10000;
      default:
        return sqm;
    }
  }

  static double _convertSpeed(double value, String from, String to) {
    // Convert to m/s first
    double ms = value;
    switch (from) {
      case 'Kilometer/Hour':
        ms = value / 3.6;
        break;
      case 'Mile/Hour':
        ms = value * 0.44704;
        break;
      case 'Knot':
        ms = value * 0.514444;
        break;
    }

    // Convert from m/s to target unit
    switch (to) {
      case 'Meter/Second':
        return ms;
      case 'Kilometer/Hour':
        return ms * 3.6;
      case 'Mile/Hour':
        return ms / 0.44704;
      case 'Knot':
        return ms / 0.514444;
      default:
        return ms;
    }
  }

  static double _convertTime(double value, String from, String to) {
    // Convert to seconds first
    double seconds = value;
    switch (from) {
      case 'Minute':
        seconds = value * 60;
        break;
      case 'Hour':
        seconds = value * 3600;
        break;
      case 'Day':
        seconds = value * 86400;
        break;
      case 'Week':
        seconds = value * 604800;
        break;
      case 'Month':
        seconds = value * 2592000; // 30 days
        break;
      case 'Year':
        seconds = value * 31536000; // 365 days
        break;
    }

    // Convert from seconds to target unit
    switch (to) {
      case 'Second':
        return seconds;
      case 'Minute':
        return seconds / 60;
      case 'Hour':
        return seconds / 3600;
      case 'Day':
        return seconds / 86400;
      case 'Week':
        return seconds / 604800;
      case 'Month':
        return seconds / 2592000;
      case 'Year':
        return seconds / 31536000;
      default:
        return seconds;
    }
  }

  static double _convertData(double value, String from, String to) {
    // Convert to bytes first
    double bytes = value;
    switch (from) {
      case 'Kilobyte':
        bytes = value * 1024;
        break;
      case 'Megabyte':
        bytes = value * 1048576;
        break;
      case 'Gigabyte':
        bytes = value * 1073741824;
        break;
      case 'Terabyte':
        bytes = value * 1099511627776;
        break;
      case 'Bit':
        bytes = value / 8;
        break;
    }

    // Convert from bytes to target unit
    switch (to) {
      case 'Byte':
        return bytes;
      case 'Kilobyte':
        return bytes / 1024;
      case 'Megabyte':
        return bytes / 1048576;
      case 'Gigabyte':
        return bytes / 1073741824;
      case 'Terabyte':
        return bytes / 1099511627776;
      case 'Bit':
        return bytes * 8;
      default:
        return bytes;
    }
  }
}

