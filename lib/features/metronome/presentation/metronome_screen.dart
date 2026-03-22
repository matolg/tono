import 'package:flutter/material.dart';

import '../../../shared/widgets/app_bar_widget.dart';

class MetronomeScreen extends StatelessWidget {
  const MetronomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Метроном', showBack: true),
      body: const Center(child: Text('Метроном — в разработке')),
    );
  }
}
