import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_ui_helpers.dart';
import '../../widgets/modern_select_field.dart';

class ProfilSayaScreen extends StatefulWidget {
  const ProfilSayaScreen({super.key});

  @override
  State<ProfilSayaScreen> createState() => _ProfilSayaScreenState();
}

class _ProfilSayaScreenState extends State<ProfilSayaScreen> {
  final _nameController = TextEditingController(text: 'Mario Wicaksono');
  final _phoneController = TextEditingController(text: '0812-3456-7890');
  final _emailController = TextEditingController(text: 'mario@mewinglaundry.com');

  String _selectedRole = 'Owner';
  String? _nameError;
  String? _phoneError;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool _validate() {
    bool ok = true;
    String? nameErr;
    String? phoneErr;

    final name = _nameController.text.trim();
    if (name.isEmpty) {
      nameErr = 'Nama tidak boleh kosong';
      ok = false;
    }

    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      phoneErr = 'No. Telepon tidak boleh kosong';
      ok = false;
    } else if (phone.length < 9) {
      phoneErr = 'No. Telepon tidak valid';
      ok = false;
    }

    setState(() {
      _nameError = nameErr;
      _phoneError = phoneErr;
    });

    return ok;
  }

  Future<void> _save() async {
    if (!_validate()) return;
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isSaving = false);
    AppToast.show(context, message: 'Profil berhasil diperbarui');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.base),
        children: [
          // ── Avatar ──────────────────────────────────────────────────────────
          Center(
            child: Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.lightRed,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.primaryRed.withValues(alpha: 0.3),
                        width: 2),
                  ),
                  child: const Icon(Icons.person_rounded,
                      size: 40, color: AppColors.primaryRed),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryRed,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit_rounded,
                        size: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),
          const Divider(),
          const SizedBox(height: AppSpacing.base),

          // ── Nama ────────────────────────────────────────────────────────────
          AppFormField(
            label: 'Nama Lengkap',
            hint: 'Masukkan nama lengkap',
            controller: _nameController,
            prefixIcon: Icons.person_outline_rounded,
            errorText: _nameError,
            onChanged: (_) => setState(() => _nameError = null),
          ),
          const SizedBox(height: AppSpacing.base),

          // ── No. Telepon ─────────────────────────────────────────────────────
          AppFormField(
            label: 'No. Telepon / WhatsApp',
            hint: 'Contoh: 081234567890',
            controller: _phoneController,
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            errorText: _phoneError,
            onChanged: (_) => setState(() => _phoneError = null),
          ),
          const SizedBox(height: AppSpacing.base),

          // ── Email — read only (grey, no label/badge) ─────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.email_outlined,
                        size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: 10),
                    Text(
                      _emailController.text,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.base),

          // ── Role ─────────────────────────────────────────────────────────
          ModernSelectField(
            label: 'Role (Akses)',
            hint: 'Pilih Role',
            value: _selectedRole,
            options: const ['Owner', 'Admin / Kasir', 'Bagian Produksi / Cuci'],
            onChanged: (val) => setState(() => _selectedRole = val),
          ),

          const SizedBox(height: AppSpacing.xl),

          // ── Tombol Simpan ────────────────────────────────────────────────
          FilledButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Simpan Perubahan'),
          ),
        ],
      ),
    );
  }
}
