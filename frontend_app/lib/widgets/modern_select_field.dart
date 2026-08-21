import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class ModernSelectField extends StatefulWidget {
  final String label;
  final String hint;
  final String? value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const ModernSelectField({
    super.key,
    required this.label,
    required this.hint,
    required this.options,
    required this.onChanged,
    this.value,
  });

  @override
  State<ModernSelectField> createState() => _ModernSelectFieldState();
}

class _ModernSelectFieldState extends State<ModernSelectField> {
  final _key = GlobalKey();

  void _showPopover() async {
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    final selected = await Navigator.push<String>(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.05),
        barrierDismissible: true,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation, secondaryAnimation) {
          // Cek apakah popover akan keluar batas bawah layar
          final screenHeight = MediaQuery.of(context).size.height;
          final popoverHeight = widget.options.length * 48.0; 
          bool openUp = (offset.dy + size.height + popoverHeight + 20) > screenHeight;

          return Stack(
            children: [
              Positioned(
                top: openUp ? null : offset.dy + size.height + 6,
                bottom: openUp ? (screenHeight - offset.dy) + 6 : null,
                left: offset.dx,
                width: size.width,
                child: Material(
                  color: Colors.transparent,
                  child: ScaleTransition(
                    scale: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutBack,
                    ),
                    alignment: openUp ? Alignment.bottomCenter : Alignment.topCenter,
                    child: FadeTransition(
                      opacity: CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: widget.options.map((option) {
                              final isSelected = option == widget.value;
                              return InkWell(
                                onTap: () => Navigator.pop(context, option),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  color: isSelected ? AppColors.lightRed : Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        option,
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                          color: isSelected ? AppColors.primaryRed : AppColors.textPrimary,
                                        ),
                                      ),
                                      if (isSelected)
                                        const Icon(Icons.check_circle_rounded, color: AppColors.primaryRed, size: 18),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    if (selected != null) {
      widget.onChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = widget.value != null && widget.value!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: _showPopover,
          borderRadius: BorderRadius.circular(AppRadius.button),
          child: Container(
            key: _key,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.button),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hasValue ? widget.value! : widget.hint,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: hasValue ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
                Icon(Icons.unfold_more_rounded, color: AppColors.textSecondary, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ModernFilterIcon extends StatefulWidget {
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  
  const ModernFilterIcon({
    super.key,
    required this.options,
    required this.onChanged,
    this.value,
  });

  @override
  State<ModernFilterIcon> createState() => _ModernFilterIconState();
}

class _ModernFilterIconState extends State<ModernFilterIcon> {
  final _key = GlobalKey();

  void _showPopover() async {
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    
    final selected = await Navigator.push<String>(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.05),
        barrierDismissible: true,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation, secondaryAnimation) {
          final screenWidth = MediaQuery.of(context).size.width;
          return Stack(
            children: [
              Positioned(
                top: offset.dy + size.height + 6,
                right: screenWidth - offset.dx - size.width,
                width: 200,
                child: Material(
                  color: Colors.transparent,
                  child: ScaleTransition(
                    scale: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutBack,
                    ),
                    alignment: Alignment.topRight,
                    child: FadeTransition(
                      opacity: CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (widget.value != null)
                                InkWell(
                                  onTap: () => Navigator.pop(context, ''), 
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    child: Text(
                                      'Hapus Filter',
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.error,
                                      ),
                                    ),
                                  ),
                                ),
                              if (widget.value != null)
                                const Divider(height: 1, color: AppColors.divider),
                              ...widget.options.map((option) {
                                final isSelected = option == widget.value;
                                return InkWell(
                                  onTap: () => Navigator.pop(context, option),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    color: isSelected ? AppColors.lightRed : Colors.transparent,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            option,
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                              color: isSelected ? AppColors.primaryRed : AppColors.textPrimary,
                                            ),
                                          ),
                                        ),
                                        if (isSelected)
                                          const Icon(Icons.check_circle_rounded, color: AppColors.primaryRed, size: 16),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    if (selected != null) {
      if (selected.isEmpty) {
        widget.onChanged(null);
      } else {
        widget.onChanged(selected);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isActive = widget.value != null;
    return IconButton(
      key: _key,
      icon: Icon(
        Icons.tune_rounded,
        color: isActive ? AppColors.primaryRed : AppColors.textSecondary,
        size: 20,
      ),
      onPressed: _showPopover,
    );
  }
}
