import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProgressBar extends StatelessWidget {
  final int completed;
  final int total;
  final double height;
  final Color backgroundColor;
  final Color progressColor;

  const ProgressBar({
    super.key,
    required this.completed,
    required this.total,
    this.height = 8.0,
    this.backgroundColor = const Color(0x22FFFFFF),
    this.progressColor = Colors.deepPurpleAccent,
  });

  @override
  Widget build(BuildContext context) {
    double progress = (completed / total).clamp(0.0, 1.0);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: progress),
      duration: 500.ms,
      curve: Curves.easeOut,
      builder: (context, value, _) {
        return Stack(
          children: [
            Container(
              height: height,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(height),
              ),
            ),
            Container(
              height: height,
              width: MediaQuery.of(context).size.width * value,
              decoration: BoxDecoration(
                color: progressColor,
                borderRadius: BorderRadius.circular(height),
              ),
            ),
          ],
        );
      },
    );
  }
}
