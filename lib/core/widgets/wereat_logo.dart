import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wereat/core/theme/app_colors.dart';

/// Lockup horizontal: isotipo (pin mordido) + wordmark en Fraunces.
class WereatLogo extends StatelessWidget {
  const WereatLogo({super.key, this.height = 40});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset('assets/branding/wereat-isotype.svg', height: height),
        const SizedBox(width: 10),
        Text(
          'wereat',
          style: GoogleFonts.fraunces(
            fontWeight: FontWeight.w600,
            fontSize: height * 0.75,
            color: AppColors.coral400,
            letterSpacing: -0.02 * height,
          ),
        ),
      ],
    );
  }
}
