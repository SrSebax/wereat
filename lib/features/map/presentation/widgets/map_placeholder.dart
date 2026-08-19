import 'package:flutter/material.dart';
import 'package:wereat/core/theme/app_colors.dart';
import 'package:wereat/core/theme/app_radius.dart';

/// Espacio reservado para el mapa real. Dibuja un fondo tipo mapa (ondas +
/// bloques neutros) para maquetar el layout mientras se integra el mapa.
class MapPlaceholder extends StatelessWidget {
  const MapPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
        color: AppColors.teal50,
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _WavesPainter())),
            const Positioned(
              left: 40,
              top: 90,
              child: _PlaceholderBlock(width: 64, height: 56),
            ),
            const Positioned(
              right: 56,
              top: 150,
              child: _PlaceholderBlock(width: 76, height: 66),
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: _LocationButton(onTap: () {}),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderBlock extends StatelessWidget {
  const _PlaceholderBlock({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.gray100.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class _LocationButton extends StatelessWidget {
  const _LocationButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.gray900,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Icon(Icons.my_location, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _WavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.teal100
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    void wave(double startY) {
      final path = Path()..moveTo(-20, startY);
      path.quadraticBezierTo(
        size.width * 0.35,
        startY - 40,
        size.width * 0.65,
        startY + 10,
      );
      path.quadraticBezierTo(
        size.width * 0.85,
        startY + 35,
        size.width + 20,
        startY - 20,
      );
      canvas.drawPath(path, paint);
    }

    wave(size.height * 0.22);
    wave(size.height * 0.62);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
