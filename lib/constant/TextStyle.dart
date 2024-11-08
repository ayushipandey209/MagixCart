import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle poppinsTextStyle({
  double? fontSize,
  FontWeight? fontWeight,
  FontStyle? fontStyle,
  Color? color,
}) {
  return GoogleFonts.poppins(
    fontSize: fontSize ?? 14.0,
    fontWeight: fontWeight ?? FontWeight.normal,
    fontStyle: fontStyle ?? FontStyle.normal,
    color: color ?? Colors.black,
  );
}