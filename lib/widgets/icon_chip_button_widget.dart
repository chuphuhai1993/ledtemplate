import 'package:flutter/material.dart';

class IconChipButtonWidget extends StatelessWidget {
  final bool isActive;
  final VoidCallback onPressed;
  final IconData icon;

  const IconChipButtonWidget({
    super.key,
    required this.isActive,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final Color backgroundColor =
        isActive ? Colors.transparent : colorScheme.onSurface.withOpacity(0.1);

    final Color iconColor =
        isActive
            ? colorScheme.onSurface
            : colorScheme.onSurface.withOpacity(0.5);

    final Border? border =
        isActive ? Border.all(color: colorScheme.onSurface, width: 1) : null;

    return SizedBox(
      width: 40,
      height: 40,
      child: Material(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
          side: border?.top ?? BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Center(child: Icon(icon, color: iconColor, size: 20)),
        ),
      ),
    );
  }
}
