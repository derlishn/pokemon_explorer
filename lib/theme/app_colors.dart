import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color primary = Color(0xFFE3350D); // Classic Pokémon Red
  static const Color secondary = Color(0xFF3166B3); // Classic Pokémon Blue
  static const Color accent = Color(0xFFFFCB05); // Classic Pokémon Yellow
  
  // Neutral Colors
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E1E1E);
  
  // Status Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  
  // Custom HSL Gradient Generator
  static LinearGradient primaryGradient = const LinearGradient(
    colors: [primary, Color(0xFFFF5252)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
