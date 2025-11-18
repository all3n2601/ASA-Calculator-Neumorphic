class SolutionStep {
  final int stepNumber;
  final String description;
  final String equation;
  final String explanation;

  SolutionStep({
    required this.stepNumber,
    required this.description,
    required this.equation,
    required this.explanation,
  });

  Map<String, dynamic> toJson() {
    return {
      'stepNumber': stepNumber,
      'description': description,
      'equation': equation,
      'explanation': explanation,
    };
  }

  factory SolutionStep.fromJson(Map<String, dynamic> json) {
    return SolutionStep(
      stepNumber: json['stepNumber'] as int,
      description: json['description'] as String,
      equation: json['equation'] as String,
      explanation: json['explanation'] as String,
    );
  }
}

