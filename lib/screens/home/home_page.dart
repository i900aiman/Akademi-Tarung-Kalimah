import 'package:flutter/material.dart';
import 'package:saderi_silat/screens/home/kelas_terdekat.dart';
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

                      // Lapisan 3: Kandungan Teks dan Butang
                      Padding(
                        padding: const EdgeInsets.all(
                          24.0,
                        ), // Padding yang lebih besar sedikit seperti di design asal
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Pusatkan kandungan secara menegak
                          children: [
                            //  Container(

                            //   decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20),),
                            //    child: Padding(
                            //      padding: const EdgeInsets.all(8.0),
                            //      child: Text(
                            //       'Bina Disiplin,\nKuatkan\nJati Diri',
                            //       style: TextStyle(
                            //         color: Colors.black,
                            //         fontSize: 15, // Besarkan sedikit saiz fon
                            //         fontWeight: FontWeight.bold,
                            //         height: 1.2,
                            //       ),
                            //                    ),
                            //    ),
                            //  ),
                            const SizedBox(height: 16), // Jarak yang lebih baik
                            // ElevatedButton(
                            //   onPressed: () {

                            //   },
                            //   style: ElevatedButton.styleFrom(
                            //     backgroundColor: AppTheme.primaryGreen,
                            //     foregroundColor: Colors.white,
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(20),
                            //     ),
                            //     padding: const EdgeInsets.symmetric(
                            //       horizontal: 20,
                            //       vertical: 10,
                            //     ),
                            //     elevation:
                            //         2, // Tambah sedikit bayang pada butang
                            //   ),
                            //   child: const Row(
                            //     mainAxisSize: MainAxisSize.min,
                            //     children: [
                            //       Text(
                            //         'Daftar Sekarang',
                            //         style: TextStyle(
                            //           fontSize: 13,
                            //           fontWeight: FontWeight.w600,
                            //         ),
                            //       ),
                            //       SizedBox(width: 6),
                            //       Icon(Icons.arrow_forward, size: 16),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
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
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: DummyData.programs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final program = DummyData.programs[index];
                    return ProgramCard(
                      program: program,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProgramDetailPage(program: program),
                          ),
                        );
                      },
                    );
                  },
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