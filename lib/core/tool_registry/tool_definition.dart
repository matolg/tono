import 'package:flutter/material.dart';

class ToolDefinition {
  final String id;
  final String name;
  final String subtitle;
  final IconData icon;
  final bool isAvailable;
  final String route;

  const ToolDefinition({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.isAvailable,
    required this.route,
  });
}
