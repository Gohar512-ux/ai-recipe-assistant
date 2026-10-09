import 'package:flutter/material.dart';

class StatChip extends StatelessWidget {
  const StatChip(this.icon, this.label, {super.key, this.light = false});
  final IconData icon;
  final String label;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final color = light ? Colors.white : Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: light ? Colors.white.withAlpha(50) : color.withAlpha(28),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  fontSize: 12.5, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}
