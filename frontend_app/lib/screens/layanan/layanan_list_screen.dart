import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/entities.dart';
import '../../services/api_client.dart';
import '../../services/app_api.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_ui_helpers.dart';
import '../../widgets/modern_select_field.dart';
import 'add_edit_layanan_screen.dart';
import 'layanan_detail_screen.dart';

class LayananListScreen extends StatefulWidget {
  const LayananListScreen({super.key});

  @override
  State<LayananListScreen> createState() => _LayananListScreenState();
}

class _LayananListScreenState extends State<LayananListScreen> {
  final _api = AppApi();
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  List<Layanan> _items = [];
  bool _loading = true;
  String? _error;
  String? _filterKategori;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await _api.listLayanan(
        q: _searchCtrl.text.trim(),
        kategori: _filterKategori,
        limit: 100,
      );
      if (!mounted) return;
      setState(() {
        _items = result.items;
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
        _error = 'Gagal memuat layanan';
        _loading = false;
      });
    }
  }

  void _onSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), _load);
  }

  Future<void> _openForm({Layanan? data}) async {
    final changed = await Navigator.push<bool>(
      context,
      CupertinoPageRoute(builder: (_) => AddEditLayananScreen(data: data)),
    );
    if (changed == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Daftar Layanan')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        backgroundColor: AppColors.primaryRed,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text('Tambah Layanan', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.base, AppSpacing.sm, AppSpacing.base, 0),
            child: AppSearchBar(
              hint: 'Cari layanan...',
              controller: _searchCtrl,
              onChanged: _onSearch,
              trailing: ModernFilterIcon(
                value: _filterKategori,
                options: const ['Cuci', 'Cuci & Setrika', 'Setrika', 'Spesial'],
                onChanged: (val) {
                  setState(() => _filterKategori = val);
                  _load();
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primaryRed));
    }
    if (_error != null) {
      return AppEmptyState(
        icon: Icons.wifi_off_rounded,
        title: 'Gagal memuat',
        message: _error!,
        actionLabel: 'Coba Lagi',
        onAction: _load,
      );
    }
    if (_items.isEmpty) {
      return AppEmptyState(
        icon: Icons.local_laundry_service_outlined,
        title: 'Belum ada layanan',
        message: 'Tambahkan layanan laundry pertama Anda.',
        actionLabel: 'Tambah Layanan',
        onAction: () => _openForm(),
      );
    }
    return RefreshIndicator(
      color: AppColors.primaryRed,
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(AppSpacing.base, 0, AppSpacing.base, 100),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, i) {
          final item = _items[i];
          return _LayananCard(
            data: item,
            onTap: () async {
              final changed = await Navigator.push<bool>(
                context,
                CupertinoPageRoute(builder: (_) => LayananDetailScreen(data: item)),
              );
              if (changed == true) _load();
            },
          );
        },
      ),
    );
  }
}

class _LayananCard extends StatelessWidget {
  final Layanan data;
  final VoidCallback onTap;

  const _LayananCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isActive = data.isActive;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: const Border.fromBorderSide(BorderSide(color: AppColors.divider)),
          boxShadow: AppElevation.card,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.lightRed,
                borderRadius: BorderRadius.circular(AppRadius.control),
              ),
              child: const Icon(Icons.local_laundry_service_outlined, color: AppColors.primaryRed, size: 22),
            ),
            const SizedBox(width: AppSpacing.base),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.name, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text('${data.kode} · ${data.kategori}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${formatRupiah(data.harga)}/${data.satuan}',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primaryRed),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.successLight : AppColors.background,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    data.statusLabel,
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: isActive ? AppColors.success : AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
