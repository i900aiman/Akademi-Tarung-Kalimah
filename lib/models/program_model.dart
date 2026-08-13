class Program {
  final String id;
  final String title;
  final String category; // Kanak-Kanak, Remaja, Dewasa
  final String level;    // Peringkat Asas, Pertengahan, dll.
  final String days;     // Contoh: Selasa & Khamis
  final String time;     // Contoh: 7:30 - 8:30 malam
  final String location; // Contoh: Dewan Utama
  final String instructor;
  final String instructorRole;
  final String price;
  final List<String> imageUrls;
  final String ageRange;

  Program({
    required this.id,
    required this.title,
    required this.category,
    required this.level,
    required this.days,
    required this.time,
    required this.location,
    required this.instructor,
    this.instructorRole = 'Jurulatih',
    required this.price,
    required this.imageUrls,
    this.ageRange = '',
  });
}

class ScheduleClass {
  final String id;
  final String title;
  final String time;
  final String location;
  final String instructor;

  ScheduleClass({
    required this.id,
    required this.title,
    required this.time,
    required this.location,
    required this.instructor,
  });
}