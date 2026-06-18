import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  const GradientAppBar({super.key, required this.title, this.actions, this.leading});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      flexibleSpace: Container(decoration: const BoxDecoration(gradient: AppColors.brandGradient)),
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      actions: actions,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }
}
