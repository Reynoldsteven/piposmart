import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import 'transaction_card.dart';

// ── Filter bar ───────────────────────────────────────────────────────────────

class TransactionFilterBar extends StatelessWidget {
  final VoidCallback? onDateTap;
  final VoidCallback? onFilterTap;
  final VoidCallback? onEditTap;

  const TransactionFilterBar({
    super.key,
    this.onDateTap,
    this.onFilterTap,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.base, AppSpacing.base, AppSpacing.base, AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: _FilterButton(
              icon: Icons.calendar_month_outlined,
              label: 'Tgl Buat',
              onTap: onDateTap,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _FilterButton(
              icon: Icons.tune_rounded,
              label: 'Semua',
              onTap: onFilterTap,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _FilterButton(
            icon: Icons.edit_rounded,
            label: '',
            onTap: onEditTap,
            compact: true,
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool compact;

  const _FilterButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.control),
      child: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 12, vertical: 0),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border.fromBorderSide(BorderSide(color: AppColors.divider)),
          borderRadius: BorderRadius.circular(AppRadius.control),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            if (!compact) ...[
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 2),
              const Icon(Icons.arrow_drop_down_rounded, size: 18, color: AppColors.textSecondary),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Status tab chips ─────────────────────────────────────────────────────────

/// Horizontally scrollable status filter chips.
/// null = "Semua" (all statuses).
class TransactionStatusTabs extends StatelessWidget {
  final TransactionStatus? selected;
  final ValueChanged<TransactionStatus?> onChanged;
  final Map<TransactionStatus?, int> counts;

  const TransactionStatusTabs({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.counts,
  });

  @override
  Widget build(BuildContext context) {
    final entries = <TransactionStatus?>[null, ...TransactionStatus.values];

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
        itemCount: entries.length,
        // ignore: avoid_types_as_parameter_names
        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) {
          final status = entries[i];
          final isSelected = status == selected;
          final label = status == null ? 'Semua' : _labelFor(status);
          final count = counts[status] ?? 0;
          final activeColor = status == null ? AppColors.primaryRed : _colorFor(status);

          return GestureDetector(
            onTap: () => onChanged(status),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.button),
                border: Border.fromBorderSide(
                  BorderSide(
                    color: isSelected ? AppColors.textPrimary : AppColors.divider,
                    width: isSelected ? 1.5 : 0.8,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: activeColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$count',
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _labelFor(TransactionStatus s) => switch (s) {
        TransactionStatus.diterima    => 'Diterima',
        TransactionStatus.diproses    => 'Diproses',
        TransactionStatus.siapDiambil => 'Siap Diambil',
      };

  Color _colorFor(TransactionStatus s) => switch (s) {
        TransactionStatus.diterima    => AppColors.primaryRed,
        TransactionStatus.diproses    => const Color(0xFFF59E0B),
        TransactionStatus.siapDiambil => AppColors.success,
      };
}