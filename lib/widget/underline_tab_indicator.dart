import 'package:flutter/material.dart';

class UnderlineTabIndicator extends Decoration {
  final BorderSide borderSide;
  final EdgeInsetsGeometry insets;

  const UnderlineTabIndicator({required this.borderSide, required this.insets});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _UnderlinePainter(this, onChanged);
  }
}

class _UnderlinePainter extends BoxPainter {
  final UnderlineTabIndicator decoration;

  _UnderlinePainter(this.decoration, VoidCallback? onChanged) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect rect = Offset(offset.dx + decoration.insets.horizontal / 2, configuration.size!.height - decoration.borderSide.width) & Size(configuration.size!.width - decoration.insets.horizontal, decoration.borderSide.width);
    final Paint paint = decoration.borderSide.toPaint()
      ..strokeCap = StrokeCap.square;
    canvas.drawLine(rect.bottomLeft, rect.bottomRight, paint);
  }
}