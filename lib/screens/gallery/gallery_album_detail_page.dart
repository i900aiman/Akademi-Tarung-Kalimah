import 'package:flutter/material.dart';
import 'package:saderi_silat/api/get.dart';
import 'package:saderi_silat/models/gallery_album_model.dart';
import 'package:saderi_silat/widgets/fullscreen_image_viewer.dart';


class GalleryAlbumDetailPage extends StatefulWidget {
  final int albumId;
  final VoidCallback? onEdit;
  final VoidCallback? onChanged;

  const GalleryAlbumDetailPage({
    super.key,
    required this.albumId,
    this.onEdit,
    this.onChanged,
  });

  @override
  State<GalleryAlbumDetailPage> createState() => _GalleryAlbumDetailPageState();
}

class _GalleryAlbumDetailPageState extends State<GalleryAlbumDetailPage> {
  static const _green=  Color(0xFF35472E);
  static const _bg = Color(0xFFF6F3FB);

  final _service = GalleryService();
  bool _loading = true;
  String? _error;
  GalleryAlbumDetail? _detail;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final detail = await _service.fetchAlbumDetail(widget.albumId);
      setState(() => _detail = detail);
    } catch (e) {
      setState(() => _error = 'Gagal memuat butiran album.');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _confirmDeleteImage(GalleryAlbumImage image) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Padam Gambar?'),
        content: const Text('Gambar ini akan dipadam secara kekal daripada album.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Padam', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true || _detail == null) return;
    
    // Logik padam gambar & panggil widget.onChanged?.call();
  }

  void _openViewer(int index) {
    if (_detail == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FullscreenImageViewer(
          images: _detail!.images,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: Text(_detail?.title ?? 'Butiran Album'),
        backgroundColor: Colors.white,
        foregroundColor: _green,
        elevation: 0.5,
        // actions: [
        //   if (_detail != null)
        //     IconButton(
        //       icon: const Icon(Icons.edit_outlined),
        //       onPressed: widget.onEdit,
        //       tooltip: 'Sunting Album',
        //     ),
        // ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _green))
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : _buildBody(),
    );
  }

  Widget _buildBody() {
    final detail = _detail!;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tag & Tarikh
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1E9FB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Aktiviti Kelas',
                  style: TextStyle(color: _green, fontWeight: FontWeight.w600, fontSize: 12.5),
                ),
              ),
              const Spacer(),
              Icon(Icons.calendar_today_rounded, size: 15, color: Colors.grey.shade500),
              const SizedBox(width: 6),
              Text(detail.formattedDate, style: TextStyle(color: Colors.grey.shade500, fontSize: 13.5)),
            ],
          ),
          const SizedBox(height: 16),

          // Tajuk & Deskripsi
          Text(
            detail.title,
            style: const TextStyle(color: _green, fontWeight: FontWeight.w800, fontSize: 24),
          ),
          if (detail.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(detail.description, style: TextStyle(color: Colors.grey.shade600, fontSize: 15, height: 1.4)),
          ],
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 20),

          // Sub-header Koleksi Foto
          Row(
            children: [
              const Icon(Icons.camera_alt_outlined, size: 20, color: _green),
              const SizedBox(width: 8),
              Text(
                'Koleksi Foto (${detail.images.length} Gambar)',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              const Spacer(),
              if (!isMobile)
                Text(
                  'Klik gambar untuk zoom & slaid paparan',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12.5),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Grid Gambar
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: detail.images.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 2 : 4, // 4 lajur di Web, 2 di Mobile
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.15,
            ),
            itemBuilder: (context, index) {
              final image = detail.images[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () => _openViewer(index),
                        child: Image.network(
                          image.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    // Positioned(
                    //   top: 8,
                    //   right: 8,
                    //   child: GestureDetector(
                    //     onTap: () => _confirmDeleteImage(image),
                    //     child: Container(
                    //       padding: const EdgeInsets.all(8),
                    //       decoration: const BoxDecoration(
                    //         color: Color(0xFFEF6558),
                    //         shape: BoxShape.circle,
                    //       ),
                    //       child: const Icon(Icons.delete_outline, color: Colors.white, size: 18),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}