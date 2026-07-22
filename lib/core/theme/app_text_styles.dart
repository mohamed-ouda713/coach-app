import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle _base(double size, FontWeight weight, {double? height}) {
    return TextStyle(
      fontFamily: 'IBMPlexSansArabic',
      fontSize: size,
      fontWeight: weight,
      height: height,
    );
  }

  static TextStyle get displayXL => _base(32, FontWeight.w700);
  static TextStyle get display => _base(28, FontWeight.w700);

  static TextStyle get h1 => _base(24, FontWeight.w700);
  static TextStyle get h2 => _base(20, FontWeight.w600);
  static TextStyle get h3 => _base(18, FontWeight.w600);
  static TextStyle get h4 => _base(16, FontWeight.w600);
  static TextStyle get h5 => _base(14, FontWeight.w600);

  static TextStyle get sectionLabel => _base(13, FontWeight.w600);

  static TextStyle get buttonL => _base(16, FontWeight.w600);
  static TextStyle get buttonM => _base(14, FontWeight.w600);
  static TextStyle get buttonS => _base(13, FontWeight.w500);

  static TextStyle get bodyL => _base(16, FontWeight.w400);
  static TextStyle get bodyM => _base(14, FontWeight.w400);
  static TextStyle get bodyRegular => _base(14, FontWeight.w400);
  static TextStyle get bodyS => _base(13, FontWeight.w400);

  static TextStyle get fieldLabel => _base(13, FontWeight.w500);

  static TextStyle get caption => _base(12, FontWeight.w400);
  static TextStyle get captionMedium => _base(12, FontWeight.w500);

  static TextStyle get tiny => _base(11, FontWeight.w400);
  static TextStyle get tinyBold => _base(11, FontWeight.w700);
}
