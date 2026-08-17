import 'package:flutter/material.dart';
import 'package:saderi_silat/theme/app_theme.dart';

/// Baris ikon + teks kecil — untuk info sokongan macam waktu, lokasi,
/// jurulatih. Digunakan konsisten merentasi ProgramCard, ScheduleCard, dan
/// KelasTerdekatSection supaya rentak visual sama di seluruh app.
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final EdgeInsetsGeometry padding;

  const InfoRow({
    super.key,
    required this.icon,
    required this.text,
    this.padding = const EdgeInsets.only(bottom: 4),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Icon(icon, size: 13, color: AppTheme.primaryGreen),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}