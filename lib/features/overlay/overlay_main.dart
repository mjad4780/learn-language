import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/overlay_cubit.dart';
import 'overlay_widget.dart';

/// Entry point for the overlay process.
/// This runs in a separate isolate when the overlay is displayed.
@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => OverlayCubit(),
        child: const OverlayWidget(),
      ),
    ),
  );
}
