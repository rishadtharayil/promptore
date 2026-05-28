import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Fade-in widget — wraps content with staggered cinematic entrance animation.
/// Everything in PROMPTORE fades in slowly, like thoughts materializing.
class FadeIn extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Offset slideOffset;
  final Curve curve;

  const FadeIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.slideOffset = const Offset(0, 0.05),
    this.curve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return child
        .animate()
        .fadeIn(duration: duration, delay: delay, curve: curve)
        .slide(
          begin: slideOffset,
          end: Offset.zero,
          duration: duration,
          delay: delay,
          curve: curve,
        );
  }
}

/// Staggered fade-in for lists — each item appears with increasing delay.
class StaggeredFadeIn extends StatelessWidget {
  final Widget child;
  final int index;
  final Duration itemDuration;
  final Duration staggerDelay;

  const StaggeredFadeIn({
    super.key,
    required this.child,
    required this.index,
    this.itemDuration = const Duration(milliseconds: 500),
    this.staggerDelay = const Duration(milliseconds: 80),
  });

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: itemDuration,
      delay: staggerDelay * index,
      child: child,
    );
  }
}
