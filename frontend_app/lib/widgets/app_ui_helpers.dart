import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// 1. FORM FIELD WITH VALIDATION  ─────────────────────────────────────────────
// ═══════════════════════════════════════════════════════════════════════════════

class AppFormField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final bool obscureText;
  final bool readOnly;
  final int maxLines;
  final IconData? prefixIcon;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const AppFormField({
    super.key,
    required this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffix,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: hasError ? AppColors.error : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: hasError
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  boxShadow: [BoxShadow(color: AppColors.error.withValues(alpha: 0.12), blurRadius: 8)],
                )
              : null,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            readOnly: readOnly,
            maxLines: maxLines,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: readOnly ? AppColors.textSecondary : AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, size: 18, color: hasError ? AppColors.error : AppColors.textSecondary)
                  : null,
              suffix: suffix,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
                borderSide: BorderSide(color: hasError ? AppColors.error : AppColors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
                borderSide: BorderSide(
                  color: hasError ? AppColors.error : AppColors.primaryRed,
                  width: 1.5,
                ),
              ),
              filled: true,
              fillColor: readOnly ? AppColors.background : AppColors.surface,
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: hasError
              ? Padding(
                  padding: const EdgeInsets.only(top: 5, left: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded, size: 13, color: AppColors.error),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          errorText!,
                          style: GoogleFonts.inter(fontSize: 12, color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// 2. EMPTY STATE  ─────────────────────────────────────────────────────────────
// ═══════════════════════════════════════════════════════════════════════════════

class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.lightRed,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: AppColors.primaryRed),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// 3. ERROR STATE  ─────────────────────────────────────────────────────────────
// ═══════════════════════════════════════════════════════════════════════════════

class AppErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AppErrorState({
    super.key,
    this.message = 'Terjadi kesalahan. Periksa koneksi internet Anda.',
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.wifi_off_rounded, size: 28, color: AppColors.error),
            ),
            const SizedBox(height: 16),
            Text(
              'Gagal Memuat Data',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Coba Lagi'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryRed),
                foregroundColor: AppColors.primaryRed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// 4. LOADING SKELETON  ────────────────────────────────────────────────────────
// ═══════════════════════════════════════════════════════════════════════════════

class AppSkeletonLoader extends StatefulWidget {
  final int itemCount;
  const AppSkeletonLoader({super.key, this.itemCount = 4});

  @override
  State<AppSkeletonLoader> createState() => _AppSkeletonLoaderState();
}

class _AppSkeletonLoaderState extends State<AppSkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 0.9).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.base),
        itemCount: widget.itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (_, __) => _SkeletonCard(opacity: _anim.value),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  final double opacity;
  const _SkeletonCard({required this.opacity});

  Widget _box(double w, double h) => Container(
    width: w,
    height: h,
    decoration: BoxDecoration(
      color: AppColors.divider.withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(6),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: const Border.fromBorderSide(BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: AppColors.divider.withValues(alpha: opacity),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(double.infinity, 14),
                const SizedBox(height: 8),
                _box(120, 11),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// 5. SUCCESS / INFO TOAST  ────────────────────────────────────────────────────
// ═══════════════════════════════════════════════════════════════════════════════

enum AppToastType { success, error, info }

class AppToast {
  static void show(
    BuildContext context, {
    required String message,
    AppToastType type = AppToastType.success,
  }) {
    final (icon, bg, fg) = switch (type) {
      AppToastType.success => (Icons.check_circle_rounded, AppColors.success, AppColors.successLight),
      AppToastType.error => (Icons.error_rounded, AppColors.error, AppColors.errorLight),
      AppToastType.info => (Icons.info_rounded, AppColors.info, AppColors.infoLight),
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.fromLTRB(AppSpacing.base, 0, AppSpacing.base, AppSpacing.base),
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: fg,
            borderRadius: BorderRadius.circular(AppRadius.button),
            border: Border.all(color: bg.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: bg.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: bg, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: bg,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// 6. CONFIRMATION DIALOG  ─────────────────────────────────────────────────────
// ═══════════════════════════════════════════════════════════════════════════════

class AppConfirmDialog {
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Hapus',
    String cancelLabel = 'Batal',
    bool isDestructive = true,
  }) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 220),
      transitionBuilder: (ctx, anim, _, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
          child: FadeTransition(
            opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
            child: child,
          ),
        );
      },
      pageBuilder: (ctx, _, __) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.dialog),
                boxShadow: AppElevation.modal,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: isDestructive ? AppColors.errorLight : AppColors.lightRed,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isDestructive ? Icons.delete_outline_rounded : Icons.help_outline_rounded,
                      color: isDestructive ? AppColors.error : AppColors.primaryRed,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text(cancelLabel),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: isDestructive ? AppColors.error : AppColors.primaryRed,
                          ),
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text(confirmLabel),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// 7. SEARCH BAR WIDGET  ───────────────────────────────────────────────────────
// ═══════════════════════════════════════════════════════════════════════════════

class AppSearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final Widget? trailing;
  final TextEditingController? controller;

  const AppSearchBar({
    super.key,
    required this.hint,
    this.onChanged,
    this.trailing,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14),
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 6),
          trailing!,
        ],
      ],
    );
  }
}

