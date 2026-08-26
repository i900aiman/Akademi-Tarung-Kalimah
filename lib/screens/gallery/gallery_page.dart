import 'package:flutter/material.dart';
import 'package:saderi_silat/api/get.dart';
import 'package:saderi_silat/models/gallery_model.dart';
import 'package:saderi_silat/screens/gallery/gallery_album_detail_page.dart';
import 'package:saderi_silat/widgets/gallery_album_card.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  static const _green=  Color(0xFF35472E);
  static const _bg = Color(0xFFF6F3FB);

  final _service = GalleryService();

  bool _showAnnouncements = false;
  bool _loading = true;
  String? _error;
  GalleryAlbumPage? _albumPage;

  @override
  void initState() {
    super.initState();
    _loadAlbums();
  }

  Future<void> _loadAlbums() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await _service.fetchAlbums();
      setState(() => _albumPage = result);
    } catch (e) {
      setState(() => _error = 'Gagal memuat album. Cuba lagi.');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _confirmDelete(GalleryAlbum album) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Padam Album?'),
        content: Text('Album "${album.title}" akan dipadam secara kekal.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Padam', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    // if (confirmed == true) {
    //   try {
    //     await _service.deleteAlbum(album.id);
    //     _loadAlbums();
    //   } catch (e) {
    //     if (mounted) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(content: Text('Gagal padam album.')),
    //       );
    //     }
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadAlbums,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            children: [
              const Text(
                'Pengumuman & Galeri Aktiviti',
                style: TextStyle(
                  color: _green,
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Hebahan makluman rasmi, cuti pusat mengaji dan album gambar aktiviti pembelajaran.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 20),

              // Tabs
              Row(
                children: [
                  _TabButton(
                    icon: Icons.image_outlined,
                    label: 'Galeri Album Aktiviti (${_albumPage?.total ?? 0})',
                    selected: !_showAnnouncements,
                    onTap: () => setState(() => _showAnnouncements = false),
                  ),
                  const SizedBox(width: 24),
                  _TabButton(
                    icon: Icons.campaign_outlined,
                    label: 'Pengumuman Rasmi (1)',
                    selected: _showAnnouncements,
                    onTap: () => setState(() => _showAnnouncements = true),
                  ),
                ],
              ),
              Container(height: 1, color: Colors.grey.shade300, margin: const EdgeInsets.only(top: 4)),
              const SizedBox(height: 20),

              if (!_showAnnouncements) ..._buildGallerySection() else _buildAnnouncementsPlaceholder(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGallerySection() {
    return [
      Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                children: [
                  const TextSpan(text: 'Menunjukkan '),
                  TextSpan(
                    text: '${_albumPage?.data.length ?? 0}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const TextSpan(text: ' album aktiviti rasmi'),
                ],
              ),
            ),
          ),
          OutlinedButton.icon(
            onPressed: _loading ? null : _loadAlbums,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Muat Semula'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black87,
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
      const SizedBox(height: 24),
      if (_loading)
        const Padding(
          padding: EdgeInsets.only(top: 40),
          child: Center(child: CircularProgressIndicator(color: _green)),
        )
      else if (_error != null)
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Center(child: Text(_error!, style: const TextStyle(color: Colors.red))),
        )
      else if ((_albumPage?.data.isEmpty ?? true))
        const Padding(
          padding: EdgeInsets.only(top: 40),
          child: Center(child: Text('Belum ada album lagi.')),
        )
      else
        ..._albumPage!.data.map(
          (album) => 
           GalleryAlbumCard(
            album: album,
            onView: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GalleryAlbumDetailPage(
                    albumId: album.id,
                    onEdit: () {
                      // TODO: navigate to edit-album form
                    },
                    onChanged: _loadAlbums,
                  ),
                ),
              );
            },
            onEdit: () {},
            onDelete: () {},
          ),
        ),
    ];
  }

  Widget _buildAnnouncementsPlaceholder() {
    return const Padding(
      padding: EdgeInsets.only(top: 40),
      child: Center(child: Text('Pengumuman Rasmi akan datang.')),
    );
  }
}

class _TabButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  static const _purple = Color(0xFF3D0E63);

  @override
  Widget build(BuildContext context) {
    final color = selected ? _purple : Colors.grey.shade500;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 3,
              width: 4 + label.length * 7.0,
              color: selected ? _purple : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}