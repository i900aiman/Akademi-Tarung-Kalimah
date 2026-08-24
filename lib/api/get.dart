
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:saderi_silat/models/gallery_model.dart';

class GalleryService {
  // Adjust if you already have a shared ApiClient / base URL constant.
  static const String _baseUrl = 'https://api.akademitarungkalimah.com/api/v1';

  Future<GalleryAlbumPage> fetchAlbums({int page = 1, int perPage = 20}) async {
    final uri = Uri.parse('$_baseUrl/albums?page=$page&per_page=$perPage');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return GalleryAlbumPage.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    throw Exception('Gagal memuat album (${response.statusCode})');
  }

  Future<void> deleteAlbum(int id) async {
    final uri = Uri.parse('$_baseUrl/albums/$id');
    final response = await http.delete(uri);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Gagal padam album (${response.statusCode})');
    }
  }
}