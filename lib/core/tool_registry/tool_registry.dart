import 'package:flutter/material.dart';

import 'tool_definition.dart';

abstract final class ToolRegistry {
  static const List<ToolDefinition> all = [
    ToolDefinition(
      id: 'tuner',
      name: 'Тюнер',
      subtitle: 'Хроматический тюнер',
      icon: Icons.graphic_eq,
      isAvailable: true,
      route: '/tuner',
    ),
    ToolDefinition(
      id: 'metronome',
      name: 'Метроном',
      subtitle: 'Ритм и темп',
      icon: Icons.timer,
      isAvailable: true,
      route: '/metronome',
    ),
    ToolDefinition(
      id: 'ear_trainer',
      name: 'Тренажёр слуха',
      subtitle: 'Интервалы и аккорды',
      icon: Icons.hearing,
      isAvailable: false,
      route: '/ear-trainer',
    ),
    ToolDefinition(
      id: 'chord_trainer',
      name: 'Тренажёр аккордов',
      subtitle: 'Гаммы и трезвучия',
      icon: Icons.piano,
      isAvailable: false,
      route: '/chord-trainer',
    ),
  ];
}
