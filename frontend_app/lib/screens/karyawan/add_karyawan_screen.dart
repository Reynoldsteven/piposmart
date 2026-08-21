import 'package:flutter/material.dart';
import '../../data/local/database_provider.dart';
import '../../data/repositories/karyawan_repository.dart';
import '../../services/api_client.dart';
import '../../services/app_api.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_ui_helpers.dart';
import '../../widgets/modern_select_field.dart';

class AddKaryawanScreen extends StatefulWidget {
  const AddKaryawanScreen({super.key});

  @override
  State<AddKaryawanScreen> createState() => _AddKaryawanScreenState();
}

class _AddKaryawanScreenState extends State<AddKaryawanScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _joinDateCtrl = TextEditingController();
  String? _selectedRole;
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _joinDateCtrl.dispose();
    super.dispose();
  }

  String? _mapRole(String? uiRole) {
    switch (uiRole) {
      case 'Owner':
        return 'owner';
      case 'Admin / Kasir':
        return 'kasir';
      case 'Bagian Produksi / Cuci':
        return 'produksi';
      default:
        return null;
    }
  }

  Future<void> _save() async {
    final role = _mapRole(_selectedRole);
    if (_nameCtrl.text.trim().isEmpty || _emailCtrl.text.trim().isEmpty || _passwordCtrl.text.isEmpty || role == null) {
      AppToast.show(context, message: 'Lengkapi nama, email, password, dan role', type: AppToastType.error);
      return;
    }
    setState(() => _saving = true);
    try {
      final created = await AppApi().createKaryawan({
        'name': _nameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'password': _passwordCtrl.text,
        'phone': _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
        'role': role,
        'join_date': _joinDateCtrl.text.trim().isEmpty ? null : _joinDateCtrl.text.trim(),
        'outlet_ids': <int>[],
      });
      await KaryawanRepository(db: DatabaseProvider.instance).upsertLocal(created);
      if (!mounted) return;
      Navigator.pop(context, true);
      AppToast.show(context, message: 'Karyawan berhasil ditambahkan');
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
      appBar: AppBar(title: const Text('Tambah Karyawan Baru')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.base),
        children: [
          AppFormField(label: 'Nama Karyawan', hint: 'Masukkan nama lengkap', controller: _nameCtrl),
          const SizedBox(height: AppSpacing.base),
          AppFormField(label: 'No. Telp / WhatsApp', hint: 'Contoh: 081234567890', controller: _phoneCtrl, keyboardType: TextInputType.phone),
          const SizedBox(height: AppSpacing.base),
          AppFormField(label: 'Email', hint: 'Contoh: budi@gmail.com', controller: _emailCtrl, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: AppSpacing.base),
          AppFormField(label: 'Password', hint: 'Masukkan password akun', controller: _passwordCtrl, obscureText: true),
          const SizedBox(height: AppSpacing.base),
          AppFormField(label: 'Tanggal Masuk', hint: 'YYYY-MM-DD', controller: _joinDateCtrl),
          const SizedBox(height: AppSpacing.base),
          ModernSelectField(
            label: 'Role (Akses)',
            hint: 'Pilih Role',
            value: _selectedRole,
            options: const ['Admin / Kasir', 'Owner', 'Bagian Produksi / Cuci'],
            onChanged: (val) => setState(() => _selectedRole = val),
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Simpan Karyawan'),
          ),
        ],
      ),
    );
  }
}
