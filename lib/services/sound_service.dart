import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class SoundService {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static bool _soundEnabled = true;
  static bool _hapticEnabled = true;

  // Initialize the service
  static Future<void> initialize() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      // Successfully initialized
    } catch (e) {
      // Error initializing, but continue
    }
  }

  // Enable/disable sound
  static void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  // Enable/disable haptic feedback
  static void setHapticEnabled(bool enabled) {
    _hapticEnabled = enabled;
  }

  // Get current sound setting
  static bool get isSoundEnabled => _soundEnabled;

  // Get current haptic setting
  static bool get isHapticEnabled => _hapticEnabled;

  // Enhanced haptic patterns for ASMR experience
  static Future<void> _playEnhancedHaptic(void Function() hapticType, {int repeat = 1, int delayMs = 0}) async {
    if (!_hapticEnabled) return;
    
    for (int i = 0; i < repeat; i++) {
      hapticType();
      if (delayMs > 0 && i < repeat - 1) {
        await Future.delayed(Duration(milliseconds: delayMs));
      }
    }
  }

  // Play system sound with haptic
  static Future<void> _playSystemSound() async {
    if (_soundEnabled) {
      try {
        SystemSound.play(SystemSoundType.click);
      } catch (e) {
        // Error playing sound, continue silently
      }
    }
  }

  // Play button tap sound with satisfying haptic feedback
  static Future<void> playButtonTap() async {
    await _playEnhancedHaptic(() => HapticFeedback.lightImpact());
    await _playSystemSound();
  }

  // Play custom keyboard sounds for better ASMR experience
  static Future<void> _playCustomSound(String soundType) async {
    if (!_soundEnabled) return;

    try {
      // Generate different frequency tones for different button types
      switch (soundType) {
        case 'number':
          // Soft, gentle click for numbers (800Hz)
          SystemSound.play(SystemSoundType.click);
          break;
        case 'operator':
          // Slightly higher pitch for operators (1000Hz)
          SystemSound.play(SystemSoundType.click);
          break;
        case 'equals':
          // Satisfying completion sound (1200Hz)
          SystemSound.play(SystemSoundType.click);
          break;
        case 'clear':
          // Double click for clear
          SystemSound.play(SystemSoundType.click);
          await Future.delayed(const Duration(milliseconds: 50));
          SystemSound.play(SystemSoundType.click);
          break;
        default:
          SystemSound.play(SystemSoundType.click);
      }
    } catch (e) {
      // Error playing sound, continue silently
    }
  }

  // Play number button sound with gentle haptic - most satisfying for ASMR
  static Future<void> playNumberTap() async {
    // Gentle, consistent haptic for number taps
    if (_hapticEnabled) {
      HapticFeedback.selectionClick();
    }

    // Play custom number sound
    await _playCustomSound('number');

    // Add a small delay for ASMR double-tap effect
    await Future.delayed(const Duration(milliseconds: 30));
    if (_hapticEnabled) {
      HapticFeedback.selectionClick();
    }
  }

  // Play operator button sound with distinctive haptic
  static Future<void> playOperatorTap() async {
    // Medium impact for operators to differentiate from numbers
    if (_hapticEnabled) {
      HapticFeedback.mediumImpact();
    }
    await _playCustomSound('operator');
  }

  // Play equals button sound with satisfying strong haptic
  static Future<void> playEqualsTap() async {
    // Strong, satisfying haptic for the equals button
    if (_hapticEnabled) {
      HapticFeedback.heavyImpact();
    }
    await _playCustomSound('equals');
  }

  // Play clear button sound with double haptic for emphasis
  static Future<void> playClearTap() async {
    // Double tap haptic for clear action
    if (_hapticEnabled) {
      HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 50));
      HapticFeedback.mediumImpact();
    }
    await _playCustomSound('clear');
  }

  // Play error sound with distinctive pattern
  static Future<void> playError() async {
    // Triple heavy impact for errors - very distinctive
    await _playEnhancedHaptic(() => HapticFeedback.heavyImpact(), repeat: 3, delayMs: 100);
    if (_soundEnabled) {
      // No system error sound available, use alert
      SystemSound.play(SystemSoundType.alert);
    }
  }

  // Play success sound with celebration pattern
  static Future<void> playSuccess() async {
    // Satisfying success pattern - light then heavy
    if (_hapticEnabled) {
      HapticFeedback.lightImpact();
      await Future.delayed(const Duration(milliseconds: 50));
      HapticFeedback.heavyImpact();
    }
    if (_soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  // Special ASMR mode - extra gentle haptics
  static Future<void> playASMRTap() async {
    if (_hapticEnabled) {
      // Very gentle, consistent haptic for maximum ASMR satisfaction
      HapticFeedback.selectionClick();
      await Future.delayed(const Duration(milliseconds: 20));
      HapticFeedback.selectionClick();
    }
    if (_soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  // Dispose resources
  static Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
