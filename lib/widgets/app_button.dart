import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, danger, success, text }

/// Botón reutilizable con las variantes usadas en toda la app:
/// primario (acción principal), secundario (cancelar), peligro
/// (acciones destructivas) y éxito (confirmaciones positivas).
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool loading;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final content = loading
        ? const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    final onTap = loading ? null : onPressed;

    switch (variant) {
      case AppButtonVariant.primary:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: onTap, child: content),
        );
      case AppButtonVariant.secondary:
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton(onPressed: onTap, child: content),
        );
      case AppButtonVariant.danger:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.dangerBg,
              foregroundColor: AppColors.dangerText,
              elevation: 0,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
                side: const BorderSide(color: Color(0xFFFBD5D5)),
              ),
            ),
            onPressed: onTap,
            child: content,
          ),
        );
      case AppButtonVariant.success:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
            ),
            onPressed: onTap,
            child: content,
          ),
        );
      case AppButtonVariant.text:
        return TextButton(
          onPressed: onTap,
          child: Text(label, style: AppTextStyles.button.copyWith(color: AppColors.secondary)),
        );
    }
  }
}
