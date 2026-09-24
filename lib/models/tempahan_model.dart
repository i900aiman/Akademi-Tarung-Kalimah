

import 'dart:io';

/// Model untuk 1 gambar produk kempen
class CampaignPhoto {
  final int id;
  final String imageUrl;

  CampaignPhoto({required this.id, required this.imageUrl});

  factory CampaignPhoto.fromJson(Map<String, dynamic> json) {
    return CampaignPhoto(
      id: json['id'] as int,
      imageUrl: json['image_url'] as String,
    );
  }
}

/// Model untuk 1 kempen (jersi ATAU uniform) dari
/// GET /api/v1/order-campaigns/open
///
/// Field `jersey_types`, `sleeve_options`, `muslimah_price`,
/// `long_sleeve_surcharge` hanya relevan bila [type] == 'jersey'.
class OrderCampaign {
  final int id;
  final String title;
  final String type; // 'jersey' atau 'uniform'
  final String? description;
  final String? opensAt;
  final String? closesAt;
  final List<CampaignPhoto> photos;
  final List<String> sizes;
  final List<String> branches;
  final List<String> jerseyTypes;
  final List<String> sleeveOptions;
  final double? basePrice;
  final double? muslimahPrice;
  final double? longSleeveSurcharge;

  OrderCampaign({
    required this.id,
    required this.title,
    required this.type,
    this.description,
    this.opensAt,
    this.closesAt,
    this.photos = const [],
    this.sizes = const [],
    this.branches = const [],
    this.jerseyTypes = const [],
    this.sleeveOptions = const [],
    this.basePrice,
    this.muslimahPrice,
    this.longSleeveSurcharge,
  });

  bool get isJersey => type == 'jersey';
  bool get isUniform => type == 'uniform';

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  factory OrderCampaign.fromJson(Map<String, dynamic> json) {
    return OrderCampaign(
      id: json['id'] as int,
      title: json['title'] as String,
      type: json['type'] as String,
      description: json['description'] as String?,
      opensAt: json['opens_at'] as String?,
      closesAt: json['closes_at'] as String?,
      photos: (json['photos'] as List<dynamic>? ?? [])
          .map((e) => CampaignPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
      sizes: (json['sizes'] as List<dynamic>? ?? []).cast<String>(),
      branches: (json['branches'] as List<dynamic>? ?? []).cast<String>(),
      jerseyTypes:
          (json['jersey_types'] as List<dynamic>? ?? []).cast<String>(),
      sleeveOptions:
          (json['sleeve_options'] as List<dynamic>? ?? []).cast<String>(),
      basePrice: _toDouble(json['base_price']),
      muslimahPrice: _toDouble(json['muslimah_price']),
      longSleeveSurcharge: _toDouble(json['long_sleeve_surcharge']),
    );
  }
}

/// Model untuk Tempahan Jersi
/// Ikut field JSON: campaign_id, full_name, jersey_name, phone, branch,
/// jersey_type, size, sleeve_option, quantity, remarks, payment_status, receipt
class JerseyTempahan {
  final int campaignId;
  final String fullName;
  final String? jerseyName;
  final String? phone;
  final String branch; // Putrajaya, Nilai, Lain-lain
  final String jerseyType; // muslimah, round_neck, v_neck
  final String size; // 2XS - 5XL
  final String sleeveOption; // short / long, default short
  final int quantity;
  final String? remarks;
  final String paymentStatus; // unpaid, deposit, paid
  final File? receipt; // wajib jika deposit / paid

  JerseyTempahan({
    required this.campaignId,
    required this.fullName,
    this.jerseyName,
    this.phone,
    required this.branch,
    required this.jerseyType,
    required this.size,
    this.sleeveOption = 'short',
    this.quantity = 1,
    this.remarks,
    required this.paymentStatus,
    this.receipt,
  });

  /// Untuk request biasa (tanpa file) - contoh nak simpan draf lokal dsb.
  Map<String, dynamic> toJson() {
    return {
      'campaign_id': campaignId,
      'full_name': fullName,
      'jersey_name': jerseyName,
      'phone': phone,
      'branch': branch,
      'jersey_type': jerseyType,
      'size': size,
      'sleeve_option': sleeveOption,
      'quantity': quantity,
      'remarks': remarks,
      'payment_status': paymentStatus,
    };
  }

