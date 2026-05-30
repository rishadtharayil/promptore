import 'dart:math';
import 'package:flutter/material.dart';

/// Film grain overlay — adds subtle texture to backgrounds.
/// Creates an atmospheric, vintage film feel.
class GrainOverlay extends StatelessWidget {
  final double opacity;
  final Widget child;

  const GrainOverlay({
    super.key,
    this.opacity = 0.03,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _GrainPainter(opacity: opacity),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GrainPainter extends CustomPainter {
  final double opacity;
  final Random _random = Random(42); // Fixed seed for consistent grain

  _GrainPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final int dotCount = (size.width * size.height * 0.002).toInt();

    for (int i = 0; i < dotCount; i++) {
      final x = _random.nextDouble() * size.width;
      final y = _random.nextDouble() * size.height;
      final brightness = _random.nextDouble();

      paint.color = Color.fromRGBO(
        (brightness * 255).toInt(),
        (brightness * 240).toInt(),
        (brightness * 220).toInt(),
        opacity * (0.5 + _random.nextDouble() * 0.5),
      );

      canvas.drawCircle(Offset(x, y), 0.5 + _random.nextDouble() * 0.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
