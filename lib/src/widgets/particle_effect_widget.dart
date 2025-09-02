import 'dart:math';

import 'package:flutter/material.dart';

/// A widget that creates particle effects for micro-interactions
class ParticleEffectWidget extends StatefulWidget {
  final int particleCount;
  final Color particleColor;
  final AnimationController animationController;

  const ParticleEffectWidget({
    super.key,
    required this.particleCount,
    required this.particleColor,
    required this.animationController,
  });

  @override
  State<ParticleEffectWidget> createState() => _ParticleEffectWidgetState();
}

class _ParticleEffectWidgetState extends State<ParticleEffectWidget> {
  late List<Particle> particles;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _initializeParticles();
  }

  void _initializeParticles() {
    particles = List.generate(widget.particleCount, (index) {
      return Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 4 + 2,
        speed: random.nextDouble() * 0.02 + 0.01,
        direction: random.nextDouble() * 2 * pi,
        opacity: random.nextDouble() * 0.8 + 0.2,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(
            particles: particles,
            color: widget.particleColor,
            progress: widget.animationController.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

/// Represents a single particle in the effect
class Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final double direction;
  final double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.direction,
    required this.opacity,
  });

  void update() {
    x += cos(direction) * speed;
    y += sin(direction) * speed;

    // Wrap around screen edges
    if (x > 1.0) x = 0.0;
    if (x < 0.0) x = 1.0;
    if (y > 1.0) y = 0.0;
    if (y < 0.0) y = 1.0;
  }
}

/// Custom painter for rendering particles
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Color color;
  final double progress;

  ParticlePainter({
    required this.particles,
    required this.color,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: progress * 0.6)
      ..style = PaintingStyle.fill;

    for (final particle in particles) {
      // Update particle position
      particle.update();

      // Calculate actual position on canvas
      final x = particle.x * size.width;
      final y = particle.y * size.height;

      // Draw particle with fade effect based on progress
      final particleOpacity = particle.opacity * progress;
      paint.color = color.withValues(alpha: particleOpacity);

      canvas.drawCircle(
        Offset(x, y),
        particle.size * progress,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
