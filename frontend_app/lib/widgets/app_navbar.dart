import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Reusable bottom navigation bar.
/// Used exclusively through [MainNavShell].
class AppNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.divider, width: 0.8)),
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.primaryRed);
            }
            return const IconThemeData(color: AppColors.textSecondary);
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return GoogleFonts.inter(
                color: AppColors.primaryRed,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              );
            }
            return GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            );
          }),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: onTap,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.storefront_outlined),
              selectedIcon: Icon(Icons.store_rounded),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_rounded),
              label: 'Transaksi',
            ),
            NavigationDestination(
              icon: _ScanIcon(),
              selectedIcon: _ScanIcon(active: true),
              label: 'Scan',
            ),
            NavigationDestination(
              icon: Icon(Icons.access_time_outlined),
              selectedIcon: Icon(Icons.access_time_filled_rounded),
              label: 'Status',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Akun',
            ),
          ],
        ),
      ),
    );
  }
}

/// Center scan button — red circle, always prominent
class _ScanIcon extends StatelessWidget {
  final bool active;
  const _ScanIcon({this.active = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: active ? AppColors.primaryRed : AppColors.primaryRed.withValues(alpha: 0.85),
        shape: BoxShape.circle,
        boxShadow: active ? AppElevation.fab : null,
      ),
      child: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 20),
    );
  }
}