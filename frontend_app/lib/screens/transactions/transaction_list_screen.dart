import 'dart:async';

import 'package:flutter/material.dart';
import '../../models/entities.dart';
import '../../services/api_client.dart';
import '../../services/app_api.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_ui_helpers.dart';
import 'widgets/transaction_card.dart';
import 'widgets/transaction_filter_bar.dart';

enum _LoadState { loading, loaded, error, empty }

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  final _api = AppApi();
  Timer? _debounce;
  TransactionStatus? _selectedStatus;
  _LoadState _state = _LoadState.loading;
  String _search = '';
  String? _error;
  List<Transaction> _items = [];
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalItems = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  String? _statusQuery() {
    switch (_selectedStatus) {
      case TransactionStatus.diterima:
        return 'Baru';
      case TransactionStatus.diproses:
        return 'Diproses';
      case TransactionStatus.siapDiambil:
        return 'Siap Diambil';
      case null:
        return null;
    }
  }

  TransactionStatus? _mapStatus(String status) {
    switch (status) {
      case 'Baru':
        return TransactionStatus.diterima;
      case 'Diproses':
        return TransactionStatus.diproses;
      case 'Siap Diambil':
        return TransactionStatus.siapDiambil;
      default:
        return TransactionStatus.diproses;
    }
  }

  Future<void> _load() async {
    setState(() {
      _state = _LoadState.loading;
      _error = null;
    });
    try {
      final result = await _api.listTransactions(
        page: _currentPage,
        limit: 10,
        status: _statusQuery(),
        q: _search,
      );
      if (!mounted) return;
      setState(() {
        _items = result.items;
        _totalPages = result.totalPages < 1 ? 1 : result.totalPages;
        _totalItems = result.total;
        _state = result.items.isEmpty ? _LoadState.empty : _LoadState.loaded;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _state = _LoadState.error;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Gagal memuat transaksi';
        _state = _LoadState.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Transaksi')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.base, AppSpacing.sm, AppSpacing.base, 0),
            child: AppSearchBar(
              hint: 'Cari transaksi...',
              onChanged: (val) {
                _search = val;
                _currentPage = 1;
                _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 350), _load);
              },
            ),
          ),
          TransactionFilterBar(onDateTap: () {}, onFilterTap: () {}, onEditTap: () {}),
          TransactionStatusTabs(
            selected: _selectedStatus,
            onChanged: (s) {
              setState(() {
                _selectedStatus = s;
                _currentPage = 1;
              });
              _load();
            },
            counts: {
              null: _totalItems,
              TransactionStatus.diterima: 0,
              TransactionStatus.diproses: 0,
              TransactionStatus.siapDiambil: 0,
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case _LoadState.loading:
        return const Center(child: CircularProgressIndicator(color: AppColors.primaryRed));
      case _LoadState.error:
        return AppEmptyState(
          icon: Icons.wifi_off_rounded,
          title: 'Gagal memuat data',
          message: _error ?? 'Periksa koneksi lalu coba lagi.',
          actionLabel: 'Coba Lagi',
          onAction: _load,
        );
      case _LoadState.empty:
        return const AppEmptyState(
          icon: Icons.inbox_rounded,
          title: 'Belum ada transaksi',
          message: 'Transaksi baru akan muncul di sini.',
        );
      case _LoadState.loaded:
        return Stack(
          children: [
            Positioned.fill(
              child: RefreshIndicator(
                color: AppColors.primaryRed,
                onRefresh: _load,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.base, AppSpacing.sm, AppSpacing.base, 72),
                  itemCount: _items.length,
                  itemBuilder: (context, i) {
                    final t = _items[i];
                    return TransactionCard(
                      data: TransactionData(
                        code: t.kode,
                        outletName: t.outletName,
                        dateLabel: formatDateLabel(t.tanggal),
                        status: _mapStatus(t.status) ?? TransactionStatus.diproses,
                        isLunas: t.isLunas,
                        amount: t.total.round(),
                        pickupEstimate: formatDateTimeLabel(t.pickupEstimate),
                        serviceCount: t.jumlahItemLayanan,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: SafeArea(
                top: false,
                child: AppPagination(
                  floating: true,
                  currentPage: _currentPage,
                  totalPages: _totalPages,
                  totalItems: _totalItems,
                  itemsPerPage: 10,
                  onPageChanged: (page) {
                    setState(() => _currentPage = page);
                    _load();
                  },
                ),
              ),
            ),
          ],
        );
    }
  }
}
