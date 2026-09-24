class YuranRecord {
  final int studentId;
  final String studentNo;
  final String studentName;
  final String className; // ASSUMPTION: confirm actual JSON key with backend
  final int year;
  final int month;
  final double amountDue;
  final double amountPaid;
  final double balance;
  final String status;
  final DateTime? paidAt;
  final String? receiptNo;

  const YuranRecord({
    required this.studentId,
    required this.studentNo,
    required this.studentName,
    required this.className,
    required this.year,
    required this.month,
    required this.amountDue,
    required this.amountPaid,
    required this.balance,
    required this.status,
    required this.paidAt,
    required this.receiptNo,
  });

  factory YuranRecord.fromJson(Map<String, dynamic> json) {
    double _num(dynamic v) => double.tryParse(v?.toString() ?? '') ?? 0;

    return YuranRecord(
      studentId: json['student_id'] as int,
      studentNo: json['student_no'] as String? ?? '',
      studentName: json['student_name'] as String? ?? '',
      className: json['class_name'] as String? ?? '', // sesuaikan key ni
      year: json['year'] as int,
      month: json['month'] as int,
      amountDue: _num(json['amount_due']),
      amountPaid: _num(json['amount_paid']),
      balance: _num(json['balance']),
      status: json['status'] as String? ?? '',
      paidAt: json['paid_at'] != null
          ? DateTime.tryParse(json['paid_at'] as String)
          : null,
      receiptNo: json['receipt_no'] as String?,
    );
  }

  bool get isPaid => status.toLowerCase() == 'paid';

  static const _bulan = [
    'Januari', 'Februari', 'Mac', 'April', 'Mei', 'Jun',
    'Julai', 'Ogos', 'September', 'Oktober', 'November', 'Disember',
  ];

  String get periodLabel => '${_bulan[month - 1]} $year';
}

class YuranPage {
  final List<YuranRecord> data;
  final int page;
  final int perPage;
  final int total;
  final int lastPage;

  const YuranPage({
    required this.data,
    required this.page,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory YuranPage.fromJson(Map<String, dynamic> json) {
    return YuranPage(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => YuranRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: json['page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 20,
      total: json['total'] as int? ?? 0,
      lastPage: json['last_page'] as int? ?? 1,
    );
  }
}