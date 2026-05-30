import 'package:flutter/material.dart';
import 'package:promptore/core/theme/color_extension.dart';
import '../theme/colors.dart';

/// Atmospheric divider — faded gradient line instead of harsh borders.
/// Creates visual breathing room between content sections.
class AtmosphericDivider extends StatelessWidget {
  final double height;
  final double indent;
  final double endIndent;

  const AtmosphericDivider({
    super.key,
    this.height = 0.5,
    this.indent = 0,
    this.endIndent = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: indent, right: endIndent),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              PromptoreColorExtension.of(context).warmGray,
              PromptoreColorExtension.of(context).warmGray,
              Colors.transparent,
            ],
            stops: [0.0, 0.2, 0.8, 1.0],
          ),
        ),
      ),
    );
  }
}
