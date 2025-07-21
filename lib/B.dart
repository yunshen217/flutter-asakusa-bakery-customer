import 'package:flutter/material.dart';
import 'package:shopping_client/routes/Routes.dart';
import 'package:shopping_client/view/CustomFloatingActionButtonLocation.dart';
import 'package:shopping_client/view/shop_car/add_to_cart_animation.dart';

import 'adapter/goods_list_adapter.dart';
import 'common/custom_color.dart';
import 'common/custom_widget.dart';
import 'common/utils.dart';

class B extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<B> {
  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;
  var _cartQuantityItems = 0;

  @override
  Widget build(BuildContext context) {
    return AddToCartAnimation(
      cartKey: cartKey,
      dragAnimation: const DragToCartAnimationOptions(curve: Curves.easeInToLinear),
      jumpAnimation: const JumpAnimationOptions(),
      createAddToCartAnimation: (runAddToCartAnimation) {
        this.runAddToCartAnimation = runAddToCartAnimation;
      },
      child: Scaffold(
          floatingActionButtonLocation:
              CustomFloatingActionButtonLocation(FloatingActionButtonLocation.centerDocked, 0, 35),
          floatingActionButton: Container(
            height: 100.0,
            padding: EdgeInsets.only(left: 15, right: 15, bottom: utils.edgeInsets.top),
            color: CustomColor.white,
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AddToCartIcon(
                  key: cartKey,
                  icon: const Icon(Icons.shopping_cart),
                  onTap: (){},
                  badgeOptions: const BadgeOptions(
                      backgroundColor: Colors.red, foregroundColor: Colors.white),
                  price: 0,
                ),
                customWidget.setCupertinoButton("購入の確認",
                    height: 40,
                    minimumSize: 150,
                    onPressed: () => Routes.goPage(context, "/OrderPayPage"))
              ],
            ),
          ),
          body: ListView(
            children: List.generate(
              15,
              (index) => AppListItem(
                onClick: listClick,
                index: index,
              ),
            ),
          )),
    );
  }

  void listClick(GlobalKey widgetKey) async {
    await runAddToCartAnimation(widgetKey);
    await cartKey.currentState!.runCartAnimation((++_cartQuantityItems).toString());
  }
}

class AppListItem extends StatelessWidget {
  final GlobalKey widgetKey = GlobalKey();
  final int index;
  final void Function(GlobalKey) onClick;

  AppListItem({super.key, required this.onClick, required this.index});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onClick(widgetKey),
      leading: Container(
        key: widgetKey,
        width: 60,
        height: 60,
        color: Colors.transparent,
        child: Image.network(
          "https://cdn.jsdelivr.net/gh/omerbyrk/add_to_cart_animation/example/assets/apple.png",
          width: 60,
          height: 60,
        ),
      ),
      title: Text(
        "Animated Apple Product Image $index",
      ),
    );
  }
}
