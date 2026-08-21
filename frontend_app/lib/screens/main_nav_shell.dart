import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/app_navbar.dart';
import 'dashboard/dashboard_screen.dart';
import 'transactions/transaction_list_screen.dart';
import 'status/status_screen.dart';
import 'account/account_screen.dart';

/// Placeholder screen for the Scan tab (not in scope for current phase)
class ScanPlaceholderScreen extends StatelessWidget {
  const ScanPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.lightRed,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.qr_code_scanner_rounded,
                size: 40,
                color: AppColors.primaryRed,
              ),
            ),
            const SizedBox(height: AppSpacing.base),
            Text(
              'Scan QR',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Fitur ini belum tersedia',
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

/// Main application shell — holds the 5-tab IndexedStack and bottom nav.
class MainNavShell extends StatefulWidget {
  const MainNavShell({super.key});

  @override
  State<MainNavShell> createState() => _MainNavShellState();
}

class _MainNavShellState extends State<MainNavShell> {
  int _index = 0;

  final _pages = const [
    DashboardScreen(),
    TransactionListScreen(),
    ScanPlaceholderScreen(),
    StatusScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: AppNavbar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}