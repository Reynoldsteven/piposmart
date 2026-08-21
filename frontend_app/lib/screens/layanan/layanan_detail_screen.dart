import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/entities.dart';
import '../../services/api_client.dart';
import '../../services/app_api.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_ui_helpers.dart';
import 'add_edit_layanan_screen.dart';

class LayananDetailScreen extends StatelessWidget {
  final Layanan data;

  const LayananDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isActive = data.isActive;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detail Layanan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Layanan',
            onPressed: () async {
              final changed = await Navigator.push<bool>(
                context,
                CupertinoPageRoute(builder: (_) => AddEditLayananScreen(data: data)),
              );
              if (changed == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
            tooltip: 'Hapus Layanan',
            onPressed: () => _confirmDelete(context),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.lightRed,
                  borderRadius: BorderRadius.circular(AppRadius.cardLarge),
                ),
                child: const Icon(Icons.local_laundry_service_outlined, size: 40, color: AppColors.primaryRed),
              ),
            ),
            const SizedBox(height: AppSpacing.base),
            Center(
              child: Text(
                data.name,
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.successLight : AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isActive ? AppColors.success.withValues(alpha: 0.3) : AppColors.divider),
                ),
                child: Text(
                  data.statusLabel,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isActive ? AppColors.success : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: const Border.fromBorderSide(BorderSide(color: AppColors.divider)),
                boxShadow: AppElevation.card,
              ),
              child: Column(
                children: [
                  _infoRow('Kode', data.kode),
                  const Divider(height: 1, color: AppColors.divider),
                  _infoRow('Kategori', data.kategori),
                  const Divider(height: 1, color: AppColors.divider),
                  _infoRow('Harga', '${formatRupiah(data.harga)} / ${data.satuan}', valueColor: AppColors.primaryRed),
                  const Divider(height: 1, color: AppColors.divider),
                  _infoRow('Satuan', data.satuan),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary)),
          Text(
            value,
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: valueColor ?? AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await AppConfirmDialog.show(
      context,
      title: 'Hapus Layanan?',
      message: '"${data.name}" akan dihapus secara permanen.',
      confirmLabel: 'Hapus',
    );
    if (ok != true || !context.mounted) return;

    try {
      await AppApi().deleteLayanan(data.id);
      if (!context.mounted) return;
      Navigator.pop(context, true);
      AppToast.show(context, message: 'Layanan berhasil dihapus');
    } on ApiException catch (e) {
      if (!context.mounted) return;
      AppToast.show(context, message: e.message, type: AppToastType.error);
    } catch (_) {
      if (!context.mounted) return;
      AppToast.show(context, message: 'Gagal menghapus layanan', type: AppToastType.error);
    }
  }
}
