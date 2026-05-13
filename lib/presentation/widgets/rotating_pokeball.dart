import 'package:flutter/material.dart';

class RotatingPokeball extends StatelessWidget {
  final double size;
  final double opacity;
  final Color? color;

  const RotatingPokeball({
    super.key,
    required this.size,
    required this.opacity,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 2 * 3.14159),
      duration: const Duration(seconds: 20),
      builder: (context, double value, child) {
        return Transform.rotate(
          angle: value,
          child: Icon(
            Icons.catching_pokemon, 
            size: size, 
            color: (color ?? Colors.white).withOpacity(opacity),
          ),
        );
      },
    );
  }
}
