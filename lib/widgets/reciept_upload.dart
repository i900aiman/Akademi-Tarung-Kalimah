import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/app_theme.dart';

/// Kotak upload resit pembayaran. Papar preview thumbnail bila fail
/// dah dipilih, dan tanda merah jika belum pilih tapi wajib.
///
/// Guna [XFile] (bukan dart:io File) + [Image.memory] untuk preview
/// supaya jalan sama ada di mobile ATAU Flutter Web.
class ReceiptUploadBox extends StatelessWidget {
  final XFile? file;
  final VoidCallback onTap;
  final bool showRequiredError;

  const ReceiptUploadBox({
    super.key,
    required this.file,
    required this.onTap,
    this.showRequiredError = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = file != null;
    final borderColor = showRequiredError
        ? Colors.redAccent
        : (hasFile ? AppTheme.primaryGreen : Colors.grey.shade300);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: hasFile ? AppTheme.lightGreen.withValues(alpha: 0.35) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 48,
                height: 48,
                child: hasFile ? _Thumbnail(file: file!) : _Placeholder(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasFile ? 'Resit dipilih' : 'Muat Naik Resit Pembayaran *',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hasFile ? file!.name : 'Ketik untuk pilih gambar resit',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppTheme.textMuted,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              hasFile ? Icons.check_circle : Icons.add_photo_alternate_outlined,
              color: hasFile ? AppTheme.primaryGreen : AppTheme.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Icon(Icons.receipt_long, color: AppTheme.textMuted, size: 22),
    );
  }
}

/// Baca bytes fail (async) sekali sahaja lepas tu papar guna Image.memory.
/// Ini yang buat preview jalan kat Web sekali kat mobile — Image.file
/// TIDAK disokong oleh Flutter Web.
class _Thumbnail extends StatefulWidget {
  final XFile file;
  const _Thumbnail({required this.file});

  @override
  State<_Thumbnail> createState() => _ThumbnailState();
}

class _ThumbnailState extends State<_Thumbnail> {
  late Future<Uint8List> _bytesFuture;

  @override
  void initState() {
    super.initState();
    _bytesFuture = widget.file.readAsBytes();
  }

  @override
  void didUpdateWidget(covariant _Thumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.file.path != widget.file.path) {
      _bytesFuture = widget.file.readAsBytes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _bytesFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            color: Colors.white,
            child: const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        return Image.memory(snapshot.data!, fit: BoxFit.cover);
      },
    );
  }
}