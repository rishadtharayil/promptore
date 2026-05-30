import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// Ambient glow container — wraps content with a soft radial gradient.
/// Creates the "warm light in darkness" atmosphere.
class GlowContainer extends StatelessWidget {
  final Widget child;
  final Color? glowColor;
  final double glowRadius;
  final double glowOpacity;
  final AlignmentGeometry glowAlignment;

  const GlowContainer({
    super.key,
    required this.child,
    this.glowColor,
    this.glowRadius = 0.8,
    this.glowOpacity = 0.06,
    this.glowAlignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: glowAlignment,
          radius: glowRadius,
          colors: [
            (glowColor ?? PromptoreColors.mutedGold).withValues(alpha: glowOpacity),
            Colors.transparent,
          ],
        ),
      ),
      child: child,
    );
  }
}
