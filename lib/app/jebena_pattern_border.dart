import 'package:flutter/material.dart';

import 'app_theme.dart';

/// A small repeating weave on cards, drawn with Flutter's vector canvas.
class JebenaPatternBorder extends StatelessWidget {
  const JebenaPatternBorder({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => CustomPaint(
        foregroundPainter: const _WeavePainter(),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: child,
        ),
      );
}

class _WeavePainter extends CustomPainter {
  const _WeavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    const inset = 4.0;
    const step = 10.0;
    final outline = Paint()
      ..color = JebenaTheme.saffron.withValues(alpha: 0.8)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final warp = Paint()
      ..color = JebenaTheme.terracotta.withValues(alpha: 0.9)
      ..strokeWidth = 1.5;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
            inset, inset, size.width - inset * 2, size.height - inset * 2),
        const Radius.circular(14),
      ),
      outline,
    );

    for (var x = 12.0; x < size.width - 12; x += step) {
      final offset = (x ~/ step).isEven ? 0.0 : 4.0;
      canvas.drawLine(Offset(x, 5 + offset), Offset(x + 4, 15 + offset), warp);
      canvas.drawLine(
        Offset(x, size.height - 5 - offset),
        Offset(x + 4, size.height - 15 - offset),
        warp,
      );
    }
    for (var y = 12.0; y < size.height - 12; y += step) {
      canvas.drawLine(Offset(5, y), Offset(15, y + 4), warp);
      canvas.drawLine(
        Offset(size.width - 5, y),
        Offset(size.width - 15, y + 4),
        warp,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WeavePainter oldDelegate) => false;
}
