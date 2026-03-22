import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/tool_registry/tool_definition.dart';

class ToolCard extends StatelessWidget {
  final ToolDefinition tool;

  const ToolCard({super.key, required this.tool});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final card = GestureDetector(
      onTap: tool.isAvailable ? () => context.push(tool.route) : null,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            // Icon container
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.primaryContainerDark
                    : AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                tool.icon,
                size: 28,
                color: isDark ? AppColors.primaryDark : AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            // Texts
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tool.name,
                    style: AppTextStyles.bodyL(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tool.subtitle,
                    style: AppTextStyles.bodySm(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            // Trailing: chevron or badge
            if (tool.isAvailable)
              Icon(
                Icons.chevron_right,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Скоро',
                  style: AppTextStyles.caption(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );

    if (!tool.isAvailable) {
      return Opacity(opacity: AppColors.opacityDisabled, child: card);
    }
    return card;
  }
}
