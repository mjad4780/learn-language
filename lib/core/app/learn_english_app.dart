import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/settings/settings_screen.dart';
import '../theme.dart';

import '../di/injection.dart';

class LearnEnglishApp extends StatelessWidget {
  const LearnEnglishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SettingsCubit>()..init(),
      child: MaterialApp(
        title: 'Learn English',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SettingsScreen(),
      ),
    );
  }
}
