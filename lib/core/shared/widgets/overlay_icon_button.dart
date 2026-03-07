import 'package:flutter/material.dart';

/// Small icon button used in the overlay top bar.
class OverlayIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const OverlayIconButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
