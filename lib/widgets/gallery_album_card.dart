import 'package:flutter/material.dart';
import 'package:saderi_silat/models/gallery_model.dart';

class GalleryAlbumCard extends StatelessWidget {
  final GalleryAlbum album;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const GalleryAlbumCard({
    super.key,
    required this.album,
    this.onView,
    this.onEdit,
    this.onDelete,
  });

  static const _green =  Color(0xFF35472E);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover image + photo count badge
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 10,
                child: album.coverUrl.isNotEmpty
                    ? Image.network(
                        album.coverUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image_not_supported_outlined,
                              color: Colors.grey, size: 40),
                        ),
                      )
                    : Container(color: Colors.grey.shade200),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        '${album.imagesCount} Foto',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1E9FB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Aktiviti Kelas',
                    style: TextStyle(
                      color: _green,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  album.title,
                  style: const TextStyle(
                    color: _green,
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                  ),
                ),
                if (album.description.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    album.description,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13.5),
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: 15, color: Colors.grey.shade500),
                    const SizedBox(width: 6),
                    Text(
                      album.formattedDate,
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onView,
                        icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                        label: const Text('Lihat'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(width: 10),
                    // OutlinedButton.icon(
                    //   onPressed: onEdit,
                    //   icon: const Icon(Icons.edit_outlined, size: 18),
                    //   label: const Text('Edit'),
                    //   style: OutlinedButton.styleFrom(
                    //     foregroundColor: Colors.black87,
                    //     side: BorderSide(color: Colors.grey.shade300),
                    //     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(width: 10),
                    // IconButton(
                    //   onPressed: onDelete,
                    //   icon: const Icon(Icons.delete_outline, color: Colors.red),
                    //   style: IconButton.styleFrom(
                    //     side: const BorderSide(color: Color(0xFFFFCDD2)),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}