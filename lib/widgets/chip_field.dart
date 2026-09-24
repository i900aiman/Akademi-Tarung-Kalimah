import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

/// Field pemilihan tunggal bergaya chip — ganti dropdown yang nampak
/// membosankan dengan sesuatu yang lebih senang disentuh & jelas dipilih.
class ChipField extends StatelessWidget {
  final String label;
  final bool required;
  final List<String> options;
  final String? value;
  final ValueChanged<String> onChanged;
  final String? errorText;

  const ChipField({
    super.key,
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
    this.required = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            required ? '$label *' : label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((opt) {
              final selected = opt == value;
              return ChoiceChip(
                label: Text(opt),
                selected: selected,
                onSelected: (_) => onChanged(opt),
                showCheckmark: false,
                labelStyle: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppTheme.textDark,
                ),
                backgroundColor: Colors.grey.shade100,
                selectedColor: AppTheme.primaryGreen,
                side: BorderSide(
                  color: selected ? AppTheme.primaryGreen : Colors.grey.shade300,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            }).toList(),
          ),
          if (errorText != null) ...[
            const SizedBox(height: 6),
            Text(
              errorText!,
              style: const TextStyle(fontSize: 11.5, color: Colors.redAccent),
            ),
          ],
        ],
      ),
    );
  }
}