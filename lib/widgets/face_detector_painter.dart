import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../ML/Recognition.dart';

class FaceDetectorPainter extends CustomPainter {
  final Size absoluteImageSize;
  final List<Recognition> faces;
  final CameraLensDirection cameraDirection;

  FaceDetectorPainter(
      this.absoluteImageSize,
      this.faces,
      this.cameraDirection
      );

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / absoluteImageSize.width;
    final scaleY = size.height / absoluteImageSize.height;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.indigoAccent;

    for (var face in faces) {
      final scaledRect = Rect.fromLTRB(
        cameraDirection == CameraLensDirection.front
            ? (absoluteImageSize.width - face.location.right) * scaleX
            : face.location.left * scaleX,
        face.location.top * scaleY,
        cameraDirection == CameraLensDirection.front
            ? (absoluteImageSize.width - face.location.left) * scaleX
            : face.location.right * scaleX,
        face.location.bottom * scaleY,
      );

      canvas.drawRect(scaledRect, paint);

      _drawFaceLabel(canvas, face, scaledRect);
    }
  }

  void _drawFaceLabel(Canvas canvas, Recognition face, Rect scaledRect) {
    final textSpan = TextSpan(
      style: TextStyle(color: Colors.white, fontSize: 16),
      text: "${face.name} (${face.distance.toStringAsFixed(2)})",
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
        canvas,
        Offset(scaledRect.left, scaledRect.top - textPainter.height)
    );
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) => true;
}