import 'package:flutter/material.dart';

import '../../../shared/widgets/app_bar_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Настройки', showBack: true),
      body: const Center(child: Text('Настройки — в разработке')),
    );
  }
}
