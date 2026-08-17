import 'package:flutter/material.dart';
import 'package:saderi_silat/screens/home/info/info_row.dart';
import '../models/program_model.dart';
import '../theme/app_theme.dart';

class ScheduleCard extends StatelessWidget {
  final ScheduleClass schedule;

  const ScheduleCard({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    // bool isAlmostFull = schedule.status == 'Hampir Penuh';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppTheme.lightGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.groups, color: AppTheme.primaryDark, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                InfoRow(icon: Icons.access_time, text: schedule.time),
                InfoRow(icon: Icons.location_on_outlined, text: schedule.location),
                InfoRow(
                  icon: Icons.person_outline,
                  text: schedule.instructor,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          //   decoration: BoxDecoration(
          //     color: isAlmostFull ? const Color(0xFFFFF3E0) : AppTheme.lightGreen,
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: Text(
          //     schedule.status,
          //     style: TextStyle(
          //       fontSize: 11,
          //       fontWeight: FontWeight.w600,
          //       color: isAlmostFull ? Colors.orange.shade800 : AppTheme.primaryDark,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}