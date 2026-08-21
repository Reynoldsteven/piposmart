import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

// ── Data model ───────────────────────────────────────────────────────────────

class StatusCardData {
  final String title;
  final String subtitle;
  final int count;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback? onDetailTap;

  const StatusCardData({
    required this.title,
    required this.subtitle,
    required this.count,
    required this.icon,
    required this.color,
    required this.bgColor,
    this.onDetailTap,
  });
}

// ── Status card widget ────────────────────────────────────────────────────────

/// Large rounded status card with icon, count, and action button.
/// Uses semantic color system — green/orange/red — not solid brand red.
class StatusCard extends StatelessWidget {
  final StatusCardData data;
  const StatusCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: AppSpacing.sm - 2),
      decoration: BoxDecoration(
        color: data.bgColor,
        borderRadius: BorderRadius.circular(AppRadius.cardLarge),
        border: Border.fromBorderSide(
          BorderSide(color: data.color.withValues(alpha: 0.20), width: 1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.cardLarge),
        child: InkWell(
          onTap: data.onDetailTap,
          borderRadius: BorderRadius.circular(AppRadius.cardLarge),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.base + 4),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: data.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(data.icon, size: 26, color: data.color),
                ),

                const SizedBox(width: AppSpacing.base),

                // Text block
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        data.subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: AppSpacing.sm),

                // Count bubble + chevron
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: data.color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${data.count}',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: data.count > 99 ? 14 : 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'pesanan',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: data.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}