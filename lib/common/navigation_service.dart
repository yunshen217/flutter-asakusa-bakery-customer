import 'package:flutter/material.dart';
import 'package:shopping_client/routes/routes.dart';
import 'custom_widget.dart';
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentContext;

  static void goLoginPage() {
    customWidget.showCustomSingleBtnDialog(context,
                                confirm: () => Routes.goPage(context!, "/LoginPage"));
    //navigatorKey.currentState?.pushNamedAndRemoveUntil('/LoginPage', (route) => false);
  }
}
