import 'dart:math';
import 'package:flutter/material.dart';

class Wheel extends StatefulWidget {
  final Function(int) onSpinComplete;

  const Wheel({super.key, required this.onSpinComplete});

  @override
  State<Wheel> createState() => _WheelState();
}

class _WheelState extends State<Wheel> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isSpinning = false;
  final List<int> segments = [0, 1, 0, 1, 5, 0, 1, 0, 1, 0];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void spinWheel() {
    if (isSpinning) return;

    setState(() {
      isSpinning = true;
    });

    final random = Random();
    final spins = 5;
    final randomSegment = random.nextInt(segments.length);
    final segmentAngle = 2 * pi / segments.length;
    final finalAngle = spins * 2 * pi + (randomSegment * segmentAngle);

    _animation = Tween<double>(
      begin: 0,
      end: finalAngle,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward(from: 0).then((_) {
      setState(() {
        isSpinning = false;
      });
      widget.onSpinComplete(segments[randomSegment]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _animation.value,
                child: CustomPaint(
                  size: const Size(300, 300),
                  painter: WheelPainter(segments: segments),
                ),
              );
            },
          ),
          Container(
            width: 60,
            height: 60,
            child: ElevatedButton(
              onPressed: isSpinning ? null : spinWheel,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: const CircleBorder(),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                isSpinning ? '...' : 'SPIN!',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WheelPainter extends CustomPainter {
  final List<int> segments;

  WheelPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final segmentAngle = 2 * pi / segments.length;

    final colors = [
      const Color(0xFFFF6B6B),
      const Color(0xFF4ECDC4),
      const Color(0xFFFFD93D),
      const Color(0xFF6C5B7B),
      const Color(0xFF45B7D1),
    ];

    // Draw segments
    for (var i = 0; i < segments.length; i++) {
      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * segmentAngle,
        segmentAngle,
        true,
        paint,
      );

      // Draw border
      final borderPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * segmentAngle,
        segmentAngle,
        true,
        borderPaint,
      );

      // Draw text
      final textPainter = TextPainter(
        text: TextSpan(
          text: '\$${segments[i]}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black,
                blurRadius: 2,
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final textAngle = i * segmentAngle + segmentAngle / 2;
      final textRadius = radius * 0.7;
      final x = center.dx + textRadius * cos(textAngle);
      final y = center.dy + textRadius * sin(textAngle);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(textAngle + pi / 2);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }

    // Draw center circle
    final centerCirclePaint = Paint()
      ..color = Colors.grey[900]!
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 30, centerCirclePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}