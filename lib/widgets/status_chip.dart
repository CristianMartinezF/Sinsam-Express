import 'package:flutter/material.dart';
import '../config/app_colors.dart';

enum ChipType { active, inactive, warn, danger, info }

/// Chip de estado (Activo, Inactivo, Vigente, Pendiente, etc.) usado
/// de forma consistente en listados y detalles.
class StatusChip extends StatelessWidget {
  final String label;
  final ChipType type;

  const StatusChip({super.key, required this.label, required this.type});

  Color get _bg {
    switch (type) {
      case ChipType.active:
        return AppColors.successBg;
      case ChipType.inactive:
        return AppColors.neutralLight;
      case ChipType.warn:
        return AppColors.warningBg;
      case ChipType.danger:
        return AppColors.dangerBg;
      case ChipType.info:
        return AppColors.infoBg;
    }
  }

  Color get _fg {
    switch (type) {
      case ChipType.active:
        return AppColors.successText;
      case ChipType.inactive:
        return AppColors.neutral;
      case ChipType.warn:
        return AppColors.warningText;
      case ChipType.danger:
        return AppColors.dangerText;
      case ChipType.info:
        return AppColors.infoText;
    }
  }

  Color get _dot {
    switch (type) {
      case ChipType.active:
        return AppColors.success;
      case ChipType.inactive:
        return AppColors.neutral;
      case ChipType.warn:
        return AppColors.warning;
      case ChipType.danger:
        return AppColors.danger;
      case ChipType.info:
        return AppColors.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: _dot, shape: BoxShape.circle)),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: _fg),
          ),
        ],
      ),
    );
  }
}
