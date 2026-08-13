import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

// ---------------------------------------------------------------------------
// Data model
// ---------------------------------------------------------------------------
class LatihanItem {
  final String title; // LATIHAN PERTAMA, KEDUA, dst
  final String day; // AHAD PAGI / SABTU MALAM
  final String location;
  final String time;
  final String jenis; // Silat Olahraga / Seni / Kalimah
  final String jurulatih;
  final IconData icon;

  const LatihanItem({
    required this.title,
    required this.day,
    required this.location,
    required this.time,
    required this.jenis,
    required this.jurulatih,
    required this.icon,
  });
}

const List<LatihanItem> latihanList = [
  LatihanItem(
    title: 'LATIHAN PERTAMA',
    day: 'SABTU MALAM',
    location: 'Surau AlQuddus',
    time: '9.00 - 11.00 malam',
    jenis: 'Silat Olahraga',
    jurulatih: 'Ust Ameer & Coach Faiz',
    icon: Icons.calendar_month,
  ),
  LatihanItem(
    title: 'LATIHAN KEDUA',
    day: 'SABTU MALAM',
    location: 'Surau AlQuddus',
    time: '9.00 - 11.00 malam',
    jenis: 'Silat Seni Kreatif',
    jurulatih: 'Ust Ameer & Coach Joe',
    icon: Icons.nightlight_round,
  ),
  LatihanItem(
    title: 'LATIHAN KETIGA',
    day: 'SABTU MALAM',
    location: 'Surau AlQuddus',
    time: '9.00 - 11.00 malam',
    jenis: 'Silat Kalimah',
    jurulatih: 'Ust Ameer & Tok Li',
    icon: Icons.menu_book,
  ),
  LatihanItem(
    title: 'LATIHAN KEEMPAT',
    day: 'SABTU MALAM',
    location: 'Surau AlQuddus',
    time: '9.00 - 11.00 malam',
    jenis: 'Silat Seni Kreatif',
    jurulatih: 'Ust Ameer & Coach Joe',
    icon: Icons.nightlight_round,
  ),
  LatihanItem(
    title: 'LATIHAN KELIMA',
    day: 'SABTU MALAM',
    location: 'Surau AlQuddus',
    time: '9.00 - 11.00 malam',
    jenis: 'Silat Olahraga',
    jurulatih: 'Ust Ameer & Coach Faiz',
    icon: Icons.calendar_month,
  ),
];

// ---------------------------------------------------------------------------
// Colours (based on the screenshot's green/cream palette)
// ---------------------------------------------------------------------------
const Color kDarkGreen = Color(0xFF35472E);
const Color kMidGreen = Color(0xFF4C6B3F);
const Color kCream = Color(0xFFF4EFE1);
const Color kTitleGreen = Color(0xFF5B7A44);

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------
class LatihanTimelineScreen extends StatelessWidget {
  const LatihanTimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kDarkGreen,
        title: const Text('Jadual Latihan',style: TextStyle(color: Colors.white),),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: latihanList.length,
        itemBuilder: (context, index) {
          final item = latihanList[index];
          final isFirst = index == 0;
          final isLast = index == latihanList.length - 1;

          return TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.16,
            isFirst: isFirst,
            isLast: isLast,
            beforeLineStyle: const LineStyle(color: kMidGreen, thickness: 4),
            afterLineStyle: const LineStyle(color: kMidGreen, thickness: 4),
            indicatorStyle: IndicatorStyle(
              width: 46,
              height: 46,
              indicator: _TimelineDot(icon: item.icon),
            ),
            endChild: Padding(
              padding: const EdgeInsets.only(
                left: 12,
                right: 16,
                top: 6,
                bottom: 6,
              ),
              child: _LatihanCard(item: item),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Circle indicator (calendar / moon / book icon)
// ---------------------------------------------------------------------------
class _TimelineDot extends StatelessWidget {
  final IconData icon;
  const _TimelineDot({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: kDarkGreen,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}

// ---------------------------------------------------------------------------
// Card
// ---------------------------------------------------------------------------
class _LatihanCard extends StatelessWidget {
  final LatihanItem item;
  const _LatihanCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: kCream,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: const TextStyle(
                color: kTitleGreen,
                fontWeight: FontWeight.w800,
                fontSize: 14,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.day,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w800,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 8),
            _InfoRow(icon: Icons.location_on, text: item.location),
            const SizedBox(height: 4),
            _InfoRow(icon: Icons.access_time, text: item.time),
            const SizedBox(height: 4),
            _InfoRow(icon: Icons.sports_martial_arts, text: item.jenis),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: kDarkGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.groups, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    item.jurulatih,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: kMidGreen),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}