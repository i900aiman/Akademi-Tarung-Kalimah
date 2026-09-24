import 'package:flutter/material.dart';
import 'package:saderi_silat/screens/home/kelas_terdekat.dart';
import 'package:saderi_silat/screens/home/tempahan/tempahan.dart';
import 'package:saderi_silat/screens/program/program_page.dart';
import 'package:saderi_silat/screens/timeline/timeline_schedule.dart';
import '../../data/dummy_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/program_card.dart';
import '../program/program_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Profil & Notification
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 46,
                      width: 46,
                      color: AppTheme.lightGreen,
                      child: Image.asset(
                        "assets/images/atk_saderi_logo.jpeg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat datang',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textMuted,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Akademi Tarung Kalimah',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Banner Promosi
              // NOTA: buang 'margin: horizontal 16' yang asal ada di sini —
              // SingleChildScrollView atas dah bagi padding 16 kat semua
              // child, so margin tambahan tu buat banner jadi lebih
              // sempit (double inset) berbanding section lain kat bawah.
              Container(
                height: 180,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Lapisan 1: Imej Latar Belakang (Memenuhi keseluruhan kad)
                      SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Image.asset(
                          'assets/images/saderi_banner.jpeg',
                          fit: BoxFit
                              .cover, // Ini penting untuk memastikan imej penuh
                        ),
                      ),

                      // Lapisan 2: Overlay warna (Opsional, untuk pastikan teks jelas terbaca)
                      // Memandangkan latar belakang asal imej sudah hijau gelap, ini mungkin tidak perlu.
                      // Jika teks susah dibaca, buang komen kod di bawah:
                      /*
        Container(
          color: AppTheme.primaryDark.withOpacity(0.3), // Tambah sedikit kegelapan
        ),
        */
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Section: Program Pilihan
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Program Pilihan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      color: AppTheme.textDark,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ProgramPage()),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Lihat semua',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 180,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const cardWidth = 245.0;
                    const spacing = 12.0;

                    final totalWidth =
                        (DummyData.programs.length * cardWidth) +
                        ((DummyData.programs.length - 1) * spacing);

                    final horizontalPadding =
                        ((constraints.maxWidth - totalWidth) / 2).clamp(
                          0.0,
                          double.infinity,
                        );

                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      itemCount: DummyData.programs.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: spacing),
                      itemBuilder: (context, index) {
                        final program = DummyData.programs[index];

                        return SizedBox(
                          width: cardWidth,
                          child: ProgramCard(
                            program: program,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProgramDetailPage(program: program),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TempahanPage()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.primaryGreen, AppTheme.primaryDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryGreen.withValues(alpha: 0.28),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.checkroom_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tempah Jersi & Uniform',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Tempahan mudah, terus dari sini',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white24,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Section: Kelas Terdekat
              KelasTerdekatSection(latihanList: latihanList, maxItems: 1),
            ],
          ),
        ),
      ),
    );
  }
}
