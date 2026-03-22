import 'package:flutter/material.dart';

import '../../app/theme/app_text_styles.dart';

/// Standard app bar matching the design system (height 56).
/// Shows an optional back button ("Navigation Button" component).
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;

  const AppBarWidget({
    super.key,
    required this.title,
    this.showBack = false,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    return AppBar(
      backgroundColor: bg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      leading: showBack
          ? Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            )
          : null,
      title: Text(
        title,
        style: AppTextStyles.headlineM(color: colorScheme.onSurface),
      ),
      centerTitle: true,
      actions: actions,
    );
  }
}
