import 'dart:ui';
import 'package:flutter/material.dart';

class AppAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget? title;
  final List<Widget>? actions;
  final double? elevation;
  final Color? backgroundColor;
  final double blur;
  final PreferredSizeWidget? bottom;

  const AppAppBarWidget({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.elevation,
    this.backgroundColor,
    this.blur = 0,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor =
        backgroundColor ?? theme.colorScheme.background.withOpacity(0);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: AppBar(
          leading: leading,
          automaticallyImplyLeading: automaticallyImplyLeading,
          title: title,
          actions: actions,
          elevation: elevation ?? 0,
          backgroundColor: effectiveBackgroundColor,
          bottom: bottom,
          scrolledUnderElevation: 0.0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
