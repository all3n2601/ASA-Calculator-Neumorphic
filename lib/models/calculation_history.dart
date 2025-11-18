class CalculationHistory {
  final String equation;
  final String result;
  final DateTime timestamp;

  CalculationHistory({
    required this.equation,
    required this.result,
    required this.timestamp,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'equation': equation,
      'result': result,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  // Create from JSON
  factory CalculationHistory.fromJson(Map<String, dynamic> json) {
    return CalculationHistory(
      equation: json['equation'] as String,
      result: json['result'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
    );
  }

  // Format timestamp for display
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  String toString() {
    return '$equation = $result';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CalculationHistory &&
        other.equation == equation &&
        other.result == result &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return equation.hashCode ^ result.hashCode ^ timestamp.hashCode;
  }
}
