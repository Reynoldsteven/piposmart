import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/local/database_provider.dart';
import '../../data/repositories/karyawan_repository.dart';
import '../../models/entities.dart';
import '../../services/api_client.dart';
import '../../services/app_api.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_ui_helpers.dart';

class KaryawanDetailScreen extends StatelessWidget {
  final Karyawan data;

  const KaryawanDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detail Karyawan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
            onPressed: () async {
              final ok = await AppConfirmDialog.show(
                context,
                title: 'Hapus Karyawan?',
                message: '"${data.name}" akan dihapus.',
                confirmLabel: 'Hapus',
              );
              if (ok != true || !context.mounted) return;
              try {
                await AppApi().deleteKaryawan(data.id);
                await KaryawanRepository(db: DatabaseProvider.instance).deleteLocal(data.id);
                if (!context.mounted) return;
                Navigator.pop(context, true);
                AppToast.show(context, message: 'Karyawan dihapus');
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
          _row('Nama Karyawan', data.name),
          const Divider(height: 24),
          _row('No. Telp', data.phone ?? '-'),
          const Divider(height: 24),
          _row('Email', data.email),
          const Divider(height: 24),
          _row('Role', data.role),
          const Divider(height: 24),
          _row('Outlet', data.outletNames.isEmpty ? '-' : data.outletNames.join(', ')),
          const Divider(height: 24),
          _row('Tanggal Masuk', data.joinDate ?? '-'),
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
