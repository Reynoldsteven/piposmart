import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../auth/login_screen.dart';
import 'widgets/account_menu_item.dart';
import 'profil_saya_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Keluar dari Akun',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        content: Text(
          'Apakah kamu yakin ingin keluar dari akun ini?',
          style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await context.read<AuthProvider>().logout();
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // ── Profile header ────────────────────────────────────────────
              const _ProfileHeader(),

              Transform.translate(
                offset: const Offset(0, -28),
                child: Column(
                  children: [
                    // ── Membership card ───────────────────────────────────────────
                    const _MembershipCard(),

                    const SizedBox(height: AppSpacing.sm),

                    // ── Menu sections ─────────────────────────────────────────────
                    _SectionCard(
                      title: 'Akun',
                      children: [
                        AccountMenuItem(
                          icon: Icons.person_outline_rounded,
                          iconColor: const Color(0xFF2563EB),
                          label: 'Profil Saya',
                          onTap: () => Navigator.push(
                            context,
                            CupertinoPageRoute(builder: (_) => const ProfilSayaScreen()),
                          ),
                        ),
                        AccountMenuItem(
                          icon: Icons.print_outlined,
                          iconColor: const Color(0xFF0D9488),
                          label: 'Printer & Nota',
                          onTap: () {},
                        ),
                        AccountMenuItem(
                          icon: Icons.lock_outline_rounded,
                          iconColor: const Color(0xFFF59E0B),
                          label: 'Ganti Password',
                          onTap: () {},
                          showDivider: false,
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    _SectionCard(
                      title: 'Lainnya',
                      children: [
                        AccountMenuItem(
                          icon: Icons.star_border_rounded,
                          iconColor: const Color(0xFFEC4899),
                          label: 'Berikan Ulasan',
                          subtitle: 'Play Store',
                          onTap: () {},
                        ),
                        AccountMenuItem(
                          icon: Icons.description_outlined,
                          iconColor: const Color(0xFF16A34A),
                          label: 'Syarat dan Ketentuan',
                          onTap: () {},
                        ),
                        AccountMenuItem(
                          icon: Icons.privacy_tip_outlined,
                          iconColor: const Color(0xFF7C3AED),
                          label: 'Kebijakan Privasi',
                          onTap: () {},
                        ),
                        AccountMenuItem(
                          icon: Icons.info_outline_rounded,
                          iconColor: const Color(0xFFF97316),
                          label: 'Tentang Kami',
                          onTap: () {},
                        ),
                        AccountMenuItem(
                          icon: Icons.share_outlined,
                          iconColor: const Color(0xFF4F46E5),
                          label: 'Bagikan Aplikasi',
                          onTap: () {},
                          showDivider: false,
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.base),

                    // ── Logout button ─────────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
                      child: OutlinedButton.icon(
                        onPressed: () => _handleLogout(context),
                        icon: const Icon(Icons.logout_rounded, size: 18),
                        label: const Text('Keluar dari Akun'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          side: const BorderSide(color: AppColors.primaryRed),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    Center(
                      child: Text(
                        'Piposmart v1.0.0',
                        style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  String _roleLabel(String role) {
    switch (role.toLowerCase()) {
      case 'owner':
        return 'Owner';
      case 'kasir':
        return 'Kasir';
      case 'produksi':
        return 'Produksi';
      default:
        return role.isEmpty ? '-' : role;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.base,
        topPadding > 0 ? topPadding + AppSpacing.sm : AppSpacing.base,
        AppSpacing.base,
        AppSpacing.xl + AppSpacing.sm,
      ),
      color: AppColors.primaryRed,
      child: Row(
        children: [
          // Avatar circle
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
            ),
            child: const Icon(Icons.person_rounded, color: Colors.white, size: 30),
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        user?.name ?? 'Pengguna',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
                      ),
                      child: Text(
                        _roleLabel(user?.role ?? ''),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.storefront_outlined, color: Colors.white70, size: 13),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        user?.email ?? '-',
                        style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MembershipCard extends StatelessWidget {
  const _MembershipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: const Border.fromBorderSide(BorderSide(color: AppColors.divider, width: 0.8)),
        boxShadow: AppElevation.card,
      ),
      child: Row(
        children: [
          Expanded(
            child: _InfoTile(
              icon: Icons.verified_outlined,
              iconColor: AppColors.primaryRed,
              label: 'Membership',
              value: '0 Hari',
            ),
          ),
          Container(width: 1, height: 40, color: AppColors.divider),
          Expanded(
            child: _InfoTile(
              icon: Icons.workspace_premium_outlined,
              iconColor: AppColors.textSecondary,
              label: 'Paket',
              value: 'Belum Ada',
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  const _InfoTile({required this.icon, required this.iconColor, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: const Border.fromBorderSide(BorderSide(color: AppColors.divider, width: 0.8)),
        boxShadow: AppElevation.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.base, 14, AppSpacing.base, 6),
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}