import 'package:flutter/material.dart';

import 'kill_switch_dialog.dart';
import 'kill_switch_theme.dart';
import 'widgets/particle_effect_widget.dart';

/// An animated version of KillSwitchDialog with smooth transitions and effects
class AnimatedKillSwitchDialog extends StatefulWidget {
  final VoidCallback onClose;
  final KillSwitchTheme? theme;
  final String? title;
  final String? message;
  final String? buttonText;
  final Function(String action, Map<String, dynamic> data)? onFormAction;
  final bool enableRichContent;

  const AnimatedKillSwitchDialog({
    super.key,
    required this.onClose,
    this.theme,
    this.title,
    this.message,
    this.buttonText,
    this.onFormAction,
    this.enableRichContent = true,
  });

  @override
  State<AnimatedKillSwitchDialog> createState() =>
      _AnimatedKillSwitchDialogState();
}

class _AnimatedKillSwitchDialogState extends State<AnimatedKillSwitchDialog>
    with TickerProviderStateMixin {
  late AnimationController _dialogController;
  late AnimationController _loadingController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startEntranceAnimation();
  }

  void _initializeAnimations() {
    final effectiveTheme = widget.theme ?? KillSwitchTheme.auto(context);
    final duration =
        effectiveTheme.animationDuration ?? const Duration(milliseconds: 300);
    final loadingDuration = effectiveTheme.loadingAnimationDuration ??
        const Duration(milliseconds: 1500);

    // Main dialog animation controller
    _dialogController = AnimationController(
      duration: duration,
      vsync: this,
    );

    // Loading animation controller
    _loadingController = AnimationController(
      duration: loadingDuration,
      vsync: this,
    );

    // Create animations based on animation type
    _createAnimationsForType(effectiveTheme);

    // Loading animation (continuous rotation)

    // Start loading animation
    _loadingController.repeat();
  }

  void _createAnimationsForType(KillSwitchTheme theme) {
    final animationType = theme.animationType ?? AnimationType.scale;
    final entranceCurve = theme.entranceCurve ?? Curves.easeOutCubic;

    switch (animationType) {
      case AnimationType.fade:
        _fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _dialogController,
          curve: entranceCurve,
        ));
        break;

      case AnimationType.scale:
        _scaleAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _dialogController,
          curve: entranceCurve,
        ));
        break;

      case AnimationType.slideFromBottom:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _dialogController,
          curve: entranceCurve,
        ));
        break;

      case AnimationType.slideFromTop:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(0.0, -1.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _dialogController,
          curve: entranceCurve,
        ));
        break;

      case AnimationType.slideFromLeft:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(-1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _dialogController,
          curve: entranceCurve,
        ));
        break;

      case AnimationType.slideFromRight:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _dialogController,
          curve: entranceCurve,
        ));
        break;

      case AnimationType.bounce:
        _scaleAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _dialogController,
          curve: Curves.bounceOut,
        ));
        break;

      case AnimationType.elastic:
        _scaleAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _dialogController,
          curve: Curves.elasticOut,
        ));
        break;
    }

    // Always create fade animation for combined effects
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _dialogController,
      curve: entranceCurve,
    ));
  }

  void _startEntranceAnimation() {
    final effectiveTheme = widget.theme ?? KillSwitchTheme.auto(context);
    if (effectiveTheme.enableAnimations ?? true) {
      _dialogController.forward();
    } else {
      _dialogController.value = 1.0;
    }
  }

  Future<void> _handleClose() async {
    if (_isClosing) return;

    setState(() {
      _isClosing = true;
    });

    final effectiveTheme = widget.theme ?? KillSwitchTheme.auto(context);
    if (effectiveTheme.enableAnimations ?? true) {
      final exitCurve = effectiveTheme.exitCurve ?? Curves.easeInCubic;

      // Update animation curve for exit
      _dialogController
          .animateBack(
        0.0,
        curve: exitCurve,
      )
          .then((_) {
        widget.onClose();
      });
    } else {
      widget.onClose();
    }
  }

  @override
  void dispose() {
    _dialogController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = widget.theme ?? KillSwitchTheme.auto(context);
    final animationType = effectiveTheme.animationType ?? AnimationType.scale;

    Widget dialogContent = KillSwitchDialog(
      onClose: _handleClose,
      theme: widget.theme,
      title: widget.title,
      message: widget.message,
      buttonText: widget.buttonText,
      onFormAction: widget.onFormAction,
      enableRichContent: widget.enableRichContent,
    );

    // Apply animations based on type
    switch (animationType) {
      case AnimationType.fade:
        dialogContent = FadeTransition(
          opacity: _fadeAnimation,
          child: dialogContent,
        );
        break;

      case AnimationType.scale:
      case AnimationType.bounce:
      case AnimationType.elastic:
        dialogContent = ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: dialogContent,
          ),
        );
        break;

      case AnimationType.slideFromBottom:
      case AnimationType.slideFromTop:
      case AnimationType.slideFromLeft:
      case AnimationType.slideFromRight:
        dialogContent = SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: dialogContent,
          ),
        );
        break;
    }

    // Add particle effects if enabled
    if (effectiveTheme.enableParticleEffects ?? false) {
      dialogContent = Stack(
        children: [
          ParticleEffectWidget(
            particleCount: effectiveTheme.particleCount ?? 20,
            particleColor: effectiveTheme.particleColor ?? Colors.blue,
            animationController: _dialogController,
          ),
          dialogContent,
        ],
      );
    }

    return AnimatedBuilder(
      animation: _dialogController,
      builder: (context, child) {
        return dialogContent;
      },
    );
  }
}

/// Custom page route for animated dialog transitions
class AnimatedDialogRoute<T> extends PageRoute<T> {
  final Widget dialog;
  final KillSwitchTheme? theme;

  AnimatedDialogRoute({
    required this.dialog,
    this.theme,
    super.settings,
  });

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color? get barrierColor => Colors.black54;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration {
    final effectiveTheme = theme ?? KillSwitchTheme.light();
    return effectiveTheme.animationDuration ??
        const Duration(milliseconds: 300);
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return dialog;
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
