import 'package:flutter/material.dart';
import 'package:shopping_client/common/constant.dart';
import 'package:shopping_client/common/custom_widget.dart';
import 'package:shopping_client/view/BaseScaffold.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final Map map;

  const WebViewPage(this.map, {super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController? _controller;

  @override
  void initState() {
    _controller = WebViewController();
    _controller!.loadRequest(Uri.parse(widget.map[Constant.FLAG]));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        appBar: customWidget.setAppBar(title: "特定商取引法リンク"),
        body: WebViewWidget(controller: _controller!));
  }
}
