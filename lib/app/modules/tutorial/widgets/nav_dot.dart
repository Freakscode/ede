import 'package:flutter/material.dart';

class NavDot extends StatelessWidget {
  const NavDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.25),
        border: Border.all(color: Colors.white, width: 1.6),
      ),
    );
  }
}
