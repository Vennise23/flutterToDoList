import 'package:flutter/material.dart';

class HoverBounceCard extends StatefulWidget {
  final Widget child;

  HoverBounceCard({required this.child});

  @override
  _HoverBounceCardState createState() => _HoverBounceCardState();
}

class _HoverBounceCardState extends State<HoverBounceCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _scale = 1.05; // Slightly larger on hover
        });
      },
      onExit: (_) {
        setState(() {
          _scale = 1.0; // Return to normal size when hover ends
        });
      },
      child: AnimatedScale(
        duration: Duration(milliseconds: 150), // Animation duration
        curve: Curves.easeInOut, // Animation curve
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}
