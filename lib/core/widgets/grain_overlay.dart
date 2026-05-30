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
    return child;
  }
}
