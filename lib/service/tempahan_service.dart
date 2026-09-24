import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:saderi_silat/models/tempahan_model.dart';

/// Service untuk semua panggilan API berkaitan Tempahan (Orders).
///
/// Endpoint yang digunakan:
/// - GET  /api/v1/order-campaigns/open  -> senarai kempen jersi & uniform
/// - POST /api/v1/orders                -> hantar tempahan (jersi/uniform)
///
/// TODO: tukar [baseUrl] ikut backend sebenar.
class TempahanService {
  static const String baseUrl = 'https://api.akademitarungkalimah.com';

  /// GET /api/v1/order-campaigns/open
  /// Pulangkan senarai kempen (jersi + uniform) yang sedang dibuka.
  static Future<List<OrderCampaign>> fetchOpenCampaigns() async {
    final uri = Uri.parse('$baseUrl/api/v1/order-campaigns/open');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((e) => OrderCampaign.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw TempahanException(
      'Gagal dapatkan senarai kempen (${response.statusCode}): ${response.body}',
    );
  }

  /// Kempen jersi yang sedang dibuka sahaja (type == 'jersey')
  static Future<List<OrderCampaign>> fetchOpenJerseyCampaigns() async {
    final all = await fetchOpenCampaigns();
    return all.where((c) => c.isJersey).toList();
  }

  /// Kempen uniform yang sedang dibuka sahaja (type == 'uniform')
  static Future<List<OrderCampaign>> fetchOpenUniformCampaigns() async {
    final all = await fetchOpenCampaigns();
    return all.where((c) => c.isUniform).toList();
  }

  /// POST /api/v1/orders
  /// Endpoint sama untuk hantar tempahan jersi ATAU uniform — [fields]
  /// mesti ada `campaign_id`, backend tentukan jenis ikut kempen tu.
  static Future<bool> submitOrder({
    required Map<String, String> fields,
    XFile? receipt,
  }) async {
    final uri = Uri.parse('$baseUrl/api/v1/orders');
    final request = http.MultipartRequest('POST', uri);

    request.fields.addAll(fields);

    if (receipt != null) {
      // Guna bytes (bukan fromPath) — fromPath guna dart:io File stream
      // yang tak jalan kat Flutter Web.
      final bytes = await receipt.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes('receipt', bytes, filename: receipt.name),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }
    throw TempahanException(
      'Gagal hantar tempahan (${response.statusCode}): ${response.body}',
    );
  }
}

class TempahanException implements Exception {
  final String message;
  TempahanException(this.message);

  @override
  String toString() => message;
}