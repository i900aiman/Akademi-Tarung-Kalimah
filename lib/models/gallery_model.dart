class GalleryAlbum {
  final int id;
  final String title;
  final String description;
  final DateTime activityDate;
  final int imagesCount;
  final String coverUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GalleryAlbum({
    required this.id,
    required this.title,
    required this.description,
    required this.activityDate,
    required this.imagesCount,
    required this.coverUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GalleryAlbum.fromJson(Map<String, dynamic> json) {
    return GalleryAlbum(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      activityDate: DateTime.parse(json['activity_date'] as String),
      imagesCount: json['images_count'] as int? ?? 0,
      coverUrl: json['cover_url'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// "20 August 2026"
  String get formattedDate {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${activityDate.day} ${months[activityDate.month - 1]} ${activityDate.year}';
  }
}

/// Wraps the paginated `/albums` list response.
class GalleryAlbumPage {
  final List<GalleryAlbum> data;
  final int page;
  final int perPage;
  final int total;
  final int lastPage;

  const GalleryAlbumPage({
    required this.data,
    required this.page,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory GalleryAlbumPage.fromJson(Map<String, dynamic> json) {
    return GalleryAlbumPage(
      data: (json['data'] as List<dynamic>)
          .map((e) => GalleryAlbum.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: json['page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 20,
      total: json['total'] as int? ?? 0,
      lastPage: json['total_pages'] as int? ?? 1,
    );
  }

  bool get hasMore => page < lastPage;
}