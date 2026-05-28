import 'package:flutter/material.dart';

/// Typewriter text animation — reveals characters one by one.
/// Initially ON, can be toggled off to show full text immediately.
/// Feels like text being typed on an old machine.
class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final bool animate;
  final Duration charDuration;
  final VoidCallback? onComplete;

  const TypewriterText({
    super.key,
    required this.text,
    required this.style,
    this.animate = true,
    this.charDuration = const Duration(milliseconds: 25),
    this.onComplete,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _charCount;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    final totalDuration = widget.charDuration * widget.text.length;
    _controller = AnimationController(
      vsync: this,
      duration: totalDuration,
    );

    _charCount = IntTween(
      begin: 0,
      end: widget.text.length,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_completed) {
        _completed = true;
        widget.onComplete?.call();
      }
    });

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) {
      if (!widget.animate) {
        _controller.value = 1.0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animate) {
      return Text(widget.text, style: widget.style);
    }

    return AnimatedBuilder(
      animation: _charCount,
      builder: (context, child) {
        final visibleText = widget.text.substring(0, _charCount.value);
        return Text(visibleText, style: widget.style);
      },
    );
  }
}
