import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';

// Widget de fondo animado con estilo REDL
class AnimatedRedlBackground extends StatefulWidget {
  final Widget child;

  const AnimatedRedlBackground({super.key, required this.child});

  @override
  State<AnimatedRedlBackground> createState() => _AnimatedRedlBackgroundState();
}

// Estado del widget de fondo animado
class _AnimatedRedlBackgroundState extends State<AnimatedRedlBackground>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      vsync: this,
      behaviour: RandomParticleBehaviour(
        options: const ParticleOptions(
          baseColor: Colors.redAccent,
          particleCount: 140,
          spawnMinSpeed: 35,
          spawnMaxSpeed: 90,
          spawnMinRadius: 4,
          spawnMaxRadius: 9,
          minOpacity: 0.4,
          maxOpacity: 0.9,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.35)),
          ),

          widget.child,
        ],
      ),
    );
  }
}
