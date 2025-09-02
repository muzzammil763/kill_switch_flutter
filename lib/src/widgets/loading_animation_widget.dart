import 'package:flutter/material.dart';

import '../kill_switch_theme.dart';

/// A widget that displays various loading animations
class LoadingAnimationWidget extends StatefulWidget {
  final KillSwitchTheme? theme;
  final LoadingAnimationType animationType;
  final double size;

  const LoadingAnimationWidget({
    super.key,
    this.theme,
    this.animationType = LoadingAnimationType.spinner,
    this.size = 40.0,
  });

  @override
  State<LoadingAnimationWidget> createState() => _LoadingAnimationWidgetState();
}

class _LoadingAnimationWidgetState extends State<LoadingAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    final effectiveTheme = widget.theme ?? KillSwitchTheme.auto(context);
    final duration = effectiveTheme.loadingAnimationDuration ??
        const Duration(milliseconds: 1500);

    _controller = AnimationController(
      duration: duration,
      vsync: this,
    );

    switch (widget.animationType) {
      case LoadingAnimationType.spinner:
        _animation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.linear,
        ));
        _controller.repeat();
        break;

      case LoadingAnimationType.pulse:
        _animation = Tween<double>(
          begin: 0.5,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
        _controller.repeat(reverse: true);
        break;

      case LoadingAnimationType.bounce:
        _animation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.bounceInOut,
        ));
        _controller.repeat(reverse: true);
        break;

      case LoadingAnimationType.wave:
        _animation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
        _controller.repeat();
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = widget.theme ?? KillSwitchTheme.auto(context);
    final primaryColor = effectiveTheme.primaryColor ?? Colors.blue;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        switch (widget.animationType) {
          case LoadingAnimationType.spinner:
            return Transform.rotate(
              angle: _animation.value * 2 * 3.14159,
              child: Icon(
                Icons.refresh,
                size: widget.size,
                color: primaryColor,
              ),
            );

          case LoadingAnimationType.pulse:
            return Transform.scale(
              scale: _animation.value,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withValues(alpha: 0.8),
                ),
              ),
            );

          case LoadingAnimationType.bounce:
            return Transform.translate(
              offset: Offset(0, -20 * _animation.value),
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
              ),
            );

          case LoadingAnimationType.wave:
            return SizedBox(
              width: widget.size * 2,
              height: widget.size,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (index) {
                  final delay = index * 0.2;
                  final animationValue =
                      (_animation.value - delay).clamp(0.0, 1.0);
                  return Transform.scale(
                    scale: 0.5 + 0.5 * animationValue,
                    child: Container(
                      width: widget.size * 0.3,
                      height: widget.size * 0.3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor.withValues(alpha: animationValue),
                      ),
                    ),
                  );
                }),
              ),
            );
        }
      },
    );
  }
}

/// Types of loading animations available
enum LoadingAnimationType {
  /// Spinning refresh icon
  spinner,

  /// Pulsing circle
  pulse,

  /// Bouncing circle
  bounce,

  /// Wave effect with multiple dots
  wave,
}
