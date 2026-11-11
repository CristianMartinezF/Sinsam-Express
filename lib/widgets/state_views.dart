import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import 'app_button.dart';

/// Estado "Cargando": indicador + esqueleto de tarjetas.
class LoadingStateView extends StatelessWidget {
  final String message;
  const LoadingStateView({super.key, this.message = 'Cargando información…'});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const CircularProgressIndicator(strokeWidth: 3, color: AppColors.secondary),
          const SizedBox(height: 14),
          Text(message, style: AppTextStyles.caption),
          const SizedBox(height: 24),
          ...List.generate(
            3,
            (_) => Container(
              height: 58,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.neutralLight,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Estado "Sin resultados": mensaje claro + acción para registrar o limpiar filtros.
class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateView({
    super.key,
    this.icon = Icons.search_off_rounded,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 44, horizontal: 20),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(color: AppColors.neutralLight, shape: BoxShape.circle),
            child: Icon(icon, color: AppColors.neutral, size: 24),
          ),
          const SizedBox(height: 14),
          Text(title, style: AppTextStyles.h3, textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(message, style: AppTextStyles.caption, textAlign: TextAlign.center),
          if (actionLabel != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: 200,
              child: AppButton(
                label: actionLabel!,
                variant: AppButtonVariant.secondary,
                onPressed: onAction,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Estado "Error": mensaje comprensible (no técnico) + reintentar.
class ErrorStateView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorStateView({
    super.key,
    this.message = 'No fue posible conectar con el servidor. Verifica tu conexión e inténtalo nuevamente.',
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 44, horizontal: 20),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(color: AppColors.dangerBg, shape: BoxShape.circle),
            child: const Icon(Icons.wifi_off_rounded, color: AppColors.danger, size: 24),
          ),
          const SizedBox(height: 14),
          const Text('No pudimos cargar la información', style: AppTextStyles.h3, textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(message, style: AppTextStyles.caption, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          SizedBox(
            width: 160,
            child: AppButton(label: 'Reintentar', variant: AppButtonVariant.secondary, onPressed: onRetry),
          ),
        ],
      ),
    );
  }
}

/// Banner de alerta en línea (ej. conductor sancionado).
class InlineAlertBanner extends StatelessWidget {
  final String title;
  final String message;
  final bool warning;

  const InlineAlertBanner({
    super.key,
    required this.title,
    required this.message,
    this.warning = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = warning ? AppColors.warningBg : AppColors.dangerBg;
    final fg = warning ? AppColors.warningText : AppColors.dangerText;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: fg.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline_rounded, color: fg, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.8, color: fg)),
                const SizedBox(height: 2),
                Text(message, style: TextStyle(fontSize: 12.2, color: fg, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
