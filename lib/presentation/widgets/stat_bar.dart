import 'package:flutter/material.dart';

class StatBar extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final int maxValue;

  const StatBar({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    this.maxValue = 150,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          SizedBox(
            width: 100, 
            child: Text(
              label.toUpperCase(), 
              style: TextStyle(
                color: onSurface.withOpacity(0.5), 
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 40, 
            child: Text(
              '$value', 
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: value / maxValue),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, val, _) => LinearProgressIndicator(
                value: val,
                backgroundColor: color.withOpacity(0.1),
                color: color,
                minHeight: 10,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
