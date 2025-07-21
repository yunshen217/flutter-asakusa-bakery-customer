import 'package:flutter/material.dart';
import 'package:shopping_client/model/MsgModel.dart';
import 'package:shopping_client/repository/repository.dart';

import '../../common/constant.dart';
import '../../common/custom_color.dart';
import '../../common/custom_widget.dart';
import '../../routes/Routes.dart';
import '../../view/BaseScaffold.dart';

class MessagePage extends StatefulWidget {
  final Map map;
  const MessagePage(this.map, {super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> with SingleTickerProviderStateMixin {
  List<Tab> tabs = [const Tab(text: "あなた宛"), const Tab(text: "みんな宛")];
  List<Data>? msgs = [];
  int _currentIndex = 0;
  late TabController _tabController;

  @override
  void initState() {

    _currentIndex = widget.map['tabIndex'] ?? 0;
    getData(_currentIndex);
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this, initialIndex: _currentIndex);
  }

    @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void getData(tag) {
    if (tag == 1) {
      backEndRepository.doGet(Constant.getSystemNotice,
        successRequest: (res) {
      msgs = MsgModel.fromJson(res).data;
      setState(() {});
    });
    } else {
      backEndRepository.doGet(Constant.getMessageList,
        successRequest: (res) {
      msgs = MsgModel.fromJson(res).data;
      setState(() {});
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabs.length,
        child: BaseScaffold(
          backgroundColor: CustomColor.white,
          appBar: customWidget.setAppBar(
              isLeftShow: false,
              title: "お知らせ",
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(50),
                  child: Column(
                    children: [
                      Container(
                          height: 1,
                          width: double.infinity,
                          color: CustomColor.grayF5),
                      Container(
                          height: 50,
                          color: CustomColor.white,
                          alignment: Alignment.centerLeft,
                          child: Container(
                              margin: const EdgeInsets.only(
                                  top: 8, bottom: 8, left: 15),
                              width: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                  border: Border.all(
                                      color: CustomColor.redE8, width: 1)),
                              child: customWidget.setTabBar(tabs,
                                  controller: _tabController,
                                  indicatorPadding: EdgeInsets.zero,
                                  fontSize: 12,
                                  borderRadius: 10,
                                  unselectedLabelColor: CustomColor.redE8,
                                  onTab: (e) => getData(e)))),
                      Container(
                          height: 5,
                          width: double.infinity,
                          color: CustomColor.grayF5)
                    ],
                  ))),
          body: msgs!.isNotEmpty
              ? ListView.separated(
                  itemCount: msgs!.length,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(15),
                  separatorBuilder: (context, index) => Container(
                      height: 1,
                      color: CustomColor.grayE,
                      margin: const EdgeInsets.only(top: 15, bottom: 15)),
                  itemBuilder: (_, index) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 0.0,
                      minTileHeight: 50,
                      title: customWidget.setText(msgs![index].message!,
                          fontWeight: FontWeight.bold),
                      subtitle: customWidget.setText(msgs![index].createTime!,
                          color: CustomColor.gray_9, fontSize: 12),
                      trailing: customWidget.setText("[既読]",
                          color: CustomColor.grayC5, fontSize: 12),
                      onTap: () {
                        if (msgs![index].businessId != null && msgs![index].businessId!.isNotEmpty) {
                          Routes.goPage(context, "/OrderDetailPage",
                              param: {Constant.ID: msgs![index].businessId});
                        } else {
                          customWidget.showNoticeDialog(context, title: msgs![index].title, msg:msgs![index].message);
                        }
                      }))
              : Center(
                  child: customWidget.setAssetsImg("no_data_2.png",
                      width: 160, height: 135)),
        ));
  }
}
