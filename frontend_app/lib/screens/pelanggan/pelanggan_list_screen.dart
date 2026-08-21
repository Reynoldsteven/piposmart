import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/local/database_provider.dart';
import '../../data/repositories/pelanggan_repository.dart';
import '../../models/entities.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_ui_helpers.dart';
import '../../widgets/modern_select_field.dart';
import 'add_pelanggan_screen.dart';
import 'pelanggan_detail_screen.dart';

class PelangganListScreen extends StatefulWidget {
  const PelangganListScreen({super.key});

  @override
  State<PelangganListScreen> createState() => _PelangganListScreenState();
}

class _PelangganListScreenState extends State<PelangganListScreen> {
  late final PelangganRepository _repo;
  Timer? _debounce;
  String _search = '';
  String? _genderFilter;
  int _page = 1;
  StreamSubscription<List<Pelanggan>>? _sub;
  List<Pelanggan> _items = [];
  bool _loading = true;

  bool _loadingMore = false;

  @override
  void initState() {
    super.initState();
    _repo = PelangganRepository(db: DatabaseProvider.instance);
    _subscribe();
    // Sync di background; UI pakai cache dulu.
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
    // Spinner hanya jika belum ada data sama sekali.
    if (_items.isEmpty) {
      setState(() => _loading = true);
    }
    _sub = _repo.watchAll(query: _search, gender: _genderFilter).listen(
      (items) {
        if (!mounted) return;
        setState(() {
          _items = items;
          _loading = false;
        });
      },
      onError: (_) {
        if (!mounted) return;
        setState(() => _loading = false);
      },
    );
  }

  Future<void> _refresh() async {
    _page = 1;
    await _repo.refresh();
  }

  Future<void> _loadMore() async {
    if (_loadingMore) return;
    _loadingMore = true;
    _page += 1;
    await _repo.loadMore(_page);
    _loadingMore = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Daftar Pelanggan')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final ok = await Navigator.push<bool>(
            context,
            CupertinoPageRoute(builder: (_) => const AddPelangganScreen()),
          );
          if (ok == true) await _refresh();
        },
        backgroundColor: AppColors.primaryRed,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_rounded),
        label: Text('Tambah Pelanggan', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.base, AppSpacing.sm, AppSpacing.base, 0),
            child: AppSearchBar(
              hint: 'Cari pelanggan...',
              onChanged: (v) {
                _search = v;
                _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 300), () {
                  _page = 1;
                  _subscribe();
                });
              },
              trailing: ModernFilterIcon(
                value: _genderFilter,
                options: const ['Laki-laki', 'Perempuan'],
                onChanged: (val) {
                  setState(() => _genderFilter = val);
                  _page = 1;
                  _subscribe();
                },
              ),
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading && _items.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primaryRed));
    }
    if (_items.isEmpty) {
      return const AppEmptyState(
        icon: Icons.people_outline_rounded,
        title: 'Belum ada pelanggan',
        message: 'Tambahkan pelanggan atau tarik untuk sync dari server.',
      );
    }

    return RefreshIndicator(
      color: AppColors.primaryRed,
      onRefresh: _refresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n.metrics.pixels >= n.metrics.maxScrollExtent - 80) {
            _loadMore();
          }
          return false;
        },
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(AppSpacing.base, AppSpacing.sm, AppSpacing.base, 100),
          itemCount: _items.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final item = _items[index];
            final initial = item.name.isNotEmpty ? item.name[0].toUpperCase() : '?';
            final isMale = item.gender == 'Laki-laki';
            return InkWell(
              onTap: () async {
                final changed = await Navigator.push<bool>(
                  context,
                  CupertinoPageRoute(builder: (_) => PelangganDetailScreen(data: item)),
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
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: isMale ? const Color(0xFFE0E7FF) : const Color(0xFFFCE7F3),
                      child: Text(
                        initial,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          color: isMale ? const Color(0xFF4338CA) : const Color(0xFFBE185D),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.base),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          const SizedBox(height: 2),
                          Text(item.phone ?? '-', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
