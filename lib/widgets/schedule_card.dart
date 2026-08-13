import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.lightGreen,
            child: const Icon(Icons.groups, color: AppTheme.primaryDark, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(schedule.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 6),
                _buildInfoRow(Icons.access_time, schedule.time),
                _buildInfoRow(Icons.location_on_outlined, schedule.location),
                _buildInfoRow(Icons.person_outline, schedule.instructor),
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

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppTheme.primaryGreen),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
        ],
      ),
    );
  }
}