import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/entities.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_client.dart';
import '../../services/app_api.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/finance_summary_card.dart';
import 'widgets/menu_grid.dart';
import '../outlet/outlet_list_screen.dart';
import '../karyawan/karyawan_list_screen.dart';
import '../pelanggan/pelanggan_list_screen.dart';
import '../layanan/layanan_list_screen.dart';
import '../pesanan/pesanan_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardTab _tab = DashboardTab.keuangan;
  final _api = AppApi();
  DashboardSummary? _summary;
  List<Outlet> _outlets = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final summary = await _api.dashboardSummary();
      final outlets = await _api.listOutlets(limit: 20);
      if (!mounted) return;
      setState(() {
        _summary = summary;
        _outlets = outlets.items;
        _loading = false;
      });
    } on ApiException {
      if (!mounted) return;
      setState(() => _loading = false);
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  String _roleLabel(String role) {
    switch (role.toLowerCase()) {
      case 'owner':
        return 'Owner';
      case 'kasir':
        return 'Kasir';
      case 'produksi':
        return 'Produksi';
      default:
        return role;
    }
  }

  List<FinanceStat> get _financeStats {
    final s = _summary;
    return [
      FinanceStat(
        label: 'Laba',
        value: formatRupiah(s?.labaHariIni ?? 0),
        icon: Icons.payments_outlined,
        iconColor: AppColors.primaryRed,
        bgColor: AppColors.surface,
      ),
      FinanceStat(
        label: 'Penjualan',
        value: '${s?.penjualanHariIni ?? 0} Trx',
        icon: Icons.show_chart_rounded,
        iconColor: AppColors.textPrimary,
        bgColor: AppColors.surface,
      ),
      FinanceStat(
        label: 'Pengeluaran',
        value: formatRupiah(s?.pengeluaranHariIni ?? 0),
        icon: Icons.trending_down_rounded,
        iconColor: AppColors.textPrimary,
        bgColor: AppColors.surface,
      ),
      FinanceStat(
        label: 'Pesanan Aktif',
        value: '${s?.pesananAktif ?? 0}',
        icon: Icons.local_laundry_service_outlined,
        iconColor: AppColors.textPrimary,
        bgColor: AppColors.surface,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final outletName = _outlets.isNotEmpty ? _outlets.first.name : 'Semua Outlet';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: RefreshIndicator(
          color: AppColors.primaryRed,
          onRefresh: _load,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DashboardHeader(
                  userName: user?.name ?? 'Pengguna',
                  role: _roleLabel(user?.role ?? ''),
                  outletName: outletName,
                  notificationCount: 0,
                ),
                if (_loading)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator(color: AppColors.primaryRed)),
                  )
                else
                  FinanceSummaryCard(
                    selectedTab: _tab,
                    onTabChanged: (t) => setState(() => _tab = t),
                    stats: _financeStats,
                  ),
                MenuGrid(
                  items: [
                    MenuItemData(
                      label: 'Pesanan',
                      icon: Icons.shopping_bag_outlined,
                      color: AppColors.primaryRed,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PesananListScreen())),
                    ),
                    MenuItemData(
                      label: 'Layanan',
                      icon: Icons.local_laundry_service_outlined,
                      color: AppColors.textPrimary,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LayananListScreen())),
                    ),
                    MenuItemData(
                      label: 'Pelanggan',
                      icon: Icons.people_outline_rounded,
                      color: AppColors.textPrimary,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PelangganListScreen())),
                    ),
                    MenuItemData(
                      label: 'Karyawan',
                      icon: Icons.badge_outlined,
                      color: AppColors.textPrimary,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KaryawanListScreen())),
                    ),
                    MenuItemData(
                      label: 'Tambah Outlet',
                      icon: Icons.add_business_outlined,
                      color: AppColors.textPrimary,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OutletListScreen())),
                    ),
                    MenuItemData(label: 'Pengeluaran', icon: Icons.money_off_rounded, color: AppColors.textPrimary),
                    MenuItemData(label: 'Laporan', icon: Icons.bar_chart_rounded, color: AppColors.textPrimary),
                    MenuItemData(label: 'Semua', icon: Icons.apps_rounded, color: AppColors.textSecondary),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
