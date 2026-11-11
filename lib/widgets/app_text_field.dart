import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

/// Campo de texto estándar de formularios, con soporte para
/// solo lectura, iconos finales (fecha, selector) y validación.
class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? hint;
  final bool obscureText;
  final bool readOnly;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final int maxLines;
  final String? helperText;
  final bool helperIsError;

  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.obscureText = false,
    this.readOnly = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.onTap,
    this.maxLines = 1,
    this.helperText,
    this.helperIsError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.label),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            readOnly: readOnly,
            keyboardType: keyboardType,
            maxLines: obscureText ? 1 : maxLines,
            validator: validator,
            onTap: onTap,
            style: AppTextStyles.body.copyWith(fontSize: 13.5),
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: readOnly ? AppColors.neutralLight : AppColors.surface,
            ),
          ),
          if (helperText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 2),
              child: Text(
                helperText!,
                style: AppTextStyles.small.copyWith(
                  color: helperIsError ? AppColors.danger : AppColors.neutral,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
