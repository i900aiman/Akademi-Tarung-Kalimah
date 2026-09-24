import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

/// Bar bawah yang tetap kelihatan (tidak scroll) — papar anggaran harga
/// (jika ada) di sebelah kiri, dan butang hantar penuh di kanan.
class SubmitFooter extends StatelessWidget {
  final double? price;
  final bool isSubmitting;
  final VoidCallback onSubmit;
  final String label;

  const SubmitFooter({
    super.key,
    required this.price,
    required this.isSubmitting,
    required this.onSubmit,
    this.label = 'Hantar Tempahan',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16, 12, 16, 12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (price != null) ...[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Anggaran Jumlah',
                    style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                  ),
                  Text(
                    'RM${price!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: price != null ? 2 : 1,
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}