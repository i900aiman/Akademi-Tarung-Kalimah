import 'package:flutter/material.dart';
import 'package:saderi_silat/screens/home/latihan_schedule.dart';
import 'package:saderi_silat/screens/timeline/timeline_schedule.dart';

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
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

  @override
  Widget build(BuildContext context) {
    final item = occurrence.item;
    final dayLabel = formatRelativeDay(occurrence.date, now);
    final timeLabel = formatTime(item.startTime);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF14532D), // hijau gelap, padan dengan tema
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.jenis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  '$dayLabel • $timeLabel',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  item.location,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}