import 'package:flutter/material.dart';
import '../../models/program_model.dart';
import '../../theme/app_theme.dart';

class ProgramDetailPage extends StatefulWidget {
  final Program program;

  const ProgramDetailPage({super.key, required this.program});

  @override
  State<ProgramDetailPage> createState() => _ProgramDetailPageState();
}

class _ProgramDetailPageState extends State<ProgramDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image Header with Back Button
            Stack(
              children: [
                SizedBox(
                  height: 250,
                  child: PageView.builder(
                    itemCount: widget.program.imageUrls.length,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        widget.program.imageUrls[index],
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.program.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Chips
                  Row(
                    children: [
                      _buildChip(widget.program.ageRange),
                      const SizedBox(width: 8),
                      _buildChip('Semua Tahap'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Kelas untuk dewasa yang ingin memperkukuh kecergasan, disiplin diri dan kemahiran silat melalui latihan yang terancang dan selamat.',
                    style: TextStyle(color: AppTheme.textMuted, height: 1.4),
                  ),
                  const SizedBox(height: 16),

                  // Info Cards Container
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(Icons.calendar_month, widget.program.days),
                        const Divider(),
                        _buildDetailRow(Icons.access_time, widget.program.time),
                        const Divider(),
                        _buildDetailRow(
                          Icons.location_on_outlined,
                          widget.program.location,
                        ),
                        const Divider(),
                        _buildDetailRow(
                          Icons.person_outline,
                          '${widget.program.instructor}\n${widget.program.instructorRole}',
                        ),
                      ],
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

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.lightGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, color: AppTheme.primaryDark),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.textMuted),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
