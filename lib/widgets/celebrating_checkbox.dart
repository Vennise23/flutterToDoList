import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_animate/flutter_animate.dart';

class CelebratingCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CelebratingCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<CelebratingCheckbox> createState() => _CelebratingCheckboxState();
}

class _CelebratingCheckboxState extends State<CelebratingCheckbox> {
  bool _showFireworks = false;

  void _handleChange(bool? newValue) {
    if (newValue != null && newValue && !widget.value) {
      setState(() => _showFireworks = true);
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) setState(() => _showFireworks = false);
      });
    }
    widget.onChanged(newValue ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Checkbox(
          value: widget.value,
          onChanged: _handleChange,
          checkColor: Colors.green,
          activeColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          side: const BorderSide(color: Colors.black, width: 2),
        ),
        if (_showFireworks)
          Positioned(
            top: -20,
            left: -20,
            right: -20,
            bottom: -20,
            child: _buildFireworksEffect()
                .animate()
                .scale(duration: 500.ms)
                .fadeOut(duration: 500.ms),
          ),
      ],
    );
  }

  Widget _buildFireworksEffect() {
    return SizedBox(
      width: 60,
      height: 60,
      child: CustomPaint(painter: FireworkPainter()),
    );
  }
}

class FireworkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final paint =
        Paint()
          ..color = Colors.orange
          ..strokeWidth = 2;

    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      final x = center.dx + cos(angle) * 20;
      final y = center.dy + sin(angle) * 20;
      canvas.drawLine(center, Offset(x, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
