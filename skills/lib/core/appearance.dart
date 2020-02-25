import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class GradientFromBottom extends LinearGradient {
  final Color baseColor;
  final Color accentColor;

  GradientFromBottom({this.accentColor, this.baseColor})
      : super(colors: [accentColor, baseColor]);

  @override
  AlignmentGeometry get end => Alignment.bottomCenter;

  @override
  AlignmentGeometry get begin => Alignment.topCenter;

  @override
  List<double> get stops => [0.01, 0.15];

  
}
