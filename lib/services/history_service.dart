import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calculation_history.dart';

class HistoryService {
  static const String _historyKey = 'calculation_history';
  static const int _maxHistoryItems = 100; // Limit history to prevent storage bloat

  // Get all history items
  static Future<List<CalculationHistory>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];

      return historyJson
          .map((jsonString) => CalculationHistory.fromJson(json.decode(jsonString)))
          .toList()
          .reversed // Show newest first
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Add a new calculation to history
  static Future<void> addCalculation(String equation, String result) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];

      // Create new history entry
      final newEntry = CalculationHistory(
        equation: equation,
        result: result,
        timestamp: DateTime.now(),
      );

      // Add to beginning of list (newest first when reversed)
      historyJson.insert(0, json.encode(newEntry.toJson()));

      // Limit history size
      if (historyJson.length > _maxHistoryItems) {
        historyJson.removeRange(_maxHistoryItems, historyJson.length);
      }

      // Save back to preferences
      await prefs.setStringList(_historyKey, historyJson);
    } catch (e) {
      // Error saving, continue silently
    }
  }

  // Clear all history
  static Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
    } catch (e) {
      // Error clearing, continue silently
    }
  }

  // Remove a specific history item
  static Future<void> removeHistoryItem(CalculationHistory item) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];

      // Find and remove the item
      historyJson.removeWhere((jsonString) {
        final historyItem = CalculationHistory.fromJson(json.decode(jsonString));
        return historyItem == item;
      });

      await prefs.setStringList(_historyKey, historyJson);
    } catch (e) {
      // Error removing, continue silently
    }
  }

  // Get history count
  static Future<int> getHistoryCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];
      return historyJson.length;
    } catch (e) {
      return 0;
    }
  }
}
