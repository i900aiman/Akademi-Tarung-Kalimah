import 'package:flutter/material.dart';
import 'package:saderi_silat/screens/timeline/timeline_schedule.dart';

/// Extension untuk parse waktu mula dari field `time` pada LatihanItem.
/// Contoh: "9.00 - 11.00 pagi" -> 09:00, "9.00 - 11.00 malam" -> 21:00
extension LatihanScheduling on LatihanItem {
  TimeOfDay get startTime {
    final startPart = time.split('-').first.trim(); // "9.00"
    final hm = startPart.split('.');
    int hour = int.parse(hm[0].trim());
    int minute = hm.length > 1 ? int.parse(hm[1].trim()) : 0;

    final lower = time.toLowerCase();
    final isMalamOrPetang = lower.contains('malam') || lower.contains('petang');
    if (isMalamOrPetang && hour < 12) hour += 12;

    return TimeOfDay(hour: hour, minute: minute);
  }
}

/// Pasangan LatihanItem dengan tarikh sebenar yang telah diagih untuknya.
class LatihanOccurrence {
  final LatihanItem item;
  final DateTime date;
  const LatihanOccurrence(this.item, this.date);
}

/// Tarikh bila Latihan Pertama (list[0]) mula-mula berlangsung.
/// SEMUA kelas dianggap berlaku pada hari Sabtu, satu setiap minggu, kitar
/// ikut senarai secara berterusan (list[0] -> list[1] -> ... -> ulang
/// semula). Ni jadi rujukan TETAP supaya jadual konsisten walau bila pun
/// app dibuka — bukan dikira semula dari list[0] setiap kali.
///
/// PENTING: tukar tarikh ni ikut bila program sebenar korang bermula.
final DateTime kJadualCycleAnchor = DateTime(2026, 8, 1); // Sabtu, 1 Ogos 2026

DateTime _saturdayOnOrAfter(DateTime d) {
  final date = DateTime(d.year, d.month, d.day);
  final diff = (DateTime.saturday - date.weekday) % 7;
  return date.add(Duration(days: diff));
}

/// Senarai kelas akan datang, mula dari yang PALING DEKAT dengan [now] —
/// tak kira posisi kelas tu dalam kitaran senarai. Dikira terus dari
/// [kJadualCycleAnchor] (atau [anchor] jika dibekalkan), jadi Latihan Ketiga
/// boleh je keluar sebagai kelas pertama dipaparkan kalau memang itu yang
/// paling dekat dengan hari ini.
List<LatihanOccurrence> upcomingOccurrences(
  List<LatihanItem> list,
  DateTime now, {
  int count = 5,
  DateTime? anchor,
}) {
  if (list.isEmpty) return [];
  final n = list.length;
  final anchorSaturday = _saturdayOnOrAfter(anchor ?? kJadualCycleAnchor);

  final result = <LatihanOccurrence>[];
  var saturday = _saturdayOnOrAfter(now);

  while (result.length < count) {
    final weeks = saturday.difference(anchorSaturday).inDays ~/ 7;
    final index = ((weeks % n) + n) % n; // modulo selamat untuk nilai negatif
    final item = list[index];
    final t = item.startTime;
    final date = DateTime(
      saturday.year,
      saturday.month,
      saturday.day,
      t.hour,
      t.minute,
    );

    // kalau Sabtu ni memang hari ni tapi waktu kelas dah lepas, skip ke Sabtu depan
    if (!date.isBefore(now)) {
      result.add(LatihanOccurrence(item, date));
    }
    saturday = saturday.add(const Duration(days: 7));
  }

  return result;
}

/// Format tarikh jadi "Hari ini", "Esok", atau "Sabtu, 15 Ogos"
String formatRelativeDay(DateTime target, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  final targetDate = DateTime(target.year, target.month, target.day);
  final diff = targetDate.difference(today).inDays;

  if (diff == 0) return 'Hari ini';
  if (diff == 1) return 'Esok';

  const dayNames = ['Isnin', 'Selasa', 'Rabu', 'Khamis', 'Jumaat', 'Sabtu', 'Ahad'];
  const monthNames = [
    'Januari', 'Februari', 'Mac', 'April', 'Mei', 'Jun',
    'Julai', 'Ogos', 'September', 'Oktober', 'November', 'Disember',
  ];
  return '${dayNames[target.weekday - 1]}, ${target.day} ${monthNames[target.month - 1]}';
}

/// Format TimeOfDay jadi "9:00 pagi" / "9:00 malam"
String formatTime(TimeOfDay t) {
  final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
  final minute = t.minute.toString().padLeft(2, '0');
  final period = t.period == DayPeriod.am ? 'pagi' : 'malam';
  return '$hour:$minute $period';
}