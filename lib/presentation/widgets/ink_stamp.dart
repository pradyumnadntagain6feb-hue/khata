import 'package:flutter/material.dart';
import '../../core/models/attendance_status.dart';

class InkStampWidget extends StatelessWidget {
  final AttendanceStatus status;
  final double size;
  final bool isSelected;
  final VoidCallback? onTap;

  const InkStampWidget({
    super.key,
    required this.status,
    this.size = 32.0,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (status == AttendanceStatus.unMarked) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFC8BEAF),
              width: 1.5,
              style: BorderStyle.solid,
            ),
          ),
          child: CustomPaint(
            painter: DashedCirclePainter(color: const Color(0xFFC8BEAF)),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: status.bgColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: status.borderColor,
            width: isSelected ? 2.5 : 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: status.borderColor.withAlpha(isSelected ? 76 : 20),
              blurRadius: isSelected ? 8 : 2,
              spreadRadius: isSelected ? 1 : 0,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Inner subtle ring for ink stamp look
            Container(
              width: size * 0.82,
              height: size * 0.82,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: status.borderColor.withAlpha(102),
                  width: 1.0,
                ),
              ),
            ),
            Text(
              status.code,
              style: TextStyle(
                fontFamily: 'serif',
                fontWeight: FontWeight.bold,
                fontSize: size * 0.48,
                color: status.textColor,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashedCirclePainter extends CustomPainter {
  final Color color;

  DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;

    const dashWidth = 3.0;
    const dashSpace = 3.0;
    final circumference = 2 * 3.1415926535 * radius;
    final dashCount = (circumference / (dashWidth + dashSpace)).floor();

    for (int i = 0; i < dashCount; i++) {
      final startAngle = (i * (dashWidth + dashSpace) / circumference) * 2 * 3.1415926535;
      final sweepAngle = (dashWidth / circumference) * 2 * 3.1415926535;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
