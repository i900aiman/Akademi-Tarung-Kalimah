
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:saderi_silat/api/api_config.dart';
import 'package:saderi_silat/models/gallery_album_model.dart';
import 'package:saderi_silat/models/gallery_model.dart';





class GalleryService {
  Future<GalleryAlbumPage> fetchAlbums({int page = 1, int perPage = 20}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/albums?page=$page&per_page=$perPage');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return GalleryAlbumPage.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    throw Exception('Gagal memuat album (${response.statusCode})');
  }

  Future<GalleryAlbumDetail> fetchAlbumDetail(int id) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/albums/$id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return GalleryAlbumDetail.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    throw Exception('Gagal memuat butiran album (${response.statusCode})');
  }
}