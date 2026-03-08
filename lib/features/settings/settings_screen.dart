import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../articles/presentation/widgets/articles_entry_card.dart';

import 'widgets/add_sentences_card.dart';
import 'widgets/info_card.dart';
import 'widgets/interval_selector.dart';
import 'widgets/settings_header.dart';
import 'widgets/stats_card.dart';
import 'widgets/toggle_button.dart';

/// Main settings screen — orchestrates sub-widgets.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                const SettingsHeader(),
                const SizedBox(height: 36),
                ToggleButton(pulseAnimation: _pulseAnimation),
                const SizedBox(height: 36),
                const IntervalSelector(),
                const SizedBox(height: 28),
                const StatsCard(),
                const SizedBox(height: 28),
                const AddSentencesCard(),
                const SizedBox(height: 28),
                const ArticlesEntryCard(),
                const SizedBox(height: 28),
                const InfoCard(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
