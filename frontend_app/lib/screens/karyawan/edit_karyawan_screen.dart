import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../widgets/modern_select_field.dart';

class EditKaryawanScreen extends StatefulWidget {
  const EditKaryawanScreen({super.key});

  @override
  State<EditKaryawanScreen> createState() => _EditKaryawanScreenState();
}

class _EditKaryawanScreenState extends State<EditKaryawanScreen> {
  String? _selectedRole = 'Admin / Kasir';
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Budi Santoso');
    _phoneController = TextEditingController(text: '0812-3456-7890');
    _emailController = TextEditingController(text: 'budi@gmail.com');
    _dateController = TextEditingController(text: '01 Agustus 2025');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Karyawan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.base),
        children: [
          _buildTextField('Nama Karyawan', controller: _nameController),
          const SizedBox(height: AppSpacing.base),
          _buildTextField('No. Telp / WhatsApp', controller: _phoneController),
          const SizedBox(height: AppSpacing.base),
          _buildTextField('Email', controller: _emailController),
          const SizedBox(height: AppSpacing.base),
          _buildTextField('Password', hint: 'Kosongkan jika tidak ingin mengubah', obscureText: true),
          const SizedBox(height: AppSpacing.base),
          _buildTextField('Tanggal Masuk', controller: _dateController, icon: Icons.calendar_today_rounded),
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Simpan Perubahan'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, {TextEditingController? controller, String? hint, bool obscureText = false, IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: icon != null ? Icon(icon, color: AppColors.textSecondary, size: 20) : null,
          ),
        ),
      ],
    );
  }
}