// -------------------------------------------------------------------------------
// 8. PAGINATION WIDGET  -------------------------------------------------------
// -------------------------------------------------------------------------------

class AppPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final ValueChanged<int> onPageChanged;

  /// Compact floating pill (for overlay above list / below FAB).
  final bool floating;

  const AppPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.totalItems = 0,
    this.itemsPerPage = 10,
    required this.onPageChanged,
    this.floating = false,
  });

  @override
  Widget build(BuildContext context) {
    int startItem = ((currentPage - 1) * itemsPerPage) + 1;
    int endItem = (currentPage * itemsPerPage).clamp(0, totalItems);
    if (totalItems == 0) {
      startItem = 0;
      endItem = 0;
    }

    final infoText = Text(
      '$startItem–$endItem / $totalItems',
      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
    );

    final pager = Row(
      mainAxisSize: MainAxisSize.min,
      children: _buildPageNumbers(),
    );

    final content = Row(
      mainAxisSize: floating ? MainAxisSize.max : MainAxisSize.min,
      children: [
        infoText,
        const Spacer(),
        pager,
      ],
    );

    if (floating) {
      return Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.divider),
            boxShadow: const [
              BoxShadow(color: Color(0x1A000000), blurRadius: 12, offset: Offset(0, 4)),
            ],
          ),
          child: content,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.base, 8, AppSpacing.base, 8),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(top: false, child: content),
    );
  }

  List<Widget> _buildPageNumbers() {
    final children = <Widget>[];

    children.add(_buildNavButton(
      Icons.chevron_left_rounded,
      currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
    ));

    List<int> pages = [];
    if (totalPages <= 5) {
      pages = List.generate(totalPages < 1 ? 1 : totalPages, (i) => i + 1);
    } else if (currentPage <= 3) {
      pages = [1, 2, 3, -1, totalPages];
    } else if (currentPage >= totalPages - 2) {
      pages = [1, -1, totalPages - 2, totalPages - 1, totalPages];
    } else {
      pages = [1, -1, currentPage, -1, totalPages];
    }

    for (final p in pages) {
      if (p == -1) {
        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text('…', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
          ),
        );
      } else {
        children.add(_buildPageButton(p));
      }
    }

    children.add(_buildNavButton(
      Icons.chevron_right_rounded,
      currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
    ));

    return children;
  }

  Widget _buildPageButton(int page) {
    final isActive = page == currentPage;
    return InkWell(
      onTap: () => onPageChanged(page),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        constraints: const BoxConstraints(minWidth: 26),
        height: 26,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          color: isActive ? AppColors.lightRed : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          page.toString(),
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? AppColors.primaryRed : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 26,
        height: 26,
        child: Icon(icon, size: 18, color: onTap != null ? AppColors.textPrimary : AppColors.divider),
      ),
    );
  }
}
