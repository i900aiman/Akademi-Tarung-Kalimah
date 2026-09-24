import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saderi_silat/models/tempahan_model.dart';
import 'package:saderi_silat/service/tempahan_service.dart';
import 'package:saderi_silat/theme/app_theme.dart';
import 'package:saderi_silat/widgets/campaign_header.dart';
import 'package:saderi_silat/widgets/chip_field.dart';
import 'package:saderi_silat/widgets/reciept_upload.dart';
import 'package:saderi_silat/widgets/section_card.dart';
import 'package:saderi_silat/widgets/submit_footer.dart';

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

  static const List<String> _paymentStatuses = ['unpaid', 'deposit', 'paid'];
  static const Map<String, String> _paymentLabels = {
    'unpaid': 'Belum Bayar',
    'deposit': 'Deposit',
    'paid': 'Selesai Bayar',
  };

  late Future<OrderCampaign?> _campaignFuture;
  OrderCampaign? _campaign;

  String? _branch;
  String? _jerseyType;
  String? _size;
  String? _sleeveOption;
  String? _paymentStatus;
  int _quantity = 1;
  XFile? _receipt;
  bool _isSubmitting = false;
  bool _triedSubmit = false;

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
    super.dispose();
  }

  Future<void> _pilihResit() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked != null) setState(() => _receipt = picked);
  }

  double? _estimatedPrice() {
    if (_campaign == null || _jerseyType == null) return null;
    final isMuslimah = _jerseyType!.toLowerCase().contains('muslimah');
    double? price = isMuslimah
        ? (_campaign!.muslimahPrice ?? _campaign!.basePrice)
        : _campaign!.basePrice;
    if (price == null) return null;
    final isLongSleeve = _sleeveOption?.toLowerCase().contains('panjang') ?? false;
    if (isLongSleeve && _campaign!.longSleeveSurcharge != null) {
      price += _campaign!.longSleeveSurcharge!;
    }
    return price * _quantity;
  }

  Future<void> _submit() async {
    setState(() => _triedSubmit = true);
    final formOk = _formKey.currentState!.validate();
    final chipsOk = _branch != null &&
        _jerseyType != null &&
        _size != null &&
        _paymentStatus != null;
    final receiptOk = !_receiptRequired || _receipt != null;

    if (!formOk || !chipsOk || !receiptOk || _campaign == null) {
      setState(() {});
      return;
    }

    setState(() => _isSubmitting = true);

    final data = JerseyTempahan(
      campaignId: _campaign!.id,
      fullName: _fullNameCtrl.text.trim(),
      jerseyName: _jerseyNameCtrl.text.trim().isEmpty ? null : _jerseyNameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
      branch: _branch!,
      jerseyType: _jerseyType!,
      size: _size!,
      sleeveOption: _sleeveOption!,
      quantity: _quantity,
      remarks: _remarksCtrl.text.trim().isEmpty ? null : _remarksCtrl.text.trim(),
      paymentStatus: _paymentStatus!,
      receipt: _receipt,
    );

    try {
      await TempahanService.submitOrder(fields: data.toFormFields(), receipt: _receipt);
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
        _quantity = 1;
        _triedSubmit = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  InputDecoration _decoration(String label, {bool required = false, String? hint}) {
    return InputDecoration(
      labelText: required ? '$label *' : label,
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      labelStyle: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.primaryGreen, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      child: FutureBuilder<OrderCampaign?>(
        future: _campaignFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _InfoState(
              icon: Icons.wifi_off_rounded,
              message: 'Gagal muat kempen jersi.\n${snapshot.error}',
            );
          }
          final campaign = snapshot.data;
          if (campaign == null) {
            return const _InfoState(
              icon: Icons.checkroom_outlined,
              message: 'Tiada kempen jersi yang sedang dibuka buat masa ini.',
            );
          }
          return _buildForm(campaign);
        },
      ),
    );
  }

  Widget _buildForm(OrderCampaign campaign) {
    final price = _estimatedPrice();
    return Column(
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              children: [
                CampaignHeader(campaign: campaign),
                const SizedBox(height: 16),
                SectionCard(
                  title: 'Maklumat Peribadi',
                  icon: Icons.person_outline,
                  children: [
                    TextFormField(
                      controller: _fullNameCtrl,
                      decoration: _decoration('Nama Penuh', required: true),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _jerseyNameCtrl,
                      decoration: _decoration('Nama Dicetak Pada Jersi'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: _decoration('Nombor Telefon'),
                    ),
                  ],
                ),
                SectionCard(
                  title: 'Butiran Jersi',
                  icon: Icons.checkroom_outlined,
                  children: [
                    ChipField(
                      label: 'Cawangan',
                      required: true,
                      options: campaign.branches,
                      value: _branch,
                      onChanged: (v) => setState(() => _branch = v),
                      errorText: _triedSubmit && _branch == null ? 'Wajib dipilih' : null,
                    ),
                    ChipField(
                      label: 'Jenis Jersi',
                      required: true,
                      options: campaign.jerseyTypes,
                      value: _jerseyType,
                      onChanged: (v) => setState(() => _jerseyType = v),
                      errorText: _triedSubmit && _jerseyType == null ? 'Wajib dipilih' : null,
                    ),
                    ChipField(
                      label: 'Saiz',
                      required: true,
                      options: campaign.sizes,
                      value: _size,
                      onChanged: (v) => setState(() => _size = v),
                      errorText: _triedSubmit && _size == null ? 'Wajib dipilih' : null,
                    ),
                    ChipField(
                      label: 'Jenis Lengan',
                      options: campaign.sleeveOptions,
                      value: _sleeveOption,
                      onChanged: (v) => setState(() => _sleeveOption = v),
                    ),
                    const SizedBox(height: 4),
                    _QuantityStepper(
                      value: _quantity,
                      onChanged: (v) => setState(() => _quantity = v),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _remarksCtrl,
                      maxLines: 2,
                      decoration: _decoration('Catatan', hint: 'Contoh: Perlu sebelum kejohanan'),
                    ),
                  ],
                ),
                SectionCard(
                  title: 'Pembayaran',
                  icon: Icons.payments_outlined,
                  children: [
                    ChipField(
                      label: 'Status Pembayaran',
                      required: true,
                      options: _paymentStatuses.map((p) => _paymentLabels[p]!).toList(),
                      value: _paymentStatus != null ? _paymentLabels[_paymentStatus] : null,
                      onChanged: (label) => setState(() {
                        _paymentStatus =
                            _paymentLabels.entries.firstWhere((e) => e.value == label).key;
                      }),
                      errorText:
                          _triedSubmit && _paymentStatus == null ? 'Wajib dipilih' : null,
                    ),
                    if (_receiptRequired)
                      ReceiptUploadBox(
                        file: _receipt,
                        onTap: _pilihResit,
                        showRequiredError: _triedSubmit && _receipt == null,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SubmitFooter(price: price, isSubmitting: _isSubmitting, onSubmit: _submit),
      ],
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _QuantityStepper({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Kuantiti',
          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppTheme.textMuted),
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.remove, size: 18),
                onPressed: value > 1 ? () => onChanged(value - 1) : null,
              ),
              SizedBox(
                width: 24,
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.add, size: 18),
                onPressed: () => onChanged(value + 1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _InfoState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: AppTheme.textMuted),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}