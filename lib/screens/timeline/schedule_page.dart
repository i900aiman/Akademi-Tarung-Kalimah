import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/schedule_card.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadual Kelas'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date Selector Bar Horizontal
            SizedBox(
              height: 65,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (context, index) {
                  bool isSelected = index == 1; // Contoh: Selasa 20 selected
                  return Container(
                    width: 48,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryGreen : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ['Isn', 'Sel', 'Rab', 'Kha', 'Jum', 'Sab', 'Ahd'][index],
                          style: TextStyle(
                            fontSize: 11,
                            color: isSelected ? Colors.white : AppTheme.textMuted,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${19 + index}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : AppTheme.textDark,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Senarai Jadual
            Expanded(
              child: ListView.builder(
                itemCount: DummyData.scheduleClasses.length,
                itemBuilder: (context, index) {
                  return ScheduleCard(schedule: DummyData.scheduleClasses[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}