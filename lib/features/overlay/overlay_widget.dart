import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/overlay_cubit.dart';
import 'cubit/overlay_state.dart';
import '../../core/shared/widgets/overlay_content.dart';

/// The overlay widget displayed on top of other apps.
/// Uses OverlayCubit instead of setState for state management.
class OverlayWidget extends StatefulWidget {
  const OverlayWidget({super.key});

  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _progressController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  static const int _autoDismissSeconds = 5;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: _autoDismissSeconds),
    );

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _fadeController.reverse();
        _slideController.reverse();
        Future.delayed(const Duration(milliseconds: 600)).then((_) {
          if (mounted) context.read<OverlayCubit>().closeOverlay();
        });
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OverlayCubit, OverlayViewState>(
      listener: (context, state) {
        if (state.isLoaded) {
          _fadeController.forward(from: 0);
          _slideController.forward(from: 0);
          _progressController.forward(from: 0);
        }
      },
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SwipeHandler(progressController: _progressController),
            ),
          ),
        ),
      ),
    );
  }
}

class SwipeHandler extends StatelessWidget {
  final AnimationController progressController;

  const SwipeHandler({super.key, required this.progressController});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OverlayCubit>();
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;
        if (details.primaryVelocity! < -200) {
          progressController.stop(); // Stop the timer if dragged
          cubit.closeOverlay();
        } else if (details.primaryVelocity! > 200) {
          progressController.forward(from: 0); // Reset timer for next sentence
          cubit.requestNext();
        }
      },
      child: Align(
        alignment: AlignmentGeometry.bottomRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: OverlayCard(),
            ),
          ),
        ),
      ),
    );
  }
}

class OverlayCard extends StatelessWidget {
  const OverlayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF6C63FF).withValues(alpha: 0.85),
            const Color(0xFF3F3D9E).withValues(alpha: 0.9),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: OverlayContent(),
    );
  }
}
