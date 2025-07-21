import 'package:flutter/material.dart';
import 'package:shopping_client/common/custom_color.dart';
import 'package:shopping_client/common/custom_widget.dart';
import 'package:shopping_client/repository/repository.dart';
import 'package:shopping_client/view/BaseScaffold.dart';

import '../../adapter/chat_adapter.dart';
import '../../adapter/order_pay_adapter.dart';
import '../../common/constant.dart';
import '../../common/utils.dart';
import '../../model/GoodModel.dart';
import '../../model/GoodsModel.dart';

class ChatPage extends StatefulWidget {
  final Map map;

  const ChatPage(this.map, {super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<GoodModel>? chats = [];
  final TextEditingController controller = TextEditingController();
  ScrollController? scrollController = ScrollController();

  @override
  void initState() {
    backEndRepository.doGet(Constant.remarkOrderList + widget.map[Constant.ID],
        successRequest: (res) {
      chats = GoodsModel.fromJson(res).data;
      setState(() {});
      scrollBottom();
    });
    super.initState();
  }

  void scrollBottom() {
    WidgetsBinding.instance.addPostFrameCallback((e) {
      scrollController?.jumpTo(scrollController!.position.maxScrollExtent);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        appBar: customWidget.setAppBar(title: "チャット"),
        backgroundColor: CustomColor.white,
        body: Column(
          children: [
            Expanded(
                child: ListView.separated(
                    itemCount: chats!.length,
                    shrinkWrap: true,
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const SizedBox(height: 20),
                    itemBuilder: (_, index) => ChatAdapter(chats![index]))),
            Container(
              height: 80,
              color: CustomColor.white,
              child: Row(
                children: [
                  Expanded(
                      child: customWidget.setTextFieldForLogin(controller,
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          maxLength: 50,
                          hintText: "チャット",
                          onChanged: (e) => scrollBottom())),
                  customWidget.setCupertinoButton("送信",
                      height: 41,
                      minimumSize: 70,
                      margin: const EdgeInsets.only(right: 15, bottom: 5), onPressed: () {
                    backEndRepository.doPost(Constant.remarkOrder, params: {
                      "orderId": widget.map[Constant.ID],
                      "remark": controller.text.trim(),
                      "businessType": "2"
                    }, successRequest: (res) {
                      // chats!.add(GoodModel(
                      //     remark: controller.text.trim(),
                      //     createTime: utils.getCurrentTime(),
                      //     businessType: "2"));
                      setState(() {});
                      scrollBottom();
                      controller.clear();
                    });
                  })
                ],
              ),
            )
          ],
        ));
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController?.dispose();
    super.dispose();
  }
}
