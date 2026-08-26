

import 'package:saderi_silat/models/gallery_model.dart';

class GalleryAlbumImage {
  final int id;
  final String originalName;
  final int sortOrder;
  final String imageUrl;

  const GalleryAlbumImage({
    required this.id,
    required this.originalName,
    required this.sortOrder,
    required this.imageUrl,
  });

  factory GalleryAlbumImage.fromJson(Map<String, dynamic> json) {
    return GalleryAlbumImage(
      id: json['id'] as int,
      originalName: json['original_name'] as String? ?? '',
      sortOrder: json['sort_order'] as int? ?? 0,
      imageUrl: json['image_url'] as String? ?? '',
    );
  }
}

/// Full album detail — same fields as [GalleryAlbum] plus the image list,
/// returned from GET /albums/{id}.
class GalleryAlbumDetail extends GalleryAlbum {
  final List<GalleryAlbumImage> images;

  const GalleryAlbumDetail({
    required super.id,
    required super.title,
    required super.description,
    required super.activityDate,
    required super.imagesCount,
    required super.coverUrl,
    required super.createdAt,
    required super.updatedAt,
    required this.images,
  });

  factory GalleryAlbumDetail.fromJson(Map<String, dynamic> json) {
    final images = (json['images'] as List<dynamic>? ?? [])
        .map((e) => GalleryAlbumImage.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return GalleryAlbumDetail(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      activityDate: DateTime.parse(json['activity_date'] as String),
      imagesCount: json['photo_count'] as int? ?? 0,
      coverUrl: json['cover_url'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      images: images,
    );
  }
}