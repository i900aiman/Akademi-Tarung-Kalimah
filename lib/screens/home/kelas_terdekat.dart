import 'package:flutter/material.dart';
import 'package:saderi_silat/screens/home/info/info_pill.dart';
import 'package:saderi_silat/screens/home/info/info_row.dart';
import 'package:saderi_silat/screens/home/latihan_schedule.dart';
import 'package:saderi_silat/screens/timeline/timeline_schedule.dart';
import '../../theme/app_theme.dart';

/// Letak widget ni kat page Utama, bawah section "Program Pilihan".
/// Contoh guna:
///
/// ```dart
/// KelasTerdekatSection(latihanList: latihanList, maxItems: 2),
/// ```
class KelasTerdekatSection extends StatelessWidget {
  final List<LatihanItem> latihanList;
  final int maxItems;

  const KelasTerdekatSection({
    super.key,
    required this.latihanList,
    this.maxItems = 2,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Satu latihan sahaja setiap minggu, ikut susunan asal dalam latihanList
    // (kitar semula bila sampai hujung list).
    final upcoming = upcomingOccurrences(latihanList, now, count: maxItems);

    if (upcoming.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kelas Terdekat',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 12),
        for (final occ in upcoming) _KelasTerdekatCard(occurrence: occ, now: now),
      ],
    );
  }
}

class _KelasTerdekatCard extends StatelessWidget {
  final LatihanOccurrence occurrence;
  final DateTime now;

  const _KelasTerdekatCard({required this.occurrence, required this.now});

  static const _dayAbbrev = ['ISN', 'SEL', 'RAB', 'KHA', 'JUM', 'SAB', 'AHD'];

  @override
  Widget build(BuildContext context) {
    final item = occurrence.item;
    final date = occurrence.date;
    final dayLabel = formatRelativeDay(date, now);
    final timeLabel = formatTime(item.startTime);
    final isSoon = dayLabel == 'Hari ini' || dayLabel == 'Esok';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Blok tarikh (nombor hari + singkatan hari) gantikan ikon
          // generik lama — lagi berguna sebab ni memang widget "jadual".
          Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppTheme.primaryDark,
              borderRadius: BorderRadius.circular(AppTheme.radiusBadge),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${date.day}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _dayAbbrev[date.weekday - 1],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.jenis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppTheme.textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isSoon) ...[
                      const SizedBox(width: 6),
                      InfoPill(label: dayLabel),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                InfoRow(icon: Icons.access_time, text: timeLabel),
                InfoRow(
                  icon: Icons.location_on_outlined,
                  text: item.location,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}