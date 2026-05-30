import 'package:flutter/material.dart';
import 'package:promptore/core/theme/color_extension.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:promptore/core/theme/colors.dart';
import 'package:promptore/core/theme/color_extension.dart';
import 'package:promptore/core/theme/typography.dart';
import 'package:promptore/core/theme/dimensions.dart';
import 'package:promptore/core/widgets/grain_overlay.dart';

/// PROMPTORE Onboarding — a 3-screen atmospheric intro.
/// Like entering a dark library at midnight: slow fades,
/// floating text, gold radial glows, and cinematic pacing.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PromptoreColorExtension.of(context).background,
      body: GrainOverlay(
        child: Stack(
          children: [
            // Page content
            PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              physics: const _CinematicPagePhysics(parent: ClampingScrollPhysics()),
              children: const [
                _PageOne(),
                _PageTwo(),
                _PageThree(),
              ],
            ),

            // Custom page indicator dots
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: _PageIndicator(currentPage: _currentPage),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PAGE ONE — "Wander through human imagination"
// ─────────────────────────────────────────────────────────────────────────────

class _PageOne extends StatelessWidget {
  const _PageOne();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Stack(
      children: [
        // Soft gold radial glow background
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.0, -0.2),
                radius: 0.9,
                colors: [
                  PromptoreColorExtension.of(context).mutedGold.withValues(alpha: 0.07),
                  PromptoreColorExtension.of(context).mutedGold.withValues(alpha: 0.02),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),
        ),

        // Main content
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.pagePaddingH,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.15),

              // Title with floating animation
              Text(
                'Wander through\nhuman imagination',
                style: PromptoreTypography.displayLarge.copyWith(
                  fontSize: 38,
                  fontWeight: FontWeight.w300,
                  height: 1.15,
                ),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .moveY(
                    begin: 0,
                    end: -6,
                    duration: 3200.ms,
                    curve: Curves.easeInOut,
                  )
                  .animate() // entrance animation
                  .fadeIn(duration: 1200.ms, curve: Curves.easeOut)
                  .slideY(
                    begin: 0.08,
                    end: 0,
                    duration: 1200.ms,
                    curve: Curves.easeOut,
                  ),

              const SizedBox(height: Dimensions.lg),

              // Subtext
              Text(
                'Discover prompts that feel like artifacts — '
                'fragments of thought preserved in amber, '
                'waiting for the right mind to find them.',
                style: PromptoreTypography.bodyMedium.copyWith(
                  color: PromptoreColorExtension.of(context).dustySepia.withValues(alpha: 0.8),
                  height: 1.7,
                ),
              )
                  .animate()
                  .fadeIn(
                    duration: 1000.ms,
                    delay: 600.ms,
                    curve: Curves.easeOut,
                  )
                  .slideY(
                    begin: 0.06,
                    end: 0,
                    duration: 1000.ms,
                    delay: 600.ms,
                    curve: Curves.easeOut,
                  ),

              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PAGE TWO — "Discover emotional artifacts"
// ─────────────────────────────────────────────────────────────────────────────

class _PageTwo extends StatelessWidget {
  const _PageTwo();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Stack(
      children: [
        // Floating prompt card previews
        ..._buildFloatingCards(context, size),

        // Main content
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.pagePaddingH,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.12),

              // Title
              Text(
                'Discover\nemotional artifacts',
                style: PromptoreTypography.displayLarge.copyWith(
                  fontSize: 38,
                  fontWeight: FontWeight.w300,
                  height: 1.15,
                ),
              )
                  .animate()
                  .fadeIn(duration: 1000.ms, curve: Curves.easeOut)
                  .slideY(
                    begin: 0.08,
                    end: 0,
                    duration: 1000.ms,
                    curve: Curves.easeOut,
                  ),

              const SizedBox(height: Dimensions.lg),

              // Subtext
              Text(
                'Collect, remix, and transmit prompts '
                'that resonate. Every echo amplifies '
                'something worth preserving.',
                style: PromptoreTypography.bodyMedium.copyWith(
                  color: PromptoreColorExtension.of(context).dustySepia.withValues(alpha: 0.8),
                  height: 1.7,
                ),
              )
                  .animate()
                  .fadeIn(
                    duration: 1000.ms,
                    delay: 400.ms,
                    curve: Curves.easeOut,
                  )
                  .slideY(
                    begin: 0.06,
                    end: 0,
                    duration: 1000.ms,
                    delay: 400.ms,
                    curve: Curves.easeOut,
                  ),

              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }

  /// Three small floating prompt card previews that drift slowly
  List<Widget> _buildFloatingCards(BuildContext context, Size size) {
    final cards = [
      _FloatingCardData(
        title: 'The Machine That\nDreams In Rain',
        left: size.width * 0.5,
        top: size.height * 0.52,
        angle: -0.03,
        driftDelay: 0,
      ),
      _FloatingCardData(
        title: 'Oracle of\nForgotten Futures',
        left: size.width * 0.08,
        top: size.height * 0.62,
        angle: 0.02,
        driftDelay: 800,
      ),
      _FloatingCardData(
        title: 'Letters From\nYour Future Self',
        left: size.width * 0.38,
        top: size.height * 0.74,
        angle: -0.015,
        driftDelay: 1600,
      ),
    ];

    return cards.map((data) {
      return Positioned(
        left: data.left,
        top: data.top,
        child: Transform.rotate(
          angle: data.angle,
          child: Container(
            width: 150,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: PromptoreColorExtension.of(context).surface,
              border: Border.all(
                color: PromptoreColorExtension.of(context).warmGray.withValues(alpha: 0.5),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(Dimensions.radiusSm),
            ),
            child: Text(
              data.title,
              style: PromptoreTypography.metaMedium.copyWith(
                color: PromptoreColorExtension.of(context).dustySepia.withValues(alpha: 0.7),
                height: 1.5,
              ),
            ),
          )
              // Slow vertical drift — each card drifts independently
              .animate(
                onPlay: (c) => c.repeat(reverse: true),
              )
              .moveY(
                begin: 0,
                end: -8,
                duration: 4000.ms,
                delay: Duration(milliseconds: data.driftDelay),
                curve: Curves.easeInOut,
              )
              // Entrance fade
              .animate()
              .fadeIn(
                duration: 800.ms,
                delay: Duration(milliseconds: 600 + data.driftDelay ~/ 2),
                curve: Curves.easeOut,
              )
              .scale(
                begin: const Offset(0.92, 0.92),
                end: const Offset(1, 1),
                duration: 800.ms,
                delay: Duration(milliseconds: 600 + data.driftDelay ~/ 2),
                curve: Curves.easeOut,
              ),
        ),
      );
    }).toList();
  }
}

/// Data holder for floating card positions and drift parameters
class _FloatingCardData {
  final String title;
  final double left;
  final double top;
  final double angle;
  final int driftDelay;

  const _FloatingCardData({
    required this.title,
    required this.left,
    required this.top,
    required this.angle,
    required this.driftDelay,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// PAGE THREE — "Enter the archive"
// ─────────────────────────────────────────────────────────────────────────────

class _PageThree extends StatelessWidget {
  const _PageThree();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.pagePaddingH,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: size.height * 0.2),

          // Title — centered for the final screen
          Text(
            'Enter\nthe archive',
            textAlign: TextAlign.center,
            style: PromptoreTypography.displayLarge.copyWith(
              fontSize: 42,
              fontWeight: FontWeight.w300,
              height: 1.15,
            ),
          )
              .animate()
              .fadeIn(duration: 1000.ms, curve: Curves.easeOut)
              .slideY(
                begin: 0.08,
                end: 0,
                duration: 1000.ms,
                curve: Curves.easeOut,
              ),

          const SizedBox(height: Dimensions.xxl),

          // CTA button with pulsing glow behind it
          _BeginExploringButton(
            onPressed: () => context.go('/feed'),
          )
              .animate()
              .fadeIn(
                duration: 800.ms,
                delay: 600.ms,
                curve: Curves.easeOut,
              )
              .scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1, 1),
                duration: 800.ms,
                delay: 600.ms,
                curve: Curves.easeOut,
              ),

          const Spacer(),
        ],
      ),
    );
  }
}

