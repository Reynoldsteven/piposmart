import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class EditPelangganScreen extends StatefulWidget {
  const EditPelangganScreen({super.key});

  @override
  State<EditPelangganScreen> createState() => _EditPelangganScreenState();
}

class _EditPelangganScreenState extends State<EditPelangganScreen> {
  String _selectedGender = 'Laki-laki';
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Andi Susanto');
    _phoneController = TextEditingController(text: '0812-3456-7890');
    _addressController = TextEditingController(
      text: 'Jl. Sudirman No. 10, Jakarta Pusat\nRT 01 / RW 02, Kode Pos 10220',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pelanggan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.base),
        children: [
          _buildTextField('Nama Pelanggan', controller: _nameController),
          const SizedBox(height: AppSpacing.base),
          _buildTextField('No. Telp / WhatsApp', controller: _phoneController),
          const SizedBox(height: AppSpacing.base),
          _buildTextField('Alamat Rumah', controller: _addressController, maxLines: 3),
          const SizedBox(height: AppSpacing.base),
          
          Text(
            'Gender',
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(child: _buildGenderOption('Laki-laki', Icons.male_rounded)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _buildGenderOption('Perempuan', Icons.female_rounded)),
            ],
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

  Widget _buildGenderOption(String label, IconData icon) {
    final isSelected = _selectedGender == label;
    return InkWell(
      onTap: () => setState(() => _selectedGender = label),
      borderRadius: BorderRadius.circular(AppRadius.button),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightRed : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.button),
          border: Border.all(color: isSelected ? AppColors.primaryRed : AppColors.divider),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: isSelected ? AppColors.primaryRed : AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primaryRed : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {required TextEditingController controller, int maxLines = 1}) {
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
          maxLines: maxLines,
          decoration: const InputDecoration(),
        ),
      ],
    );
  }
}
