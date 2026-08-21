import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/entities.dart';
import '../../services/api_client.dart';
import '../../services/app_api.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_ui_helpers.dart';
import '../../widgets/modern_select_field.dart';

class AddEditLayananScreen extends StatefulWidget {
  final Layanan? data;

  const AddEditLayananScreen({super.key, this.data});

  @override
  State<AddEditLayananScreen> createState() => _AddEditLayananScreenState();
}

class _AddEditLayananScreenState extends State<AddEditLayananScreen> {
  final _api = AppApi();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _hargaCtrl;
  String? _selectedKategori;
  String? _selectedSatuan;
  bool _isActive = true;
  bool _saving = false;

  bool get _isEdit => widget.data != null;

  @override
  void initState() {
    super.initState();
    final d = widget.data;
    _nameCtrl = TextEditingController(text: d?.name ?? '');
    _hargaCtrl = TextEditingController(text: d != null ? d.harga.round().toString() : '');
    _selectedKategori = d?.kategori;
    _selectedSatuan = d?.satuan;
    _isActive = d?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _hargaCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedKategori == null) {
      AppToast.show(context, message: 'Pilih kategori layanan', type: AppToastType.error);
      return;
    }
    if (_selectedSatuan == null) {
      AppToast.show(context, message: 'Pilih satuan layanan', type: AppToastType.error);
      return;
    }

    setState(() => _saving = true);
    final body = {
      'name': _nameCtrl.text.trim(),
      'kategori': _selectedKategori,
      'harga': double.tryParse(_hargaCtrl.text.trim()) ?? 0,
      'satuan': _selectedSatuan,
      'is_active': _isActive,
    };

    try {
      if (_isEdit) {
        await _api.updateLayanan(widget.data!.id, body);
      } else {
        await _api.createLayanan(body);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
      AppToast.show(context, message: _isEdit ? 'Layanan berhasil diperbarui' : 'Layanan berhasil ditambahkan');
    } on ApiException catch (e) {
      if (!mounted) return;
      AppToast.show(context, message: e.message, type: AppToastType.error);
    } catch (_) {
      if (!mounted) return;
      AppToast.show(context, message: 'Gagal menyimpan layanan', type: AppToastType.error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(_isEdit ? 'Edit Layanan' : 'Tambah Layanan')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.base),
          children: [
            _sectionLabel('Informasi Layanan'),
            const SizedBox(height: AppSpacing.sm),
            AppFormField(label: 'Nama Layanan', hint: 'Contoh: Cuci Komplit Express', controller: _nameCtrl),
            const SizedBox(height: AppSpacing.base),
            ModernSelectField(
              label: 'Kategori',
              hint: 'Pilih Kategori',
              value: _selectedKategori,
              options: const ['Cuci', 'Cuci & Setrika', 'Setrika', 'Spesial'],
              onChanged: (v) => setState(() => _selectedKategori = v),
            ),
            const SizedBox(height: AppSpacing.base),
            _sectionLabel('Harga & Satuan'),
            const SizedBox(height: AppSpacing.sm),
            AppFormField(
              label: 'Harga (Rp)',
              hint: 'Contoh: 15000',
              controller: _hargaCtrl,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.base),
            ModernSelectField(
              label: 'Satuan',
              hint: 'Pilih Satuan',
              value: _selectedSatuan,
              options: const ['kg', 'pcs', 'pasang', 'set'],
              onChanged: (v) => setState(() => _selectedSatuan = v),
            ),
            const SizedBox(height: AppSpacing.base),
            _sectionLabel('Status'),
            const SizedBox(height: AppSpacing.sm),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.button),
                border: Border.all(color: AppColors.divider),
              ),
              child: SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                title: Text('Layanan Aktif', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500)),
                subtitle: Text('Layanan dapat dipilih saat transaksi', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                value: _isActive,
                activeColor: AppColors.primaryRed,
                onChanged: (v) => setState(() => _isActive = v),
              ),
            ),
            const SizedBox(height: AppSpacing.xl * 2),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Row(
            children: [
              Expanded(child: OutlinedButton(onPressed: _saving ? null : () => Navigator.pop(context), child: const Text('Batal'))),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: FilledButton(
                  onPressed: _saving ? null : _submit,
                  child: _saving
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(_isEdit ? 'Simpan Perubahan' : 'Tambah Layanan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary, letterSpacing: 0.3),
    );
  }
}
