import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

/// Tarjeta de elemento de lista (asociado, vehículo, planilla, etc.)
/// con avatar/ícono, título, subtítulo y contenido final (chip, monto).
class ListItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String avatarText;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool alert;

  const ListItemCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.avatarText,
    this.trailing,
    this.onTap,
    this.alert = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(color: alert ? AppColors.danger : AppColors.secondary, width: 4),
          ),
          boxShadow: const [
            BoxShadow(color: Color(0x0A0F1B2D), blurRadius: 3, offset: Offset(0, 1)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.neutralLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                avatarText,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.primary),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyBold, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.caption, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
