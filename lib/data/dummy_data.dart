import '../models/program_model.dart';

class DummyData {
  static List<Program> programs = [
    Program(
      id: 'p1',
      title: 'SILAT KALIMAH',
      category: 'Silat Kanak-Kanak & Remaja',
      level: 'Peringkat Asas',
      days: 'Sabtu Malam',
      time: '9:00 - 11:00 malam',
      location: 'Surau AlQuddus',
      instructor: 'Ustat Ameer&Tok Li',
      price: 'RM60',
      ageRange: '7 - 12 tahun',
      imageUrls: [
        'assets/images/silat_kalimah_1.jpeg',
        'assets/images/silat_kalimah_2.jpeg',
      ],
    ),
    Program(
      id: 'p2',
      title: 'SILAT OLAHRAGA',
      category: 'Dewasa',
      level: 'Peringkat Sederhana',
      days: 'Ahad Pagi',
      time: '9:00 - 11:00 malam',
      location: 'Surau AlQuddus',
      instructor: 'Ustat Ameer&Coach Faiz',
      instructorRole: 'Ketua Jurulatih',
      price: 'RM80',
      ageRange: '18 tahun ke atas',
      imageUrls: [
        'assets/images/silat_olahraga_1.jpeg',
        'assets/images/silat_olahraga_2.jpeg',
      ],
    ),
    Program(
      id: 'p3',
      title: 'SILAT SENI KREATIF',
      category: 'Remaja',
      level: 'Peringkat Sederhana',
      days: 'Sabtu Malam',
      time: '9:00 - 11:00 malam',
      location: 'Surau AlQuddus',
      instructor: 'Ustat Ameer&Coach Joe',
      price: 'RM70',
      ageRange: '13 - 17 tahun',
      imageUrls: [
        'assets/images/silat_seni_1.jpeg',
        'assets/images/silat_seni_2.jpeg',
        'assets/images/silat_seni_3.jpeg',
      ],
    ),
  ];

  static List<ScheduleClass> scheduleClasses = [
    ScheduleClass(
      id: 's1',
      title: 'SILAT KALIMAH',
      time: '9:00 - 11:00 malam',
      location: 'Surau AlQuddus',
      instructor: 'Ustat Ameer&Tok Li',
      // status: 'Tersedia',
    ),
    ScheduleClass(
      id: 's2',
      title: 'SILAT OLAHRAGA',
      time: '9:00 - 11:00 malam',
      location: 'Surau AlQuddus',
      instructor: 'Ustat Ameer&Coach Faiz',
      // status: 'Hampir Penuh',
    ),
    ScheduleClass(
      id: 's3',
      title: 'SILAT SENI KREATIF',
      time: '9:00 - 11:00 malam',
      location: 'Surau AlQuddus',
      instructor: 'Ustat Ameer&Coach Joe',
      // status: 'Tersedia',
    ),
  ];
}
