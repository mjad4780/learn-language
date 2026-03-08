import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/overlay/cubit/overlay_cubit.dart';
import '../../../features/overlay/cubit/overlay_state.dart';

/// Overlay content displaying English sentence and Arabic translation.
class OverlayContent extends StatelessWidget {
  const OverlayContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OverlayCubit, OverlayViewState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              // Row(
              //   children: [
              //     const Spacer(),
              //     OverlayIconButton(
              //       icon: Icons.close_rounded,
              //       onTap: () => context.read<OverlayCubit>().closeOverlay(),
              //     ),
              //   ],
              // ),

              // English
              InkWell(
                onTap: () => context.read<OverlayCubit>().closeOverlay(),

                child: Text(
                  state.english.isEmpty ? "No data..." : state.english,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    // height: 1.4,
                    // letterSpacing: 0.3,
                  ),
                ),
              ),

              // const SizedBox(height: 10),
              // Divider line
              // Container(
              //   height: 4,
              //   width: 60,
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //       colors: [
              //         Colors.transparent,
              //         Colors.white.withValues(alpha: 0.5),
              //         Colors.transparent,
              //       ],
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 5),
              // // Arabic
              // Text(
              //   state.arabic,
              //   textAlign: TextAlign.center,
              //   textDirection: TextDirection.rtl,
              //   style: TextStyle(
              //     fontSize: 16,
              //     fontWeight: FontWeight.w500,
              //     color: Colors.white.withValues(alpha: 0.85),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
