import 'package:flutter/material.dart';
import '../../services/api_client.dart';
import '../../services/app_api.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_ui_helpers.dart';
import '../../widgets/modern_select_field.dart';

class AddOutletScreen extends StatefulWidget {
  const AddOutletScreen({super.key});

  @override
  State<AddOutletScreen> createState() => _AddOutletScreenState();
}

class _AddOutletScreenState extends State<AddOutletScreen> {
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  String? _selectedProvinsi;
  String? _selectedKota;
  String? _selectedKecamatan;
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      AppToast.show(context, message: 'Nama outlet wajib diisi', type: AppToastType.error);
      return;
    }
    setState(() => _saving = true);
    try {
      await AppApi().createOutlet({
        'name': _nameCtrl.text.trim(),
        'address': _addressCtrl.text.trim().isEmpty ? null : _addressCtrl.text.trim(),
        'provinsi': _selectedProvinsi,
        'kota': _selectedKota,
        'kecamatan': _selectedKecamatan,
      });
      if (!mounted) return;
      Navigator.pop(context, true);
      AppToast.show(context, message: 'Outlet berhasil ditambahkan');
    } on ApiException catch (e) {
      if (!mounted) return;
      AppToast.show(context, message: e.message, type: AppToastType.error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Tambah Outlet Baru')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.base),
        children: [
          AppFormField(label: 'Nama Outlet', hint: 'Contoh: Mewing Laundry Cab. 2', controller: _nameCtrl),
          const SizedBox(height: AppSpacing.base),
          AppFormField(label: 'Alamat Lengkap', hint: 'Contoh: Jl. Sudirman No. 10', controller: _addressCtrl, maxLines: 3),
          const SizedBox(height: AppSpacing.base),
          ModernSelectField(
            label: 'Provinsi',
            hint: 'Pilih Provinsi',
            value: _selectedProvinsi,
            options: const ['DKI Jakarta', 'Jawa Barat', 'Jawa Tengah', 'Jawa Timur', 'Kepulauan Riau', 'Sulawesi Tengah'],
            onChanged: (val) => setState(() => _selectedProvinsi = val),
          ),
          const SizedBox(height: AppSpacing.base),
          ModernSelectField(
            label: 'Kota / Kabupaten',
            hint: 'Pilih Kota / Kabupaten',
            value: _selectedKota,
            options: const ['Jakarta Pusat', 'Bandung', 'Semarang', 'Surabaya', 'Batam', 'Palu'],
            onChanged: (val) => setState(() => _selectedKota = val),
          ),
          const SizedBox(height: AppSpacing.base),
          ModernSelectField(
            label: 'Kecamatan',
            hint: 'Pilih Kecamatan',
            value: _selectedKecamatan,
            options: const ['Gambir', 'Coblong', 'Gajahmungkur', 'Gubeng', 'Lubuk Baja', 'Sagulung', 'Palu Selatan'],
            onChanged: (val) => setState(() => _selectedKecamatan = val),
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Simpan Outlet'),
          ),
        ],
      ),
    );
  }
}
