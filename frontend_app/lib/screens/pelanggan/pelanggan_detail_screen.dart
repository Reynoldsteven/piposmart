import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/local/database_provider.dart';
import '../../data/repositories/pelanggan_repository.dart';
import '../../models/entities.dart';
import '../../services/api_client.dart';
import '../../services/app_api.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_ui_helpers.dart';

class PelangganDetailScreen extends StatelessWidget {
  final Pelanggan data;

  const PelangganDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detail Pelanggan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
            onPressed: () async {
              final ok = await AppConfirmDialog.show(
                context,
                title: 'Hapus Pelanggan?',
                message: '"${data.name}" akan dihapus.',
                confirmLabel: 'Hapus',
              );
              if (ok != true || !context.mounted) return;
              try {
                await AppApi().deletePelanggan(data.id);
                await PelangganRepository(db: DatabaseProvider.instance).deleteLocal(data.id);
                if (!context.mounted) return;
                Navigator.pop(context, true);
                AppToast.show(context, message: 'Pelanggan dihapus');
              } on ApiException catch (e) {
                if (!context.mounted) return;
                AppToast.show(context, message: e.message, type: AppToastType.error);
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.base),
        children: [
          _row('Nama Pelanggan', data.name),
          const Divider(height: 24),
          _row('No. Telp / WhatsApp', data.phone ?? '-'),
          const Divider(height: 24),
          _row('Gender', data.gender ?? '-'),
          const Divider(height: 24),
          _row('Alamat', data.address ?? '-'),
          const Divider(height: 24),
          _row('Outlet', data.outletName ?? '-'),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
