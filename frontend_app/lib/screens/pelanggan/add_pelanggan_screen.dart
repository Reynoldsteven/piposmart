import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/local/database_provider.dart';
import '../../data/repositories/pelanggan_repository.dart';
import '../../services/api_client.dart';
import '../../services/app_api.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_ui_helpers.dart';

class AddPelangganScreen extends StatefulWidget {
  const AddPelangganScreen({super.key});

  @override
  State<AddPelangganScreen> createState() => _AddPelangganScreenState();
}

class _AddPelangganScreenState extends State<AddPelangganScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  String _selectedGender = 'Laki-laki';
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      AppToast.show(context, message: 'Nama wajib diisi', type: AppToastType.error);
      return;
    }
    setState(() => _saving = true);
    try {
      final created = await AppApi().createPelanggan({
        'name': _nameCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
        'address': _addressCtrl.text.trim().isEmpty ? null : _addressCtrl.text.trim(),
        'gender': _selectedGender,
      });
      await PelangganRepository(db: DatabaseProvider.instance).upsertLocal(created);
      if (!mounted) return;
      Navigator.pop(context, true);
      AppToast.show(context, message: 'Pelanggan berhasil ditambahkan');
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
      appBar: AppBar(title: const Text('Tambah Pelanggan')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.base),
        children: [
          AppFormField(label: 'Nama Pelanggan', hint: 'Masukkan nama lengkap', controller: _nameCtrl),
          const SizedBox(height: AppSpacing.base),
          AppFormField(label: 'No. Telp / WhatsApp', hint: 'Contoh: 081234567890', controller: _phoneCtrl, keyboardType: TextInputType.phone),
          const SizedBox(height: AppSpacing.base),
          AppFormField(label: 'Alamat Rumah', hint: 'Masukkan alamat lengkap', controller: _addressCtrl, maxLines: 3),
          const SizedBox(height: AppSpacing.base),
          Text('Gender', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(child: _genderOption('Laki-laki', Icons.male_rounded)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _genderOption('Perempuan', Icons.female_rounded)),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Widget _genderOption(String label, IconData icon) {
    final selected = _selectedGender == label;
    return InkWell(
      onTap: () => setState(() => _selectedGender = label),
      borderRadius: BorderRadius.circular(AppRadius.control),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.lightRed : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.control),
          border: Border.all(color: selected ? AppColors.primaryRed : AppColors.divider),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: selected ? AppColors.primaryRed : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: selected ? AppColors.primaryRed : AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
