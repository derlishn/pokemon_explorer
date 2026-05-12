import 'package:flutter/material.dart';

class AppColors {
  static Color getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return Colors.redAccent;
      case 'water':
        return Colors.blueAccent;
      case 'grass':
        return Colors.greenAccent[700]!;
      case 'electric':
        return Colors.yellow[700]!;
      case 'psychic':
        return Colors.purpleAccent;
      case 'ice':
        return Colors.cyanAccent;
      case 'dragon':
        return Colors.indigoAccent;
      case 'dark':
        return Colors.grey[800]!;
      case 'fairy':
        return Colors.pinkAccent;
      case 'normal':
        return Colors.grey;
      case 'fighting':
        return Colors.orange[900]!;
      case 'flying':
        return Colors.indigo[300]!;
      case 'poison':
        return Colors.purple;
      case 'ground':
        return Colors.brown;
      case 'rock':
        return Colors.blueGrey;
      case 'bug':
        return Colors.lightGreen;
      case 'ghost':
        return Colors.deepPurple;
      case 'steel':
        return Colors.blueGrey[300]!;
      default:
        return Colors.grey;
    }
  }
}
