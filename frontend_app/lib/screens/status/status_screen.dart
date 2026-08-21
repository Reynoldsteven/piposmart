import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/api_client.dart';
import '../../services/app_api.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_ui_helpers.dart';
import 'widgets/status_card.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final _api = AppApi();
  bool _loading = true;
  String? _error;
  int _selesai = 0;
  int _terlambat = 0;
  int _harusSelesai = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final summary = await _api.statusSummary();
      if (!mounted) return;
      setState(() {
        _selesai = summary.selesai;
        _terlambat = summary.terlambat;
        _harusSelesai = summary.harusSelesai;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Gagal memuat status';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cards = [
      StatusCardData(
        title: 'Selesai',
        subtitle: 'Pesanan dengan status selesai',
        count: _selesai,
        icon: Icons.check_circle_outline_rounded,
        color: AppColors.success,
        bgColor: AppColors.successLight,
      ),
      StatusCardData(
        title: 'Terlambat',
        subtitle: 'Melewati estimasi pengambilan',
        count: _terlambat,
        icon: Icons.warning_amber_rounded,
        color: AppColors.error,
        bgColor: AppColors.errorLight,
      ),
      StatusCardData(
        title: 'Harus Selesai',
        subtitle: 'Harus diselesaikan hari ini',
        count: _harusSelesai,
        icon: Icons.pending_actions_rounded,
        color: AppColors.warning,
        bgColor: AppColors.warningLight,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Status Orderan')),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryRed))
          : _error != null
              ? AppEmptyState(
                  icon: Icons.wifi_off_rounded,
                  title: 'Gagal memuat',
                  message: _error!,
                  actionLabel: 'Coba Lagi',
                  onAction: _load,
                )
              : RefreshIndicator(
                  color: AppColors.primaryRed,
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.lg),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: AppSpacing.sm),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ringkasan Pesanan', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text('Data dari database', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      ...cards.map((c) => StatusCard(data: c)),
                    ],
                  ),
                ),
    );
  }
}
