import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/entities.dart';
import '../../services/api_client.dart';
import '../../services/app_api.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_ui_helpers.dart';

class AddEditPesananScreen extends StatefulWidget {
  final Pesanan? data;

  const AddEditPesananScreen({super.key, this.data});

  @override
  State<AddEditPesananScreen> createState() => _AddEditPesananScreenState();
}

class _AddEditPesananScreenState extends State<AddEditPesananScreen> {
  final _api = AppApi();
  List<Pelanggan> _pelanggan = [];
  List<Layanan> _layanan = [];
  List<Outlet> _outlets = [];
  int? _pelangganId;
  int? _layananId;
  int? _outletId;
  final _qtyCtrl = TextEditingController(text: '1');
  bool _loading = true;
  bool _saving = false;
  String? _error;

  bool get _isEdit => widget.data != null;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    try {
      final pelanggan = await _api.listPelanggan(limit: 100);
      final layanan = await _api.listLayanan(limit: 100);
      final outlets = await _api.listOutlets(limit: 50);
      if (!mounted) return;
      setState(() {
        _pelanggan = pelanggan.items;
        _layanan = layanan.items.where((e) => e.isActive).toList();
        _outlets = outlets.items;
        _outletId = widget.data?.outletId ?? (_outlets.isNotEmpty ? _outlets.first.id : null);
        _pelangganId = widget.data?.pelangganId;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Gagal memuat form';
        _loading = false;
      });
    }
  }

  Future<void> _submit() async {
    if (_isEdit) {
      // For edit, only status/lunas update is supported by API PUT
      try {
        setState(() => _saving = true);
        await _api.updatePesanan(widget.data!.id, {
          'status': widget.data!.status,
          'is_lunas': widget.data!.isLunas,
        });
        if (!mounted) return;
        Navigator.pop(context, true);
        AppToast.show(context, message: 'Pesanan diperbarui');
      } on ApiException catch (e) {
        if (!mounted) return;
        AppToast.show(context, message: e.message, type: AppToastType.error);
      } finally {
        if (mounted) setState(() => _saving = false);
      }
      return;
    }

    if (_outletId == null || _layananId == null) {
      AppToast.show(context, message: 'Pilih outlet dan layanan', type: AppToastType.error);
      return;
    }
    final qty = double.tryParse(_qtyCtrl.text.trim()) ?? 0;
    if (qty <= 0) {
      AppToast.show(context, message: 'Qty harus lebih dari 0', type: AppToastType.error);
      return;
    }

    setState(() => _saving = true);
    try {
      await _api.createPesanan({
        'outlet_id': _outletId,
        'pelanggan_id': _pelangganId,
        'items': [
          {'layanan_id': _layananId, 'qty': qty},
        ],
      });
      if (!mounted) return;
      Navigator.pop(context, true);
      AppToast.show(context, message: 'Pesanan berhasil dibuat');
    } on ApiException catch (e) {
      if (!mounted) return;
      AppToast.show(context, message: e.message, type: AppToastType.error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.primaryRed)));
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Buat Pesanan')),
        body: AppEmptyState(icon: Icons.wifi_off_rounded, title: 'Gagal memuat', message: _error!, actionLabel: 'Coba Lagi', onAction: _bootstrap),
      );
    }

    final selectedLayanan = _layanan.cast<Layanan?>().firstWhere(
      (e) => e?.id == _layananId,
      orElse: () => null,
    );
    final qty = double.tryParse(_qtyCtrl.text.trim()) ?? 0;
    final estimasi = selectedLayanan == null ? 0.0 : selectedLayanan.harga * qty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(_isEdit ? 'Edit Pesanan' : 'Buat Pesanan')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.base),
        children: [
          Text('Outlet', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 6),
          DropdownButtonFormField<int>(
            value: _outletId,
            items: _outlets.map((o) => DropdownMenuItem(value: o.id, child: Text(o.name, overflow: TextOverflow.ellipsis))).toList(),
            onChanged: _isEdit ? null : (v) => setState(() => _outletId = v),
            decoration: const InputDecoration(hintText: 'Pilih outlet'),
          ),
          const SizedBox(height: AppSpacing.base),
          Text('Pelanggan', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 6),
          DropdownButtonFormField<int>(
            value: _pelangganId,
            items: _pelanggan.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
            onChanged: _isEdit ? null : (v) => setState(() => _pelangganId = v),
            decoration: const InputDecoration(hintText: 'Pilih pelanggan'),
          ),
          const SizedBox(height: AppSpacing.base),
          Text('Layanan', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 6),
          DropdownButtonFormField<int>(
            value: _layananId,
            items: _layanan
                .map((l) => DropdownMenuItem(
                      value: l.id,
                      child: Text('${l.name} · ${formatRupiah(l.harga)}/${l.satuan}', overflow: TextOverflow.ellipsis),
                    ))
                .toList(),
            onChanged: _isEdit ? null : (v) => setState(() => _layananId = v),
            decoration: const InputDecoration(hintText: 'Pilih layanan'),
          ),
          const SizedBox(height: AppSpacing.base),
          AppFormField(
            label: 'Qty',
            hint: '1',
            controller: _qtyCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.base),
          Text('Estimasi total: ${formatRupiah(estimasi)}', style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppColors.primaryRed)),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: _saving ? null : _submit,
            child: _saving
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text(_isEdit ? 'Simpan' : 'Buat Pesanan'),
          ),
        ],
      ),
    );
  }
}
