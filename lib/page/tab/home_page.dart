
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shopping_client/common/constant.dart';
import 'package:shopping_client/common/custom_widget.dart';
import 'package:shopping_client/model/HomeModel.dart';
import 'package:shopping_client/model/MsgModel.dart';
import 'package:shopping_client/view/BaseScaffold.dart';
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
    _loadIcon();
    super.initState();
  }

  void getUncheckNotice() {
    backEndRepository.doGet(Constant.getUncheckNotice, successRequest: (res) {
      Data? msg;
      msg = Data.fromJson(res['data']);
      // ignore: unnecessary_null_comparison
      if (msg != null) {
        customWidget.showCheckNoticeDialog(context,
            title: msg.title,
            msg: msg.message,
            confirm: () => checkNotice(msg!.id));
      }
    });
  }

  void checkNotice(id) {
    backEndRepository.doPut(Constant.checkNotice + id,
        successRequest: (res) {});
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

  // marker数据
  Set<Marker> markers = {};
  // 坐标
  List<LatLng> latlongPoint = [
    const LatLng(28.5175, 81.7787),
    const LatLng(27.7293, 85.3343),
    const LatLng(28.2096, 83.9856),
  ];
  Map infoData = {};
  List infoDataList = [
    {
      "img":
          "https://www.wfzssz.com/resource/images/16e90e693cfb4268913a7bd20cb50acb_30.jpg",
      "title": "店铺名称",
      "subTitle": "副标题",
    },
    {
      "img": "https://img95.699pic.com/photo/50126/6306.jpg_wh860.jpg",
      "title": "店铺名称",
      "subTitle": "副标题",
    },
    {
      "img": "https://img95.699pic.com/photo/50132/9112.jpg_wh860.jpg",
      "title": "店铺名称",
      "subTitle": "副标题",
    }
  ];

  late BitmapDescriptor _myIcon;

  Future<void> _loadIcon() async {
  _myIcon = await BitmapDescriptor.fromAssetImage(
    const ImageConfiguration(size: Size(24, 24)), // 可指定显示尺寸
    'assets/marker.png',
  );
  // 生成 markers
  displayInfo();
}

  displayInfo() {
    Set<Marker> markersData = {};
    for (var i = 0; i < latlongPoint.length; i++) {
      markersData.add(Marker(
        markerId: MarkerId(i.toString()),
        icon: _myIcon,
        position: latlongPoint[i],
        onTap: () {
          setState(() {
            infoData = infoDataList[i];
          });
        },
      ));
    }
    setState(() {
      markers = markersData;
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
              padding:
                  const EdgeInsets.only(right: 15, bottom: 12, left: 5, top: 5),
              child: const Icon(Icons.notifications)),
          onTap: () =>
              Routes.goPage(context, "/MessagePage", param: {'tabIndex': 0})),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(28.2096, 83.9856),
              zoom: 7,
            ),
            compassEnabled: false, // 隐藏指南针
            zoomControlsEnabled: false, // 隐藏缩放按钮（+ -）
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            markers: markers,
            onTap: (argument) => setState(() {
              infoData = {};
            }),
          ),
          if (infoData.isNotEmpty)
            Positioned(
                bottom: 21,
                child: Container(
                  width: Get.width - 30,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          infoData["img"] ?? "",
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customWidget.setText(infoData["title"] ?? "",
                                color: CustomColor.black_3,
                                fontWeight: FontWeight.bold),
                            customWidget.setText(infoData["subTitle"] ?? "",
                                color: CustomColor.black_3,
                                margin: const EdgeInsets.only(top: 5, bottom: 15)),
                            customWidget.setCupertinoButton("这是标签",
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                height: 20,
                                minimumSize: 80,
                                padding: const EdgeInsets.only(bottom: 1),
                                onPressed: () {})
                          ],
                        ),
                      )
                    ],
                  ),
                ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
