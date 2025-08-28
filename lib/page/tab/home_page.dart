import 'package:flutter/material.dart';
import 'package:shopping_client/common/constant.dart';
import 'package:shopping_client/common/custom_widget.dart';
import 'package:shopping_client/model/HomeModel.dart';
import 'package:shopping_client/model/MsgModel.dart';
import 'package:shopping_client/view/BaseScaffold.dart';

import '../../adapter/home_adapter.dart';
import '../../common/custom_color.dart';
import '../../model/ShopDetailModel.dart';
import '../../model/Records.dart';
import '../../repository/repository.dart';
import '../../routes/Routes.dart';

///首界面
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController? controller = TextEditingController();
  List<Records>? homeModels = [];
  ShopDetailModel? shopDetailModel;
  final ScrollController _scrollController = ScrollController();

  int pageSize = 50;

  @override
  void initState() {
    getData("");
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        pageSize += Constant.FLAG_TEN;
      }
    });
    getUncheckNotice();
    super.initState();
  }

  void getUncheckNotice() {
    backEndRepository.doGet(Constant.getUncheckNotice,
        successRequest: (res) {
      Data? msg;
      msg = Data.fromJson(res['data']);
      if (msg != null) {
      customWidget.showCheckNoticeDialog(context,
      title: msg!.title,
      msg: msg!.message,
      confirm: () => checkNotice(msg!.id));
      }
  });
}

   void checkNotice(id) {
    backEndRepository.doPut(Constant.checkNotice + id,
        successRequest: (res) {
  });
}

  void getData(merchantName) {
    backEndRepository.doPost(Constant.homes, params: {
      "pageNum": Constant.FLAG_ONE,
      "pageSize": pageSize,
      "merchantName": merchantName
    }, successRequest: (res) {
      homeModels = HomeModel.fromJson(res['data']).records;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        backgroundColor: CustomColor.white,
        appBar: customWidget.setAppBar(
            isLeftShow: false,
            isTitle: false,
            titleChild: customWidget.setTextFieldForLogin(controller,
                hintText: "店舗名を入力してください",
                textInputAction: TextInputAction.search,
                icon: "icon_search.png",
                onTap: () {
                  if (controller!.text.trim().isNotEmpty) {
                    getData("");
                  }
                },
                onChanged: (e) => getData(e),
                onSubmitted: (e) => getData(e)),
            isRightShow: true,
            right: Container(
                padding: const EdgeInsets.only(
                    right: 15, bottom: 12, left: 5, top: 5),
                child: const Icon(Icons.notifications)),
            onTap: () => Routes.goPage(context, "/MessagePage",param: {'tabIndex': 0})),
        body: RefreshIndicator(
            color: CustomColor.redE8,
            onRefresh: () async => getData(controller!.text),
            child: homeModels!.isEmpty
                ? CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                          child: Center(
                              child: customWidget.setAssetsImg("no_data_2.png",
                                  width: 160, height: 135)))
                    ],
                  )
                : ListView.builder(
                    itemCount: homeModels!.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    // controller: _scrollController,
                    itemBuilder: (_, index) => InkWell(
                          highlightColor: Colors.white,
                          child: HomeAdapter(homeModels![index]),
                          onTap: () async {
                            final id = homeModels![index].id;

                            try {
                              final res = await backEndRepository.doGetAsync(
                                  "${Constant.psMerchantDetail}$id");

                              final shopDetailModel =
                                  ShopDetailModel.fromJson(res['data']);

                              Routes.goPage(context, "/GoodsListPage", param: {
                                Constant.FLAG: id,
                                'shopDetailModel': shopDetailModel
                              });
                            } catch (e) {
                              print("加载失败: $e");
                              // 你可以加个提示框
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('加载失败，请稍后再试')),
                              );
                            }
                          },
                        ))));
  }

  @override
  void dispose() {
    controller?.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
