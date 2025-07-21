import 'package:flutter/material.dart';

class Date {
  DateTime date;
  Color? color;
  Color? textColor;
  Widget? icon;
  String toolTipArMessage;
  String toolTipEnMessage;
  String text;

  Date({
    required this.date,
    this.color,
    this.textColor,
    this.icon,
    this.toolTipEnMessage = '',
    this.toolTipArMessage = '',
    this.text = '',
  });
}
