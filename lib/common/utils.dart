import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'global.dart';

final utils = Utils();

class Utils {
  String getCurrentDate() {
    DateTime dateTime = DateTime.now();
    return formatDate(dateTime.toString());
  }

  String getCurrentTime() {
    DateTime dateTime = DateTime.now();
    return formatDate(dateTime.toString(), end: 19);
  }

  String formatDate(String date, {int end = 10}) {
    if (date.isNotEmpty && date.contains("-")) {
      return date.substring(0, end);
    }
    return "";
  }

  //String emailPattern = r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$';

  isEmail(email) {
    RegExp regex = RegExp("^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$");
    bool valid = regex.hasMatch(email);
    print(email);
    print(valid);
    return valid;
  }

  isPw(email) {
    RegExp regex = RegExp(r'^[a-zA-Z0-9]{8,16}$');
    bool valid = regex.hasMatch(email);
    print(email);
    print(valid);
    return valid;
  }

  isPhone(phone) {
    // '08012345678',
    RegExp pattern = RegExp(r'^(0(70|80|90)-\d{4}-\d{4}|0(70|80|90)\d{8})$');
    bool valid = pattern.hasMatch(phone);
    return valid;
  }


  String formatDateHm(String date) {
    if (date.isNotEmpty && date.contains("-")) {
      return date.substring(0, 16);
    }
    return "";
  }

  Size get getScreenSize => MediaQuery.of(Global.context!).size;

  EdgeInsets get edgeInsets => MediaQuery.of(Global.context!).padding;

  Future<void> callPhone(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> launchInBrowserView(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
