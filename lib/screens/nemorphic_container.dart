import 'package:flutter/material.dart';

class NeuContainer extends StatefulWidget {
  final bool darkMode;
  final Widget? child;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  const NeuContainer(
      {super.key,
      this.darkMode = false,
      this.child,
      this.borderRadius,
      this.padding});

  @override
  State<NeuContainer> createState() => _NeuContainerState();
}

class _NeuContainerState extends State<NeuContainer>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  Color colorDark = Color(0xFF2A3441); // Darker, more comfortable for eyes
  Color colorLight = Color(0xFFF5F7FA); // Softer light color to reduce glare

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150), // Smooth, satisfying animation
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95, // Subtle scale down for satisfying press effect
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  void _onPointerCancel(PointerCancelEvent event) {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = widget.darkMode;
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
              padding: widget.padding,
              decoration: BoxDecoration(
                color: darkMode ? colorDark : colorLight,
                borderRadius: widget.borderRadius,
                boxShadow: _isPressed
                    ? [
                        // Pressed shadow - smaller and closer for depth effect
                        BoxShadow(
                          color: darkMode ? Colors.black26 : Colors.blueGrey.shade100,
                          offset: const Offset(1.0, 1.0),
                          blurRadius: 4.0,
                          spreadRadius: 0.0,
                        ),
                        BoxShadow(
                          color: darkMode ? Colors.blueGrey.shade800 : Colors.white70,
                          offset: const Offset(-1.0, -1.0),
                          blurRadius: 4.0,
                          spreadRadius: 0.0,
                        )
                      ]
                    : [
                        // Elevated shadow when not pressed
                        BoxShadow(
                          color: darkMode ? Colors.black54 : Colors.blueGrey.shade200,
                          offset: const Offset(4.0, 4.0),
                          blurRadius: 15.0,
                          spreadRadius: 1.0,
                        ),
                        BoxShadow(
                          color: darkMode ? Colors.blueGrey.shade700 : Colors.white,
                          offset: const Offset(-4.0, -4.0),
                          blurRadius: 15.0,
                          spreadRadius: 1.0,
                        )
                      ],
              ),
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}
