import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

// ── Enums & models ───────────────────────────────────────────────────────────

/// Laundry order processing status — maps to semantic colors per guidelines
enum TransactionStatus { diterima, diproses, siapDiambil }

class TransactionData {
  final String code;
  final String outletName;
  final String dateLabel;
  final TransactionStatus status;
  final bool isLunas;
  final int amount;
  final String pickupEstimate;
  final int serviceCount;

  const TransactionData({
    required this.code,
    required this.outletName,
    required this.dateLabel,
    required this.status,
    required this.isLunas,
    required this.amount,
    required this.pickupEstimate,
    required this.serviceCount,
  });
}

// ── Transaction card ─────────────────────────────────────────────────────────

class TransactionCard extends StatelessWidget {
  final TransactionData data;
  final VoidCallback? onDetailTap;

  const TransactionCard({super.key, required this.data, this.onDetailTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: const Border.fromBorderSide(BorderSide(color: AppColors.divider, width: 0.8)),
        boxShadow: AppElevation.card,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: InkWell(
          onTap: onDetailTap,
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Row 1: code + payment badge ───────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.receipt_long_rounded, size: 14, color: AppColors.primaryRed),
                        const SizedBox(width: 5),
                        Text(
                          data.code,
                          style: GoogleFonts.inter(
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    _PaymentBadge(isLunas: data.isLunas),
                  ],
                ),

                const SizedBox(height: 8),

                // ── Row 2: outlet name + date ─────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        data.outletName,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      data.dateLabel,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ── Row 3: laundry status + amount ────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _LaundryStatusChip(status: data.status),
                    Text(
                      'Rp ${_formatRupiah(data.amount)}',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryRed,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1),
                ),

                // ── Row 4: pickup estimate + detail button ────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estimasi diambil',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          data.pickupEstimate,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.5,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    OutlinedButton(
                      onPressed: onDetailTap,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: const BorderSide(color: AppColors.primaryRed),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.control),
                        ),
                        textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      child: const Text('Lihat Detail'),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(Icons.local_laundry_service_outlined, size: 13, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${data.serviceCount} layanan',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
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

  String _formatRupiah(int amount) {
    final s = amount.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _PaymentBadge extends StatelessWidget {
  final bool isLunas;
  const _PaymentBadge({required this.isLunas});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isLunas ? AppColors.successLight : AppColors.warningLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isLunas ? 'Lunas' : 'Belum Lunas',
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isLunas ? AppColors.success : AppColors.warning,
        ),
      ),
    );
  }
}

class _LaundryStatusChip extends StatelessWidget {
  final TransactionStatus status;
  const _LaundryStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    // Per guidelines: Diterima=Red, Diproses=Orange, Siap=Green
    final (label, color, bgColor, icon) = switch (status) {
      TransactionStatus.diterima    => ('Diterima', AppColors.primaryRed, AppColors.lightRed, Icons.inbox_rounded),
      TransactionStatus.diproses    => ('Diproses', AppColors.warning, AppColors.warningLight, Icons.autorenew_rounded),
      TransactionStatus.siapDiambil => ('Siap Diambil', AppColors.success, AppColors.successLight, Icons.check_circle_rounded),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}