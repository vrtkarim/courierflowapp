import 'package:flutter/material.dart';

class QRScannerOverlayPainter extends CustomPainter {
  final Color borderColor;
  final double borderRadius;
  final double borderLength;
  final double borderWidth;
  final Color? overlayColor;

  QRScannerOverlayPainter({
    required this.borderColor,
    required this.borderRadius,
    required this.borderLength,
    required this.borderWidth,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final scanAreaSize = width * 0.7;
    final scanAreaLeft = (width - scanAreaSize) / 2;
    final scanAreaTop = (height - scanAreaSize) / 2;
    final scanAreaRight = scanAreaLeft + scanAreaSize;
    final scanAreaBottom = scanAreaTop + scanAreaSize;
    
    // Draw the semi-transparent overlay
    final backgroundPaint = Paint()
      ..color = overlayColor!
      ..style = PaintingStyle.fill;
    
    // Draw the overlay with a cutout for the scan area
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, width, height))
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTRB(scanAreaLeft, scanAreaTop, scanAreaRight, scanAreaBottom),
        Radius.circular(borderRadius),
      ))
      ..fillType = PathFillType.evenOdd;
      
    canvas.drawPath(backgroundPath, backgroundPaint);
    
    // Draw the corner borders
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    
    // Top left corner
    canvas.drawPath(
      Path()
        ..moveTo(scanAreaLeft, scanAreaTop + borderLength)
        ..lineTo(scanAreaLeft, scanAreaTop + borderRadius)
        ..arcToPoint(
          Offset(scanAreaLeft + borderRadius, scanAreaTop),
          radius: Radius.circular(borderRadius),
        )
        ..lineTo(scanAreaLeft + borderLength, scanAreaTop),
      borderPaint,
    );
    
    // Top right corner
    canvas.drawPath(
      Path()
        ..moveTo(scanAreaRight - borderLength, scanAreaTop)
        ..lineTo(scanAreaRight - borderRadius, scanAreaTop)
        ..arcToPoint(
          Offset(scanAreaRight, scanAreaTop + borderRadius),
          radius: Radius.circular(borderRadius),
        )
        ..lineTo(scanAreaRight, scanAreaTop + borderLength),
      borderPaint,
    );
    
    // Bottom right corner
    canvas.drawPath(
      Path()
        ..moveTo(scanAreaRight, scanAreaBottom - borderLength)
        ..lineTo(scanAreaRight, scanAreaBottom - borderRadius)
        ..arcToPoint(
          Offset(scanAreaRight - borderRadius, scanAreaBottom),
          radius: Radius.circular(borderRadius),
        )
        ..lineTo(scanAreaRight - borderLength, scanAreaBottom),
      borderPaint,
    );
    
    // Bottom left corner
    canvas.drawPath(
      Path()
        ..moveTo(scanAreaLeft + borderLength, scanAreaBottom)
        ..lineTo(scanAreaLeft + borderRadius, scanAreaBottom)
        ..arcToPoint(
          Offset(scanAreaLeft, scanAreaBottom - borderRadius),
          radius: Radius.circular(borderRadius),
        )
        ..lineTo(scanAreaLeft, scanAreaBottom - borderLength),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}