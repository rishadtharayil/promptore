import 'package:flutter/material.dart';
import '../theme/color_extension.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? sideNavigationBar;
  final double sideNavBreakpoint;
  final double contentMaxWidth;

  const ResponsiveLayout({
    super.key,
    required this.body,
    this.bottomNavigationBar,
    this.sideNavigationBar,
    this.sideNavBreakpoint = 700.0,
    this.contentMaxWidth = 650.0,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= sideNavBreakpoint;

    final rightPadding = width * 0.1;
    final leftPadding = sideNavigationBar != null
        ? (width * 0.1 - 80).clamp(0.0, double.infinity)
        : width * 0.1;

    return Scaffold(
      backgroundColor: PromptoreColorExtension.of(context).background,
      body: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (sideNavigationBar != null) sideNavigationBar!,
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: leftPadding,
                      right: rightPadding,
                    ),
                    child: body,
                  ),
                ),
              ],
            )
          : body,
      bottomNavigationBar: isWide ? null : bottomNavigationBar,
    );
  }
}
