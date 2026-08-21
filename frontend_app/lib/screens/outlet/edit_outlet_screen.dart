import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../widgets/modern_select_field.dart';

class EditOutletScreen extends StatefulWidget {
  const EditOutletScreen({super.key});

  @override
  State<EditOutletScreen> createState() => _EditOutletScreenState();
}

class _EditOutletScreenState extends State<EditOutletScreen> {
  String? _selectedProvinsi = 'Kepulauan Riau';
  String? _selectedKota = 'Batam';
  String? _selectedKecamatan = 'Lubuk Baja';
  
  late TextEditingController _nameController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Mewing Laundry · Nagoya');
    _addressController = TextEditingController(text: 'Jl. Nagoya Hill No. 12');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Outlet'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.base),
        children: [
          _buildTextField('Nama Outlet', controller: _nameController),
          const SizedBox(height: AppSpacing.base),
          _buildTextField('Alamat Lengkap', controller: _addressController, maxLines: 3),
          const SizedBox(height: AppSpacing.base),
          
          ModernSelectField(
            label: 'Provinsi',
            hint: 'Pilih Provinsi',
            value: _selectedProvinsi,
            options: const ['DKI Jakarta', 'Jawa Barat', 'Jawa Tengah', 'Jawa Timur', 'Kepulauan Riau'],
            onChanged: (val) => setState(() => _selectedProvinsi = val),
          ),
          const SizedBox(height: AppSpacing.base),
          
          ModernSelectField(
            label: 'Kota / Kabupaten',
            hint: 'Pilih Kota / Kabupaten',
            value: _selectedKota,
            options: const ['Jakarta Pusat', 'Bandung', 'Semarang', 'Surabaya', 'Batam'],
            onChanged: (val) => setState(() => _selectedKota = val),
          ),
          const SizedBox(height: AppSpacing.base),
          
          ModernSelectField(
            label: 'Kecamatan',
            hint: 'Pilih Kecamatan',
            value: _selectedKecamatan,
            options: const ['Gambir', 'Coblong', 'Gajahmungkur', 'Gubeng', 'Lubuk Baja'],
            onChanged: (val) => setState(() => _selectedKecamatan = val),
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
