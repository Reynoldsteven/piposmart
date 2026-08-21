import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/local/database_provider.dart';
import '../../data/repositories/pesanan_repository.dart';
import '../../models/entities.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_ui_helpers.dart';
import '../../widgets/modern_select_field.dart';
import 'add_edit_pesanan_screen.dart';
import 'pesanan_detail_screen.dart';

class PesananListScreen extends StatefulWidget {
  const PesananListScreen({super.key});

  @override
  State<PesananListScreen> createState() => _PesananListScreenState();
}

class _PesananListScreenState extends State<PesananListScreen> {
  late final PesananRepository _repo;
  Timer? _debounce;
  String _search = '';
  String? _filterStatus;
  List<Pesanan> _all = [];
  bool _loading = true;
  int _page = 1;
  bool _loadingMore = false;
  StreamSubscription<List<Pesanan>>? _sub;

  static const int _perPage = 10;

  @override
  void initState() {
    super.initState();
    _repo = PesananRepository(db: DatabaseProvider.instance);
    _subscribe();
    _repo.syncIfNeeded();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _sub?.cancel();
    super.dispose();
  }

  void _subscribe() {
    _sub?.cancel();
    if (_all.isEmpty) {
      setState(() => _loading = true);
    }
    _sub = _repo.watchAll(query: _search, status: _filterStatus).listen(
      (items) {
        if (!mounted) return;
        setState(() {
          _all = items;
          _loading = false;
          final maxPage = ((_all.length + _perPage - 1) / _perPage).floor().clamp(1, 9999);
          if (_page > maxPage) _page = maxPage;
        });
      },
      onError: (_) {
        if (!mounted) return;
        setState(() => _loading = false);
      },
    );
  }

  List<Pesanan> get _pageItems {
    final start = (_page - 1) * _perPage;
    if (start >= _all.length) return const [];
    final end = (start + _perPage).clamp(0, _all.length);
    return _all.sublist(start, end);
  }

  int get _totalPages {
    if (_all.isEmpty) return 1;
    return ((_all.length + _perPage - 1) / _perPage).ceil();
  }

  Future<void> _refresh() async {
    _page = 1;
    await _repo.refresh();
  }

  Future<void> _ensurePageSynced(int page) async {
    if (_loadingMore) return;
    _loadingMore = true;
    await _repo.loadMore(page);
    _loadingMore = false;
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Baru':
        return AppColors.primaryRed;
      case 'Diproses':
        return AppColors.warning;
      case 'Siap Diambil':
        return AppColors.success;
      case 'Selesai':
        return AppColors.textSecondary;
      case 'Dibatalkan':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _pageItems;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Daftar Pesanan')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.base, AppSpacing.sm, AppSpacing.base, 0),
            child: AppSearchBar(
              hint: 'Cari kode / pelanggan...',
              onChanged: (v) {
                _search = v;
                _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 300), () {
                  _page = 1;
                  _subscribe();
                });
              },
              trailing: ModernFilterIcon(
                value: _filterStatus,
                options: const ['Baru', 'Diproses', 'Siap Diambil', 'Selesai', 'Dibatalkan'],
                onChanged: (val) {
                  setState(() {
                    _filterStatus = val;
                    _page = 1;
                  });
                  _subscribe();
                },
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(child: _buildBody(items)),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FloatingActionButton.extended(
                          onPressed: () async {
                            final ok = await Navigator.push<bool>(
                              context,
                              CupertinoPageRoute(builder: (_) => const AddEditPesananScreen()),
                            );
                            if (ok == true) await _refresh();
                          },
                          backgroundColor: AppColors.primaryRed,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
                          label: Text('Buat Pesanan', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12)),
                        ),
                        if (!_loading && _all.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          AppPagination(
                            floating: true,
                            currentPage: _page,
                            totalPages: _totalPages,
                            totalItems: _all.length,
                            itemsPerPage: _perPage,
                            onPageChanged: (page) async {
                              setState(() => _page = page);
                              // Fetch server hanya jika cache lokal belum cukup.
                              if (_all.length < page * _perPage) {
                                await _ensurePageSynced(page);
                              }
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(List<Pesanan> items) {
    if (_loading && _all.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primaryRed));
    }
    if (_all.isEmpty) {
      return const AppEmptyState(
        icon: Icons.shopping_bag_outlined,
        title: 'Belum ada pesanan',
        message: 'Buat pesanan atau tarik untuk sync dari server.',
      );
    }

    return RefreshIndicator(
      color: AppColors.primaryRed,
      onRefresh: _refresh,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(AppSpacing.base, AppSpacing.sm, AppSpacing.base, 120),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, i) {
          final item = items[i];
          return InkWell(
            onTap: () async {
              final changed = await Navigator.push<bool>(
                context,
                CupertinoPageRoute(builder: (_) => PesananDetailScreen(data: item)),
              );
              if (changed == true) await _refresh();
            },
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.base),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: const Border.fromBorderSide(BorderSide(color: AppColors.divider)),
                boxShadow: AppElevation.card,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(item.kode, style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppColors.primaryRed, fontSize: 13)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _statusColor(item.status).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(item.status, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: _statusColor(item.status))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(item.pelangganName ?? 'Tanpa pelanggan', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(
                    item.layananSummary.isEmpty ? item.outletName : item.layananSummary,
                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(formatDateLabel(item.createdAt), style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                      const Spacer(),
                      Text(formatRupiah(item.total), style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
