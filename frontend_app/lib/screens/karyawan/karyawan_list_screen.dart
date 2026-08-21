import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/local/database_provider.dart';
import '../../data/repositories/karyawan_repository.dart';
import '../../models/entities.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_ui_helpers.dart';
import '../../widgets/modern_select_field.dart';
import 'add_karyawan_screen.dart';
import 'karyawan_detail_screen.dart';

class KaryawanListScreen extends StatefulWidget {
  const KaryawanListScreen({super.key});

  @override
  State<KaryawanListScreen> createState() => _KaryawanListScreenState();
}

class _KaryawanListScreenState extends State<KaryawanListScreen> {
  late final KaryawanRepository _repo;
  Timer? _debounce;
  String _search = '';
  String? _roleFilter;
  int _page = 1;
  bool _loadingMore = false;
  StreamSubscription<List<Karyawan>>? _sub;
  List<Karyawan> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _repo = KaryawanRepository(db: DatabaseProvider.instance);
    _subscribe();
    _repo.syncIfNeeded();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _sub?.cancel();
    super.dispose();
  }

  String? get _roleApi {
    switch (_roleFilter) {
      case 'Owner':
        return 'owner';
      case 'Kasir':
        return 'kasir';
      case 'Produksi':
        return 'produksi';
      default:
        return null;
    }
  }

  void _subscribe() {
    _sub?.cancel();
    if (_items.isEmpty) {
      setState(() => _loading = true);
    }
    _sub = _repo.watchAll(query: _search, role: _roleApi).listen(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Daftar Karyawan')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final ok = await Navigator.push<bool>(
            context,
            CupertinoPageRoute(builder: (_) => const AddKaryawanScreen()),
          );
          if (ok == true) await _refresh();
        },
        backgroundColor: AppColors.primaryRed,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_rounded),
        label: Text('Tambah Karyawan', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.base, AppSpacing.sm, AppSpacing.base, 0),
            child: AppSearchBar(
              hint: 'Cari karyawan...',
              onChanged: (v) {
                _search = v;
                _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 300), () {
                  _page = 1;
                  _subscribe();
                });
              },
              trailing: ModernFilterIcon(
                value: _roleFilter,
                options: const ['Owner', 'Kasir', 'Produksi'],
                onChanged: (val) {
                  setState(() => _roleFilter = val);
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
        icon: Icons.badge_outlined,
        title: 'Belum ada karyawan',
        message: 'Tambahkan karyawan atau tarik untuk sync dari server.',
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
            return InkWell(
              onTap: () async {
                final changed = await Navigator.push<bool>(
                  context,
                  CupertinoPageRoute(builder: (_) => KaryawanDetailScreen(data: item)),
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
                      backgroundColor: AppColors.lightRed,
                      child: Text(initial, style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppColors.primaryRed)),
                    ),
                    const SizedBox(width: AppSpacing.base),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text('${_roleLabel(item.role)} · ${item.email}', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
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
