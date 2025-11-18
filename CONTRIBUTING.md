# Contributing to ASA Calculator

First off, thank you for considering contributing to ASA Calculator! 🎉

It's people like you that make ASA Calculator such a great tool. We welcome contributions from everyone, whether you're fixing a typo, adding a feature, or improving documentation.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Coding Guidelines](#coding-guidelines)
- [Commit Messages](#commit-messages)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)

---

## 📜 Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to [your.email@example.com].

### Our Standards

- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on what is best for the community
- Show empathy towards other community members
- Accept constructive criticism gracefully

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Git
- A code editor (VS Code, Android Studio, or IntelliJ IDEA)

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork locally:
```bash
git clone https://github.com/YOUR_USERNAME/ASA-Calculator-Neumorphic.git
cd ASA-Calculator-Neumorphic
```

3. Add the upstream repository:
```bash
git remote add upstream https://github.com/ORIGINAL_OWNER/ASA-Calculator-Neumorphic.git
```

4. Install dependencies:
```bash
flutter pub get
```

5. Run the app:
```bash
flutter run
```

---

## 🤝 How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates.

When creating a bug report, include:
- **Clear title and description**
- **Steps to reproduce** the issue
- **Expected behavior** vs **actual behavior**
- **Screenshots** if applicable
- **Device information** (OS, Flutter version, device model)
- **Error messages** or logs

**Bug Report Template:**
```markdown
**Describe the bug**
A clear description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '...'
3. Enter '...'
4. See error

**Expected behavior**
What you expected to happen.

**Screenshots**
If applicable, add screenshots.

**Environment:**
- Device: [e.g. iPhone 12, Pixel 5]
- OS: [e.g. iOS 15, Android 12]
- Flutter version: [e.g. 3.0.0]
- App version: [e.g. 1.0.0]

**Additional context**
Any other context about the problem.
```

### Suggesting Features

Feature suggestions are welcome! Before creating a feature request:
- Check if the feature already exists
- Check if it's already been suggested
- Consider if it fits the project's scope

**Feature Request Template:**
```markdown
**Is your feature request related to a problem?**
A clear description of the problem.

**Describe the solution you'd like**
A clear description of what you want to happen.

**Describe alternatives you've considered**
Alternative solutions or features you've considered.

**Additional context**
Mockups, examples, or any other context.
```

### Improving Documentation

Documentation improvements are always welcome:
- Fix typos or grammatical errors
- Clarify confusing sections
- Add examples
- Improve code comments
- Update outdated information

### Adding Features

1. Check existing issues and PRs
2. Create an issue to discuss the feature
3. Wait for approval before starting work
4. Follow the development guidelines
5. Write tests for new features
6. Update documentation

---

## 💻 Development Setup

### Project Structure

```
lib/
├── main.dart                    # Entry point
├── models/                      # Data models
├── screens/                     # UI screens
├── services/                    # Business logic
└── widgets/                     # Reusable widgets

test/
├── calculus_service_test.dart   # Service tests
├── unit_conversion_test.dart
└── graphing_service_test.dart
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/calculus_service_test.dart

# Run with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Building

```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release
flutter build ios --release
```

---

## 📝 Coding Guidelines

### Dart Style Guide

Follow the [official Dart style guide](https://dart.dev/guides/language/effective-dart/style):

- Use `lowerCamelCase` for variables, functions, and parameters
- Use `UpperCamelCase` for classes and types
- Use `lowercase_with_underscores` for file names
- Use 2 spaces for indentation
- Maximum line length: 80 characters (flexible to 120 for readability)

### Code Quality

- Write self-documenting code with clear variable names
- Add comments for complex logic
- Keep functions small and focused (single responsibility)
- Avoid deep nesting (max 3 levels)
- Handle errors gracefully
- Use const constructors where possible

### Example

```dart
// Good ✅
class CalculatorService {
  /// Computes the derivative of a function
  static Future<List<SolutionStep>> computeDerivative(
    String functionStr,
    String variable,
  ) async {
    // Implementation
  }
}

// Bad ❌
class calc_service {
  static Future<List<SolutionStep>> compute_derivative(String f, String v) async {
    // Implementation
  }
}
```

---

## 💬 Commit Messages

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

### Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

### Examples
```bash
feat(calculus): add support for chain rule derivatives

fix(graphing): resolve log10 function parsing issue

docs(readme): update installation instructions

test(unit-conversion): add tests for temperature conversion
```

---

## 🔄 Pull Request Process

1. **Create a branch**
```bash
git checkout -b feature/amazing-feature
```

2. **Make your changes**
- Write clean, documented code
- Follow coding guidelines
- Add tests for new features
- Update documentation

3. **Test your changes**
```bash
flutter test
flutter analyze
```

4. **Commit your changes**
```bash
git add .
git commit -m "feat: add amazing feature"
```

5. **Push to your fork**
```bash
git push origin feature/amazing-feature
```

6. **Create Pull Request**
- Go to the original repository
- Click "New Pull Request"
- Select your branch
- Fill in the PR template
- Link related issues

### PR Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tests pass locally
- [ ] Added new tests
- [ ] Updated existing tests

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings generated
```

---

## 🧪 Testing

### Writing Tests

- Write tests for all new features
- Maintain or improve test coverage
- Test edge cases and error conditions
- Use descriptive test names

### Test Structure
```dart
group('Feature Name', () {
  test('should do something specific', () {
    // Arrange
    final input = 'test';
    
    // Act
    final result = function(input);
    
    // Assert
    expect(result, expectedValue);
  });
});
```

---

## 🎯 Areas for Contribution

### High Priority
- [ ] Matrix operations
- [ ] Statistics calculator
- [ ] Definite integrals with visualization
- [ ] Export graphs as images

### Medium Priority
- [ ] More unit categories
- [ ] Custom themes
- [ ] Tutorial mode
- [ ] Formula reference guide

### Low Priority
- [ ] Voice input
- [ ] Handwriting recognition
- [ ] Cloud sync
- [ ] Collaborative features

---

## 📞 Questions?

- Open an issue for questions
- Join our discussions
- Email: your.email@example.com

---

## 🙏 Thank You!

Your contributions make this project better for everyone. We appreciate your time and effort!

Happy coding! 🚀