/// Golden CTA button with subtle pulsing glow behind it
class _BeginExploringButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _BeginExploringButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Pulsing ambient glow behind the button
        Container(
          width: 240,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusXl),
            boxShadow: [
              BoxShadow(
                color: PromptoreColorExtension.of(context).mutedGold.withValues(alpha: 0.2),
                blurRadius: 40,
                spreadRadius: 8,
              ),
            ],
          ),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scaleXY(
              begin: 0.95,
              end: 1.1,
              duration: 2400.ms,
              curve: Curves.easeInOut,
            )
            .then()
            .scaleXY(
              begin: 1.1,
              end: 0.95,
              duration: 2400.ms,
              curve: Curves.easeInOut,
            ),

        // The actual button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(Dimensions.radiusXl),
            splashColor: PromptoreColorExtension.of(context).mutedGold.withValues(alpha: 0.1),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 48,
                vertical: 18,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: PromptoreColorExtension.of(context).mutedGold.withValues(alpha: 0.6),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(Dimensions.radiusXl),
                color: PromptoreColorExtension.of(context).mutedGold.withValues(alpha: 0.08),
              ),
              child: Text(
                'Begin Exploring',
                style: PromptoreTypography.titleMedium.copyWith(
                  color: PromptoreColorExtension.of(context).mutedGold,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CUSTOM PAGE INDICATOR — small gold circles
// ─────────────────────────────────────────────────────────────────────────────

class _PageIndicator extends StatelessWidget {
  final int currentPage;

  const _PageIndicator({required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: Dimensions.animMedium),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: isActive ? 10 : 6,
          height: isActive ? 10 : 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? PromptoreColorExtension.of(context).mutedGold
                : PromptoreColorExtension.of(context).mutedGold.withValues(alpha: 0.25),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color:
                          PromptoreColorExtension.of(context).mutedGold.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CINEMATIC PAGE PHYSICS — slow, heavy scrolling for atmospheric feel
// ─────────────────────────────────────────────────────────────────────────────

class _CinematicPagePhysics extends PageScrollPhysics {
  const _CinematicPagePhysics({super.parent});

  @override
  _CinematicPagePhysics applyTo(ScrollPhysics? ancestor) {
    return _CinematicPagePhysics(parent: buildParent(ancestor ?? const ClampingScrollPhysics()));
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    // If out of scroll bounds, delegate to parent
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }

    final double page = position.pixels / position.viewportDimension;
    double targetPage;
    
    // Choose target page based on fling direction/velocity
    if (velocity < -400.0) {
      targetPage = page.floorToDouble();
    } else if (velocity > 400.0) {
      targetPage = page.ceilToDouble();
    } else {
      targetPage = page.roundToDouble();
    }

    // Absolute insurance: never let a single gesture target beyond the adjacent page
    final double currentPage = (position.pixels / position.viewportDimension).roundToDouble();
    targetPage = targetPage.clamp(currentPage - 1.0, currentPage + 1.0);

    final double targetPixels = targetPage * position.viewportDimension;
    if (targetPixels == position.pixels) {
      return null;
    }

    return ScrollSpringSimulation(
      spring,
      position.pixels,
      targetPixels,
      velocity,
      tolerance: toleranceFor(position),
    );
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 1.0,
        stiffness: 60.0,
        damping: 20.0, // Critically/Over-damped to remove all bounciness/oscillation
      );
}
