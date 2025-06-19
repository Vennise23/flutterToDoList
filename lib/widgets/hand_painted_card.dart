import 'dart:math';
import 'package:flutter/material.dart';

class HandPaintedCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final EdgeInsets padding;

  const HandPaintedCard({
    super.key,
    required this.child,
    this.backgroundColor = Colors.transparent,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(BuildContext context) {
    // Dynamically compute a darker color for the border
    final borderColor = darken(backgroundColor, 0.4);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(color: backgroundColor),
            child: child,
          ),

          // Painted Border (on top)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: HandPaintedBorderPainter(borderColor: borderColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Darkens a [color] by [amount] (0.0 to 1.0)
  Color darken(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final darker = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darker.toColor();
  }
}

class HandPaintedBorderPainter extends CustomPainter {
  final Color borderColor;
  final double maxJitter;

  HandPaintedBorderPainter({required this.borderColor, this.maxJitter = 2.0});

  @override
  void paint(Canvas canvas, Size size) {
    final rand = Random();
    final paint =
        Paint()
          ..color = borderColor.withAlpha(40)
          ..strokeWidth = 2 + rand.nextDouble() * 0.8
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final path = Path();

    double jitter(double val) =>
        val + rand.nextDouble() * maxJitter - maxJitter / 2;

    // Top edge
    path.moveTo(jitter(0), jitter(0));
    path.lineTo(jitter(size.width), jitter(0));

    // Right edge
    path.lineTo(jitter(size.width), jitter(size.height));

    // Bottom edge
    path.lineTo(jitter(0), jitter(size.height));

    // Left edge
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
