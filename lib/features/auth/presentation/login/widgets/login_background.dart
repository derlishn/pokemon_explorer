import 'package:flutter/material.dart';
import 'package:pokemon_explorer/core/widgets/rotating_pokeball.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -100,
          child: RotatingPokeball(
            size: 400,
            opacity: 0.05,
            color: colorScheme.primary,
          ),
        ),
        Positioned(
          bottom: -150,
          left: -150,
          child: RotatingPokeball(
            size: 500,
            opacity: 0.03,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
