import '../../../app/app_theme.dart';
import 'package:flutter/material.dart';

class NumberedBox extends StatefulWidget {
  final int number;
  final VoidCallback onTap;

  const NumberedBox({
    super.key,
    required this.number,
    required this.onTap,
  });

  @override
  State<NumberedBox> createState() => _NumberedBoxState();
}

class _NumberedBoxState extends State<NumberedBox> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                JebenaTheme.saffron,
                JebenaTheme.terracotta,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: JebenaTheme.saffron.withValues(alpha: 0.5),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: JebenaTheme.terracotta.withValues(alpha: 0.3),
                blurRadius: 18,
                offset: const Offset(0, 12),
              ),
            ],
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.4),
              width: 2,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              widget.number.toString(),
              style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    blurRadius: 6,
                    offset: Offset(2, 2),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
