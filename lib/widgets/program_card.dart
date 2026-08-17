import 'package:flutter/material.dart';
import 'package:saderi_silat/screens/home/info/info_pill.dart';
import 'package:saderi_silat/screens/home/info/info_row.dart';
import '../models/program_model.dart';
import '../theme/app_theme.dart';

class ProgramCard extends StatelessWidget {
  final Program program;
  final VoidCallback onTap;
  final bool isGrid;

  const ProgramCard({
    super.key,
    required this.program,
    required this.onTap,
    this.isGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isGrid ? double.infinity : 180,
        clipBehavior: Clip.antiAlias,
        decoration: AppTheme.cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imej + label peringkat terapung di atas imej (gantikan baris
            // teks berasingan — kurangkan bilangan baris, senang diimbas)
            Stack(
              children: [
                Image.asset(
                  program.imageUrls.first,
                  height: 110,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // gradient nipis kat bawah imej supaya pill senang dibaca
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0),
                          Colors.black.withOpacity(0.22),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 8,
                  child: InfoPill(
                    label: program.level,
                    icon: Icons.signal_cellular_alt,
                    background: Colors.white.withOpacity(0.92),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    program.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppTheme.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isGrid) ...[
                    const SizedBox(height: 8),
                    // NOTA: asal fail ni ikon 'access_time' dipasang dengan
                    // program.days & ikon 'location_on_outlined' dengan
                    // program.time — tertukar. Dah betulkan kat bawah.
                    InfoRow(icon: Icons.calendar_today_outlined, text: program.days),
                    InfoRow(
                      icon: Icons.access_time,
                      text: program.time,
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}