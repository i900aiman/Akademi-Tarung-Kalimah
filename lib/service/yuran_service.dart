import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:saderi_silat/api/api_config.dart';
import 'package:saderi_silat/models/yuran_model.dart';

class YuranService {
  Future<YuranPage> searchYuran({
  required String studentName,
  required String status,
  int page = 1,
  int perPage = 20,
  int? year,
  int? month,
}) async {
    final params = <String, String>{
      'name': studentName,
        'status': status,
      'page': '$page',
      'per_page': '$perPage',
    };

    if (year != null) {
      params['year'] = '$year';
    }

    if (month != null) {
      params['month'] = '$month';
    }

    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/monthly-fees/search',
    ).replace(
      queryParameters: params,
    );

    print('====================================');
    print('YURAN API URL: $uri');
    print('====================================');

final response = await http.get(
  uri,
  headers: {
    'Authorization': 'Bearer cafa0e27adaa4645c7af317f6711d389c7f91d948cf62cfc48f9072ffb7f6b17',
    'Accept': 'application/json',
  },
);

    print('STATUS CODE: ${response.statusCode}');
    print('RESPONSE BODY: ${response.body}');

    if (response.statusCode == 200) {
      return YuranPage.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw Exception(
      'Gagal cari yuran: ${response.statusCode} - ${response.body}',
    );
  }
}