  /// Untuk multipart request (fields sahaja, file dihantar berasingan)
  Map<String, String> toFormFields() {
    final map = <String, String>{
      'campaign_id': campaignId.toString(),
      'full_name': fullName,
      'branch': branch,
      'jersey_type': jerseyType,
      'size': size,
      'sleeve_option': sleeveOption,
      'quantity': quantity.toString(),
      'payment_status': paymentStatus,
    };
    if (jerseyName != null && jerseyName!.isNotEmpty) {
      map['jersey_name'] = jerseyName!;
    }
    if (phone != null && phone!.isNotEmpty) {
      map['phone'] = phone!;
    }
    if (remarks != null && remarks!.isNotEmpty) {
      map['remarks'] = remarks!;
    }
    return map;
  }

  factory JerseyTempahan.fromJson(Map<String, dynamic> json) {
    return JerseyTempahan(
      campaignId: json['campaign_id'] as int,
      fullName: json['full_name'] as String,
      jerseyName: json['jersey_name'] as String?,
      phone: json['phone'] as String?,
      branch: json['branch'] as String,
      jerseyType: json['jersey_type'] as String,
      size: json['size'] as String,
      sleeveOption: json['sleeve_option'] as String? ?? 'short',
      quantity: json['quantity'] as int? ?? 1,
      remarks: json['remarks'] as String?,
      paymentStatus: json['payment_status'] as String,
    );
  }
}



/// Model untuk Tempahan Uniform
/// Ikut field JSON: campaign_id, full_name, phone, branch, size,
/// trouser_length, age, quantity, remarks, payment_status, receipt
class UniformTempahan {
  final int campaignId;
  final String fullName;
  final String? phone;
  final String branch; // Putrajaya, Nilai, Lain-lain
  final String size; // 2XS - 5XL, atau "Tak Pasti"
  final double? trouserLength; // wajib jika size == "Tak Pasti"
  final int? age; // wajib jika size == "Tak Pasti"
  final int quantity;
  final String? remarks;
  final String paymentStatus; // unpaid, deposit, paid
  final File? receipt; // wajib jika deposit / paid

  UniformTempahan({
    required this.campaignId,
    required this.fullName,
    this.phone,
    required this.branch,
    required this.size,
    this.trouserLength,
    this.age,
    this.quantity = 1,
    this.remarks,
    required this.paymentStatus,
    this.receipt,
  });

  bool get isSizeTakPasti => size == 'Tak Pasti';

  Map<String, dynamic> toJson() {
    return {
      'campaign_id': campaignId,
      'full_name': fullName,
      'phone': phone,
      'branch': branch,
      'size': size,
      'trouser_length': trouserLength,
      'age': age,
      'quantity': quantity,
      'remarks': remarks,
      'payment_status': paymentStatus,
    };
  }

  /// Untuk multipart request (fields sahaja, file dihantar berasingan)
  Map<String, String> toFormFields() {
    final map = <String, String>{
      'campaign_id': campaignId.toString(),
      'full_name': fullName,
      'branch': branch,
      'size': size,
      'quantity': quantity.toString(),
      'payment_status': paymentStatus,
    };
    if (phone != null && phone!.isNotEmpty) {
      map['phone'] = phone!;
    }
    if (trouserLength != null) {
      map['trouser_length'] = trouserLength.toString();
    }
    if (age != null) {
      map['age'] = age.toString();
    }
    if (remarks != null && remarks!.isNotEmpty) {
      map['remarks'] = remarks!;
    }
    return map;
  }

  factory UniformTempahan.fromJson(Map<String, dynamic> json) {
    return UniformTempahan(
      campaignId: json['campaign_id'] as int,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String?,
      branch: json['branch'] as String,
      size: json['size'] as String,
      trouserLength: (json['trouser_length'] as num?)?.toDouble(),
      age: json['age'] as int?,
      quantity: json['quantity'] as int? ?? 1,
      remarks: json['remarks'] as String?,
      paymentStatus: json['payment_status'] as String,
    );
  }
}