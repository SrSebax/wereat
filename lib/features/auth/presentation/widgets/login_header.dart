import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wereat/core/theme/app_colors.dart';

/// Header de marca para el login: panel curvo en gradiente coral con el
/// isotipo, el wordmark y unas badges de categoría flotando como collage
/// (mismo lenguaje que la sección de badges del design system).
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key, this.height = 260});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipPath(
            clipper: _WaveClipper(),
            child: Container(
              width: double.infinity,
              height: height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.coral400, AppColors.coral600],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        AppColors.coral50,
                        BlendMode.srcIn,
                      ),
                      child: SvgPicture.asset(
                        'assets/branding/wereat-isotype.svg',
                        height: 56,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'wereat',
                      style: GoogleFonts.fraunces(
                        fontWeight: FontWeight.w600,
                        fontSize: 34,
                        color: Colors.white,
                        letterSpacing: -0.02 * 34,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Todos tus lugares favoritos, en un solo mapa.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.coral50,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 18,
            left: 20,
            child: Transform.rotate(
              angle: -0.14,
              child: const _FloatingBadge(
                icon: Icons.restaurant_outlined,
                label: 'Restaurante',
                background: AppColors.amber50,
                foreground: AppColors.amber600,
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: Transform.rotate(
              angle: 0.12,
              child: const _FloatingBadge(
                icon: Icons.location_on_outlined,
                label: 'Medellín',
                background: AppColors.teal50,
                foreground: AppColors.teal800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingBadge extends StatelessWidget {
  const _FloatingBadge({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray900.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foreground),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  const _WaveClipper();

  @override
  Path getClip(Size size) {
    final path = Path()..lineTo(0, size.height - 36);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 34,
      size.width,
      size.height - 36,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
