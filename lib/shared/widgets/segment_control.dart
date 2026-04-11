import 'package:flutter/material.dart';

import '../../app/theme/app_text_styles.dart';

/// Generic segmented control (height 40, radius 12/8).
/// Matches the "Segment Control" component from the design system.
class SegmentControl<T> extends StatelessWidget {
  final List<T> values;
  final T selected;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;

  /// When true the control stretches to fill its parent's width and
  /// distributes segments evenly. Defaults to false (compact/intrinsic width).
  final bool expanded;

  const SegmentControl({
    super.key,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 40,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
        children: values.map((v) {
          final isSelected = v == selected;
          Widget item = GestureDetector(
            onTap: () => onChanged(v),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                labelOf(v),
                style: AppTextStyles.bodyM(
                  color: isSelected
                      ? Colors.white
                      : colorScheme.onSurfaceVariant,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
          return expanded ? Expanded(child: item) : item;
        }).toList(),
      ),
    );
  }
}
