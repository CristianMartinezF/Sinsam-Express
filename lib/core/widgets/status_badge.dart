import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum BadgeType { success, danger, warning, info }

class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeType type;

  const StatusBadge({super.key, required this.label, required this.type});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (type) {
      case BadgeType.success:
        bg = AppColors.successBg;
        fg = AppColors.successText;
        break;
      case BadgeType.danger:
        bg = AppColors.dangerBg;
        fg = AppColors.dangerText;
        break;
      case BadgeType.warning:
        bg = AppColors.warningBg;
        fg = AppColors.warningText;
        break;
      case BadgeType.info:
        bg = AppColors.infoBg;
        fg = AppColors.infoText;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '• $label',
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
