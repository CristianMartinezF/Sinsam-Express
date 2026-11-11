import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

/// Etiqueta de sección en mayúsculas pequeñas (ej. "INFORMACIÓN PERSONAL").
class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 8),
      child: Text(text.toUpperCase(), style: AppTextStyles.sectionLabel),
    );
  }
}

/// Bloque con borde que agrupa varias [DetailRow].
class DetailBlock extends StatelessWidget {
  final List<Widget> rows;
  const DetailBlock({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: rows),
    );
  }
}

/// Fila "etiqueta : valor" usada en pantallas de detalle.
class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool readOnly;

  const DetailRow({super.key, required this.label, required this.value, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 0.8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: AppTextStyles.caption)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: readOnly
                  ? AppTextStyles.body.copyWith(fontStyle: FontStyle.italic, color: AppColors.neutral)
                  : AppTextStyles.bodyBold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Barra superior estándar con botón de regreso opcional y acción final.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final Widget? action;

  const AppTopBar({super.key, required this.title, this.showBack = true, this.action});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: showBack && Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      actions: action != null ? [action!, const SizedBox(width: 6)] : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

/// Avatar circular/cuadrado con iniciales, usado en encabezados de detalle.
class InitialsAvatar extends StatelessWidget {
  final String text;
  final double size;
  const InitialsAvatar({super.key, required this.text, this.size = 52});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: AppColors.neutralLight, borderRadius: BorderRadius.circular(14)),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: size * 0.3, color: AppColors.primary),
      ),
    );
  }
}

/// Botón de acción flotante estándar (p. ej. "Registrar").
class AppFab extends StatelessWidget {
  final VoidCallback onPressed;
  const AppFab({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.secondary,
      onPressed: onPressed,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
