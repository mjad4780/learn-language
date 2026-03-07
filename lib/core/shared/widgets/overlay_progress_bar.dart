import 'package:flutter/material.dart';

/// Countdown progress bar for the overlay auto-dismiss timer.
class OverlayProgressBar extends StatelessWidget {
  final Animation<double> animation;

  const OverlayProgressBar({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return SizedBox(
          height: 3,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            child: LinearProgressIndicator(
              value: 1.0 - animation.value,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF00D2FF),
              ),
            ),
          ),
        );
      },
    );
  }
}
