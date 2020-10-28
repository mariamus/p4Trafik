import 'package:flutter/material.dart';

class Style {
  static final baseTextStyle = const TextStyle(
    fontFamily: 'Montserrat',
    color: const Color(0xFF00000000),
  );

  static final commonTextStyle = baseTextStyle.copyWith(
    fontSize: 14.0,
    fontWeight: FontWeight.w300,
  );

  static final smallTextStyle = baseTextStyle.copyWith(
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
  );

  static final titleTextStyle = baseTextStyle.copyWith(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
  );

  static final headerTextStyle = baseTextStyle.copyWith(
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
  );
}
