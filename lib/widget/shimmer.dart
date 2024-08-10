import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerScreenLoading extends StatelessWidget {
  final double height;
  final double width;
  final double radius;
  const ShimmerScreenLoading(
      {Key? key,
      required this.height,
      required this.width,
      required this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Color(0xffE9ECEF),
        highlightColor: Color(0xffE9ECEF).withOpacity(0.2),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(radius))),
          height: height,
          width: width,
        ));
  }
}
