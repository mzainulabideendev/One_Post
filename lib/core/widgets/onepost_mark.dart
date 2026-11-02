import 'package:flutter/material.dart';

class OnePostMark extends StatelessWidget {
  const OnePostMark({super.key, this.size = 52});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF9333EA), Color(0xFF5B21B6)],
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6D28D9).withValues(alpha: 0.2),
            blurRadius: size * 0.3,
            offset: Offset(0, size * 0.08),
          ),
        ],
      ),
      child: Icon(
        Icons.send_rounded,
        color: Colors.white,
        size: size * 0.55,
      ),
    );
  }
}
