import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DayTile extends StatelessWidget {
  final int dayNumber;
  final bool isCompleted;
  final VoidCallback onTap;

  const DayTile({
    super.key,
    required this.dayNumber,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = isCompleted ? Colors.deepPurpleAccent : Colors.white10;
    final Color borderColor = isCompleted ? Colors.deepPurple : Colors.white24;
    final Color textColor = isCompleted ? Colors.white : Colors.white70;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 300.ms,
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Center(
          child: Text(
            "Day $dayNumber",
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      )
          .animate()
          .scaleXY(end: 1.05, duration: 100.ms) // subtle bounce effect
          .then()
          .scaleXY(end: 1.0, duration: 100.ms),
    );
  }
}
