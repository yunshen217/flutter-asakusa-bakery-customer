import 'package:flutter/material.dart';
import 'package:shopping_client/common/custom_widget.dart';

import '../common/custom_color.dart';

//自定义底部导航栏itme

class NavigationIconView {
  final BottomNavigationBarItem item;

  //标题
  final String title;

  //图标
  final String icon;

  //选中图标路径
  final String activedIconPath;

  NavigationIconView({required this.title, required this.icon, required this.activedIconPath})
      : item = BottomNavigationBarItem(
            //默认图标
            icon: customWidget.setAssetsImg(icon),
            //选中状态
            activeIcon: customWidget.setAssetsImg(activedIconPath),
            label: title);
}
