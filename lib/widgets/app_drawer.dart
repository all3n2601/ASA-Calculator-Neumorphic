import 'package:flutter/material.dart';
import '../screens/nemorphic_container.dart';
import '../services/sound_service.dart';

class AppDrawer extends StatelessWidget {
  final bool darkMode;
  final String currentRoute;
  final VoidCallback onClose;

  const AppDrawer({
    super.key,
    required this.darkMode,
    required this.currentRoute,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = darkMode 
        ? const Color(0xFF2A3441)
        : const Color(0xFFF5F7FA);
    
    Color textColor = darkMode ? Colors.white : Colors.grey.shade800;
    Color subtitleColor = darkMode 
        ? Colors.white.withValues(alpha: 0.7) 
        : Colors.grey.shade600;
    Color accentColor = darkMode ? Colors.green : Colors.redAccent;

    return Drawer(
      backgroundColor: backgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ASA Calculator',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          SoundService.playButtonTap();
                          onClose();
                        },
                        child: Icon(
                          Icons.close,
                          color: textColor,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose your calculator mode',
                    style: TextStyle(
                      fontSize: 14,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            const SizedBox(height: 16),
            
            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.calculate,
                    title: 'Basic Calculator',
                    subtitle: 'Standard arithmetic operations',
                    route: '/',
                    isSelected: currentRoute == '/',
                    accentColor: accentColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),
                  const SizedBox(height: 12),
                  _buildMenuItem(
                    context,
                    icon: Icons.functions,
                    title: 'Algebraic Solver',
                    subtitle: 'Solve equations step-by-step',
                    route: '/algebraic',
                    isSelected: currentRoute == '/algebraic',
                    accentColor: accentColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),
                  const SizedBox(height: 12),
                  _buildMenuItem(
                    context,
                    icon: Icons.integration_instructions,
                    title: 'Calculus Calculator',
                    subtitle: 'Derivatives & integrals with steps',
                    route: '/calculus',
                    isSelected: currentRoute == '/calculus',
                    accentColor: accentColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    isDisabled: false,
                  ),
                  const SizedBox(height: 12),
                  _buildMenuItem(
                    context,
                    icon: Icons.show_chart,
                    title: 'Graphing Calculator',
                    subtitle: 'Plot functions and analyze graphs',
                    route: '/graphing',
                    isSelected: currentRoute == '/graphing',
                    accentColor: accentColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    isDisabled: false,
                  ),
                  const SizedBox(height: 12),
                  _buildMenuItem(
                    context,
                    icon: Icons.straighten,
                    title: 'Unit Converter',
                    subtitle: 'Convert between units',
                    route: '/converter',
                    isSelected: currentRoute == '/converter',
                    accentColor: accentColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    isDisabled: false,
                  ),
                ],
              ),
            ),
            
            // Footer
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: subtitleColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String route,
    required bool isSelected,
    required Color accentColor,
    required Color textColor,
    required Color subtitleColor,
    bool isDisabled = false,
  }) {
    return GestureDetector(
      onTap: isDisabled ? null : () async {
        await SoundService.playButtonTap();
        if (!context.mounted) return;
        if (route != currentRoute) {
          Navigator.of(context).pop(); // Close drawer
          Navigator.of(context).pushReplacementNamed(route);
        } else {
          Navigator.of(context).pop(); // Just close drawer
        }
      },
      child: NeuContainer(
        darkMode: darkMode,
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(16),
        child: Opacity(
          opacity: isDisabled ? 0.5 : 1.0,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? accentColor.withValues(alpha: 0.2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? accentColor : textColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? accentColor : textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: accentColor,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

