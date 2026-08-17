import 'package:flutter/material.dart';
import 'package:saderi_silat/theme/app_theme.dart';

/// Chip kecil bulat — untuk label ringkas macam tahap program
/// ('Peringkat Asas') atau penanda masa relatif ('Hari ini', 'Esok').
/// Digunakan dalam ProgramCard dan KelasTerdekatSection supaya kedua-dua
/// tempat ni "bercakap" bahasa visual yang sama.
class InfoPill extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color background;
  final Color foreground;

  const InfoPill({
    super.key,
    required this.label,
    this.icon,
    this.background = AppTheme.lightGreen,
    this.foreground = AppTheme.primaryDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppTheme.radiusChip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: foreground),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}