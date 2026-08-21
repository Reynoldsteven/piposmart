import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

// ── Data model ──────────────────────────────────────────────────────────────

class MenuItemData {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const MenuItemData({
    required this.label,
    required this.icon,
    required this.color,
    this.onTap,
  });
}

// ── Grid widget ──────────────────────────────────────────────────────────────

/// 4-column quick-action menu grid shown on the Dashboard.
/// Dibangun manual pakai Row/Column (bukan GridView) supaya semua spacing eksak.
class MenuGrid extends StatelessWidget {
  final String title;
  final List<MenuItemData> items;
  final int crossAxisCount;

  const MenuGrid({
    super.key,
    this.title = 'Menu Utama',
    required this.items,
    this.crossAxisCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <List<MenuItemData>>[];
    for (var i = 0; i < items.length; i += crossAxisCount) {
      rows.add(items.sublist(
        i,
        i + crossAxisCount > items.length ? items.length : i + crossAxisCount,
      ));
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.base,
        0,
        AppSpacing.base,
        AppSpacing.base,
      ),
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.cardLarge),
        boxShadow: AppElevation.card,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 15), // judul -> grid, rapat
          for (int r = 0; r < rows.length; r++) ...[
            if (r > 0) const SizedBox(height: 20), // jarak antar baris menu
            Row(
              children: [
                for (int c = 0; c < crossAxisCount; c++) ...[
                  if (c > 0) const SizedBox(width: 4), // jarak antar kolom
                  Expanded(
                    child: c < rows[r].length
                        ? _MenuItem(item: rows[r][c])
                        : const SizedBox(),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final MenuItemData item;
  const _MenuItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(item.icon, color: item.color, size: 22),
              ),
              const SizedBox(height: 6),
              Text(
                item.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}