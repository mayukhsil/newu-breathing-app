import 'package:flutter/material.dart';

class SmoothBreathingProgress extends StatefulWidget {
  final double value;
  final Color? color;
  final Color? backgroundColor;
  final bool isPaused;

  const SmoothBreathingProgress({
    super.key,
    required this.value,
    this.color,
    this.backgroundColor,
    this.isPaused = false,
  });

  @override
  State<SmoothBreathingProgress> createState() =>
      _SmoothBreathingProgressState();
}

class _SmoothBreathingProgressState extends State<SmoothBreathingProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(
      begin: widget.value,
      end: widget.value,
    ).animate(_controller);
    _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(SmoothBreathingProgress oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value) {
      double beginValue = _animation.value;

      // If returning to 0 entirely, snap immediately
      if (widget.value == 0.0) {
        beginValue = 0.0;
        _controller.duration = Duration.zero;
      } else {
        _controller.duration = const Duration(seconds: 1);
      }

      _animation = Tween<double>(
        begin: beginValue,
        end: widget.value,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

      if (!widget.isPaused) {
        _controller.forward(from: 0.0);
      }
    } else if (widget.isPaused != oldWidget.isPaused) {
      if (widget.isPaused) {
        _controller.stop();
      } else {
        _controller.forward();
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _animation.value,
            minHeight: 8,
            backgroundColor: widget.backgroundColor,
            valueColor: widget.color != null
                ? AlwaysStoppedAnimation<Color>(widget.color!)
                : null,
          ),
        );
      },
    );
  }
}
