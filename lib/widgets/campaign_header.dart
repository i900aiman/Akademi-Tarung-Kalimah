import 'package:flutter/material.dart';
import 'package:saderi_silat/models/tempahan_model.dart';

/// Banner atas form — gambar produk kempen dengan tajuk & deskripsi
/// dilapik gradient supaya teks sentiasa jelas dibaca.
class CampaignHeader extends StatelessWidget {
  final OrderCampaign campaign;

  const CampaignHeader({super.key, required this.campaign});

  @override
  Widget build(BuildContext context) {
    final hasPhoto = campaign.photos.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 170,
        width: double.infinity,
        color: Colors.grey.shade300,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (hasPhoto)
              Image.network(
                campaign.photos.first.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300),
              ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.0),
                      Colors.black.withValues(alpha: 0.65),
                    ],
                    stops: const [0.35, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    campaign.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  if (campaign.description != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      campaign.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 11.5,
                        height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}