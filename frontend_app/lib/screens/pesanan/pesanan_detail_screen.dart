import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/local/database_provider.dart';
import '../../data/repositories/pesanan_repository.dart';
import '../../models/entities.dart';
import '../../services/api_client.dart';
import '../../services/app_api.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_ui_helpers.dart';

class PesananDetailScreen extends StatelessWidget {
  final Pesanan data;

  const PesananDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(data.kode, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primaryRed)),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(data.status, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: AppSpacing.xl),
            _card([
              _row('Pelanggan', data.pelangganName ?? '-'),
              _row('Outlet', data.outletName),
              _row('Layanan', data.layananSummary.isEmpty ? '-' : data.layananSummary),
              _row('Total', formatRupiah(data.total), valueColor: AppColors.primaryRed),
              _row('Pembayaran', data.isLunas ? 'Lunas' : 'Belum Lunas'),
              _row('Tanggal', formatDateTimeLabel(data.createdAt)),
              _row('Estimasi Ambil', formatDateTimeLabel(data.pickupEstimate)),
              _row('Catatan', data.notes ?? '-'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: const Border.fromBorderSide(BorderSide(color: AppColors.divider)),
      ),
      child: Column(children: [
        for (var i = 0; i < children.length; i++) ...[
          children[i],
          if (i < children.length - 1) const Divider(height: 1),
        ],
      ]),
    );
  }

  Widget _row(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: valueColor ?? AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await AppConfirmDialog.show(
      context,
      title: 'Hapus Pesanan?',
      message: '${data.kode} akan dihapus.',
      confirmLabel: 'Hapus',
    );
    if (ok != true || !context.mounted) return;
    try {
      await AppApi().deletePesanan(data.id);
      await PesananRepository(db: DatabaseProvider.instance).deleteLocal(data.id);
      if (!context.mounted) return;
      Navigator.pop(context, true);
      AppToast.show(context, message: 'Pesanan dihapus');
    } on ApiException catch (e) {
      if (!context.mounted) return;
      AppToast.show(context, message: e.message, type: AppToastType.error);
    }
  }
}
