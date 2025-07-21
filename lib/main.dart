import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:shopping_client/common/constant.dart';
import 'package:shopping_client/page/tab/bread_page.dart';
import 'package:shopping_client/page/tab/home_page.dart';
import 'package:shopping_client/page/tab/mine_page.dart';
import 'package:shopping_client/page/tab/order_page.dart';
import 'package:shopping_client/page/login/login_page.dart';
import 'package:shopping_client/routes/routes.dart';
import 'package:shopping_client/view/BaseScaffold.dart';
import 'package:shopping_client/view/NavigationIconView.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';

import 'common/InitEventBus.dart';
import 'common/custom_color.dart';
import 'common/custom_widget.dart';
import 'common/global.dart';
import 'common/navigation_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initFCM();
  initDeepLinkListener();
  Global.init().then((e) => runApp(const MyApp()));
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark));
}

initFCM() async {
  try {
    await Firebase.initializeApp();
    _requestPermissions();
    FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    ///监听后台通知点击事件
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print('App was opened from a notification!');
      print('Message data: ${initialMessage.data}');
      if (initialMessage.notification != null) {
        print(
            'Message also contained a notification: ${initialMessage.notification}');
      }
      // 在这里可以根据消息内容执行相应的导航或操作
    }
    await getDeviceToken();
  } catch (e) {
    print("====>$e");
  }
}

///前台消息
Future<void> _firebaseMessagingForegroundHandler(RemoteMessage message) async {
  print('Got a message whilst in the foreground!');
  print('Message data: ${message.data}');
  if (message.data['messageType'] != "0") {
    Routes.goPage(Get.context!, "/OrderDetailPage", param: {
                                    Constant.ID: message.data['orderId']
                                  });
  } else {
    Routes.goPage(Get.context!, "/MessagePage", param: {'tabIndex': 1});
  }
}

/// 监听前台通知点击事件
_onMessageOpenedApp(RemoteMessage message) {
  print('A new onMessageOpenedApp event was published!');
  print('Message data: ${message.data}');
  if (message.data['messageType'] != "0") {
    Routes.goPage(Get.context!, "/OrderDetailPage", param: {
                                    Constant.ID: message.data['orderId']
                                  });
  } else {
    Routes.goPage(Get.context!, "/MessagePage", param: {'tabIndex': 1});
  }
}

///后台消息
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(message);
  print('Handling a background message: ${message.messageId}');
    if (message.data['messageType'] != "0") {
    Routes.goPage(Get.context!, "/OrderDetailPage", param: {
                                    Constant.ID: message.data['orderId']
                                  });
  } else {
    Routes.goPage(Get.context!, "/MessagePage", param: {'tabIndex': 1});
  }
}

///token
Future<void> getDeviceToken() async {
  // if (Platform.isIOS) {
  //   String? token = await FirebaseMessaging.instance.getAPNSToken();
  //   print('Device Token: $token');
  //   Global.putToken(token);
  // } else {
  //   String? token = await FirebaseMessaging.instance.getToken();
  //   print('Device Token: $token');
  //   Global.putToken(token);
  // }
  String? token = await FirebaseMessaging.instance.getToken();
  Global.putToken(token);
  print('Device Token: $token');
}

Future<void> _requestPermissions() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true);
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeData(
            radioTheme: RadioThemeData(
              fillColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return CustomColor.redE8;
                }
                return Colors.grey;
              }),
            ),
            appBarTheme: const AppBarTheme(
                color: Colors.white, surfaceTintColor: Colors.transparent),
            scaffoldBackgroundColor: Colors.white),
        onGenerateRoute: onGenerateRoute,
        // initialRoute: Global.token.isEmpty ? "/LoginPage" : "/",
        navigatorObservers: [FlutterSmartDialog.observer],
        builder: FlutterSmartDialog.init(),
        navigatorKey: NavigationService.navigatorKey, // 设置 navigatorKey
        routes: {
          '/LoginPage': (context) => LoginPage(),
          // 其他页面路由
        },
        home: const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ///底部bottom tab start
  int _selectedIndex = 0;

  ///tab展示的界面
  final tabs = [
    const HomePage(),
    const BreadPage(),
    const OrderPage(),
    const MinePage()
  ];

  /// tab 展示title
  final tabTitle = ['店舗', "商品", "注文", "マイページ"];
  List<NavigationIconView> _navigationIconView = [];
  List<String> bottomSelectIcons = [
    "icon_tab_red_1.png",
    "icon_tab_red_2.png",
    "icon_tab_red_3.png",
    "icon_tab_red_4.png"
  ];
  List<String> bottomUnSelectIcons = [
    "icon_tab_black_1.png",
    "icon_tab_black_2.png",
    "icon_tab_black_3.png",
    "icon_tab_black_4.png"
  ];

  @override
  void initState() {
    Global.context = context;
    EventBusUtil.listen((e) {
      if (e == Constant.ID) {
        //_onItemTapped(0);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _navigationIconView = [
      for (var i = 0; i < tabTitle.length; i++)
        NavigationIconView(
            title: tabTitle[i],
            icon: bottomUnSelectIcons[i],
            activedIconPath: bottomSelectIcons[i])
    ];

    return BaseScaffold(
        bottomNavigationBar: _bottomNavigationBar(),
        body: IndexedStack(index: _selectedIndex, children: tabs),
        onBack: () => exit(0));
  }

  ///底部菜单栏
  _bottomNavigationBar() => BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      items: _navigationIconView.map((view) => view.item).toList(),
      onTap: _onItemTapped,
      selectedItemColor: CustomColor.redE8,
      selectedLabelStyle:
          customWidget.setTextStyle(color: CustomColor.redE8, fontSize: 13),
      unselectedItemColor: CustomColor.black_3,
      unselectedLabelStyle: customWidget.setTextStyle(
          color: CustomColor.black_3,
          fontSize: 12,
          fontWeight: FontWeight.normal));

  void _onItemTapped(int value) {
    setState(() => _selectedIndex = value);
    if (_selectedIndex == 2 && Global.userInfo!.refreshToken == null) {
      customWidget.showCustomSingleBtnDialog(context,
          confirm: () => Routes.goPage(context, "/LoginPage"));
    } else if (_selectedIndex == 2 ) {
      EventBusUtil.fire(Constant.REFRESH_O);
    }
  }
}

StreamSubscription? _deepLinkSub;

void initDeepLinkListener() {
  _deepLinkSub = uriLinkStream.listen((Uri? uri) {
    if (uri != null) {
      print("收到 Deep Link: $uri");
      if (uri.scheme == "user" &&
          uri.host == "order" &&
          uri.path == "/completed") {
        //
      }
    }
  }, onError: (err) {
    print("Deep Link 监听失败: $err");
  });
}
