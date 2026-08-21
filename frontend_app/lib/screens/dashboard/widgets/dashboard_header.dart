import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

/// Top header for the Dashboard screen.
/// Shows greeting, outlet selector, notification bell, and quick actions.
class DashboardHeader extends StatelessWidget {
  final String userName;
  final String role;
  final String outletName;
  final int notificationCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onHistoryTap;
  final VoidCallback? onTopUpTap;
  final VoidCallback? onOutletTap;

  const DashboardHeader({
    super.key,
    required this.userName,
    required this.role,
    required this.outletName,
    this.notificationCount = 0,
    this.onNotificationTap,
    this.onHistoryTap,
    this.onTopUpTap,
    this.onOutletTap,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.base,
        topPadding > 0 ? topPadding + AppSpacing.sm : AppSpacing.base,
        AppSpacing.base,
        AppSpacing.xl + AppSpacing.sm, // extra bottom so card overlaps nicely
      ),
      decoration: const BoxDecoration(
        color: AppColors.primaryRed,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Row 1: Greeting + Name + History + Bell ──────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang 👋',
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.80),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            userName,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _RoleBadge(label: role),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onHistoryTap,
                icon: const Icon(Icons.history_rounded, color: Colors.white),
                tooltip: 'Riwayat',
              ),
              const SizedBox(width: 4),
              _NotificationBell(count: notificationCount, onTap: onNotificationTap),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Row 2: Outlet selector + Top up ──────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onOutletTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.storefront_rounded, color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          outletName,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: onTopUpTap,
                icon: const Icon(Icons.add_card_rounded, color: Colors.white),
                tooltip: 'Top Up',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Sub-widgets ────────────────────────────────────────────────────────────

class _RoleBadge extends StatelessWidget {
  final String label;
  const _RoleBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  final int count;
  final VoidCallback? onTap;
  const _NotificationBell({required this.count, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
          ),
          if (count > 0)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Text(
                  count > 99 ? '99+' : '$count',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryRed,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}