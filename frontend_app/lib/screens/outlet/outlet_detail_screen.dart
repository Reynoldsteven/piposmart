import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/entities.dart';
import '../../services/api_client.dart';
import '../../services/app_api.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_ui_helpers.dart';

class OutletDetailScreen extends StatelessWidget {
  final Outlet data;

  const OutletDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detail Outlet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
            onPressed: () async {
              final ok = await AppConfirmDialog.show(
                context,
                title: 'Hapus Outlet?',
                message: '"${data.name}" akan dihapus.',
                confirmLabel: 'Hapus',
              );
              if (ok != true || !context.mounted) return;
              try {
                await AppApi().deleteOutlet(data.id);
                if (!context.mounted) return;
                Navigator.pop(context, true);
                AppToast.show(context, message: 'Outlet dihapus');
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
          _row('Nama Outlet', data.name),
          const Divider(height: 24),
          _row('Alamat Lengkap', data.address ?? '-'),
          const Divider(height: 24),
          _row('Provinsi', data.provinsi ?? '-'),
          const Divider(height: 24),
          _row('Kota', data.kota ?? '-'),
          const Divider(height: 24),
          _row('Kecamatan', data.kecamatan ?? '-'),
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
