import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

// ── Data model ──────────────────────────────────────────────────────────────

enum DashboardTab { keuangan, ringkasan, statistik }

/// A single finance metric shown in the grid
class FinanceStat {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const FinanceStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });
}

// ── Card widget ──────────────────────────────────────────────────────────────

/// Floating summary card that overlaps the red header.
/// Contains a segmented tab (Keuangan / Ringkasan / Statistik) and a 2×2 stat grid.
class FinanceSummaryCard extends StatelessWidget {
  final DashboardTab selectedTab;
  final ValueChanged<DashboardTab> onTabChanged;
  final List<FinanceStat> stats;

  const FinanceSummaryCard({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -28),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.cardLarge),
          boxShadow: AppElevation.card,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SegmentedTab(selected: selectedTab, onChanged: onTabChanged),
            const SizedBox(height: 10), // jarak tab -> grid statistik
            _StatGrid(stats: stats),
          ],
        ),
      ),
    );
  }
}

/// Grid statistik manual 2 kolom — tanpa GridView, tanpa aspect ratio tebak-tebakan.
class _StatGrid extends StatelessWidget {
  final List<FinanceStat> stats;
  const _StatGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    final rows = <List<FinanceStat>>[];
    for (var i = 0; i < stats.length; i += 2) {
      rows.add(stats.sublist(i, i + 2 > stats.length ? stats.length : i + 2));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int r = 0; r < rows.length; r++) ...[
          if (r > 0) const SizedBox(height: 10), // jarak antar baris stat
          Row(
            children: [
              for (int c = 0; c < rows[r].length; c++) ...[
                if (c > 0) const SizedBox(width: 10), // jarak antar kolom stat
                Expanded(child: _StatTile(stat: rows[r][c])),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

// ── Internal widgets ─────────────────────────────────────────────────────────

class _SegmentedTab extends StatelessWidget {
  final DashboardTab selected;
  final ValueChanged<DashboardTab> onChanged;
  const _SegmentedTab({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      padding: const EdgeInsets.all(3),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / DashboardTab.values.length;
          final selectedIndex = DashboardTab.values.indexOf(selected);

          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                left: selectedIndex * tabWidth,
                width: tabWidth,
                top: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.control),
                    border: Border.all(color: AppColors.divider, width: 0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                ),
              ),
              Row(
                children: DashboardTab.values.map((tab) {
                  final isSelected = tab == selected;
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onChanged(tab),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 250),
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? AppColors.primaryRed : AppColors.textSecondary,
                          ),
                          child: Text(_labelFor(tab)),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  String _labelFor(DashboardTab tab) => switch (tab) {
        DashboardTab.keuangan => 'Keuangan',
        DashboardTab.ringkasan => 'Ringkasan',
        DashboardTab.statistik => 'Statistik',
      };
}

class _StatTile extends StatelessWidget {
  final FinanceStat stat;
  const _StatTile({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: stat.bgColor,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: stat.iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(stat.icon, size: 16, color: stat.iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stat.label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  stat.value,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}