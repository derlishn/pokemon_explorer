import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFFFF5252);
  static const Color secondary = Color(0xFF3B4CCA);
  
  // Neutral Colors
  static const Color surfaceLight = Color(0xFFF5F5F5);
  static const Color surfaceDark = Color(0xFF121212);
  
  // Pokemon Types (Utility)
  static Color getTypeColor(List<String> types) {
    if (types.isEmpty) return Colors.blueGrey;
    
    final mainType = types.first.toLowerCase();
    switch (mainType) {
      case 'fire': return Colors.orange;
      case 'water': return Colors.blue;
      case 'grass': return Colors.green;
      case 'electric': return Colors.yellow[700]!;
      case 'poison': return Colors.purple;
      case 'psychic': return Colors.pink;
      case 'rock': return Colors.brown;
      case 'ice': return Colors.cyan;
      case 'ghost': return Colors.indigo;
      case 'dragon': return Colors.deepPurple;
      case 'bug': return Colors.lightGreen;
      case 'flying': return Colors.indigo[300]!;
      case 'fighting': return Colors.red[900]!;
      case 'normal': return Colors.grey;
      default: return Colors.blueGrey;
    }
  }
}
