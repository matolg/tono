import 'package:flutter/material.dart';

import '../../../shared/widgets/app_bar_widget.dart';

class TunerScreen extends StatelessWidget {
  const TunerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Тюнер', showBack: true),
      body: const Center(child: Text('Тюнер — в разработке')),
    );
  }
}
