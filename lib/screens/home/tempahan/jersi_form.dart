import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saderi_silat/models/tempahan_model.dart';
import 'package:saderi_silat/service/tempahan_service.dart';
import 'package:saderi_silat/theme/app_theme.dart';


class JersiFormPage extends StatefulWidget {
  const JersiFormPage({super.key});

  @override
  State<JersiFormPage> createState() => _JersiFormPageState();
}

class _JersiFormPageState extends State<JersiFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameCtrl = TextEditingController();
  final _jerseyNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _remarksCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController(text: '1');

  // Status pembayaran bukan sebahagian data kempen, so kekal statik.
  static const List<String> _paymentStatuses = ['unpaid', 'deposit', 'paid'];

  late Future<OrderCampaign?> _campaignFuture;
  OrderCampaign? _campaign;

  String? _branch;
  String? _jerseyType;
  String? _size;
  String? _sleeveOption;
  String? _paymentStatus;
  File? _receipt;
  bool _isSubmitting = false;

  bool get _receiptRequired =>
      _paymentStatus == 'deposit' || _paymentStatus == 'paid';

  @override
  void initState() {
    super.initState();
    _campaignFuture = _loadCampaign();
  }

  Future<OrderCampaign?> _loadCampaign() async {
    final campaigns = await TempahanService.fetchOpenJerseyCampaigns();
    if (campaigns.isEmpty) return null;
    final campaign = campaigns.first;
    _campaign = campaign;
    if (campaign.sleeveOptions.isNotEmpty) {
      _sleeveOption = campaign.sleeveOptions.first;
    }
    return campaign;
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _jerseyNameCtrl.dispose();
    _phoneCtrl.dispose();
    _remarksCtrl.dispose();
    _quantityCtrl.dispose();
    super.dispose();
  }

  Future<void> _pilihResit() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _receipt = File(picked.path));
    }
  }

  // Anggaran harga berdasarkan jenis jersi + sleeve surcharge dari kempen.
  double? _estimatedPrice() {
    if (_campaign == null || _jerseyType == null) return null;
    final isMuslimah = _jerseyType!.toLowerCase().contains('muslimah');
    double? price = isMuslimah
        ? (_campaign!.muslimahPrice ?? _campaign!.basePrice)
        : _campaign!.basePrice;
    if (price == null) return null;
    final isLongSleeve =
        _sleeveOption?.toLowerCase().contains('panjang') ?? false;
    if (isLongSleeve && _campaign!.longSleeveSurcharge != null) {
      price += _campaign!.longSleeveSurcharge!;
    }
    final qty = int.tryParse(_quantityCtrl.text.trim()) ?? 1;
    return price * qty;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_campaign == null) return;

    if (_receiptRequired && _receipt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sila muat naik resit pembayaran')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final data = JerseyTempahan(
      campaignId: _campaign!.id,
      fullName: _fullNameCtrl.text.trim(),
      jerseyName: _jerseyNameCtrl.text.trim().isEmpty
          ? null
          : _jerseyNameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
      branch: _branch!,
      jerseyType: _jerseyType!,
      size: _size!,
      sleeveOption: _sleeveOption!,
      quantity: int.tryParse(_quantityCtrl.text.trim()) ?? 1,
      remarks:
          _remarksCtrl.text.trim().isEmpty ? null : _remarksCtrl.text.trim(),
      paymentStatus: _paymentStatus!,
      receipt: _receipt,
    );

    try {
      await TempahanService.submitOrder(
        fields: data.toFormFields(),
        receipt: _receipt,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tempahan jersi berjaya dihantar')),
      );
      _formKey.currentState!.reset();
      setState(() {
        _branch = null;
        _jerseyType = null;
        _size = null;
        _sleeveOption = _campaign?.sleeveOptions.isNotEmpty == true
            ? _campaign!.sleeveOptions.first
            : null;
        _paymentStatus = null;
        _receipt = null;
        _quantityCtrl.text = '1';
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OrderCampaign?>(
      future: _campaignFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Gagal muat kempen jersi: ${snapshot.error}'),
            ),
          );
        }
        final campaign = snapshot.data;
        if (campaign == null) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('Tiada kempen jersi yang sedang dibuka buat masa ini.'),
            ),
          );
        }
        return _buildForm(campaign);
      },
    );
  }

  Widget _buildForm(OrderCampaign campaign) {
    final price = _estimatedPrice();
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (campaign.photos.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                campaign.photos.first.imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          const SizedBox(height: 12),
          Text(
            campaign.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          if (campaign.description != null) ...[
            const SizedBox(height: 4),
            Text(
              campaign.description!,
              style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
            ),
          ],
          const SizedBox(height: 16),
          TextFormField(
            controller: _fullNameCtrl,
            decoration: const InputDecoration(labelText: 'Nama Penuh *'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _jerseyNameCtrl,
            decoration:
                const InputDecoration(labelText: 'Nama Dicetak Pada Jersi'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Nombor Telefon'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _branch,
            decoration: const InputDecoration(labelText: 'Cawangan *'),
            items: campaign.branches
                .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                .toList(),
            onChanged: (v) => setState(() => _branch = v),
            validator: (v) => v == null ? 'Wajib dipilih' : null,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _jerseyType,
            decoration: const InputDecoration(labelText: 'Jenis Jersi *'),
            items: campaign.jerseyTypes
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (v) => setState(() => _jerseyType = v),
            validator: (v) => v == null ? 'Wajib dipilih' : null,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _size,
            decoration: const InputDecoration(labelText: 'Saiz *'),
            items: campaign.sizes
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (v) => setState(() => _size = v),
            validator: (v) => v == null ? 'Wajib dipilih' : null,
          ),
          const SizedBox(height: 12),
          Text('Jenis Lengan', style: Theme.of(context).textTheme.bodyMedium),
          ...campaign.sleeveOptions.map(
            (opt) => RadioListTile<String>(
              contentPadding: EdgeInsets.zero,
              title: Text(opt),
              value: opt,
              groupValue: _sleeveOption,
              onChanged: (v) => setState(() => _sleeveOption = v),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _quantityCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Kuantiti'),
            onChanged: (_) => setState(() {}),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return null;
              return int.tryParse(v) == null ? 'Mesti nombor' : null;
            },
          ),
          if (price != null) ...[
            const SizedBox(height: 8),
            Text(
              'Anggaran harga: RM${price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryGreen,
              ),
            ),
          ],
          const SizedBox(height: 12),
          TextFormField(
            controller: _remarksCtrl,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Catatan',
              hintText: 'Contoh: Perlu sebelum kejohanan',
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _paymentStatus,
            decoration: const InputDecoration(labelText: 'Status Pembayaran *'),
            items: _paymentStatuses
                .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                .toList(),
            onChanged: (v) => setState(() => _paymentStatus = v),
            validator: (v) => v == null ? 'Wajib dipilih' : null,
          ),
          if (_receiptRequired) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _pilihResit,
              icon: const Icon(Icons.upload_file),
              label: Text(_receipt == null
                  ? 'Muat Naik Resit *'
                  : 'Resit dipilih: ${_receipt!.path.split('/').last}'),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Hantar Tempahan'),
            ),
          ),
        ],
      ),
    );
  }
}