import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shopping_client/common/constant.dart';
import 'package:shopping_client/common/custom_widget.dart';
import 'package:shopping_client/model/MsgModel.dart';
import 'package:shopping_client/model/customer_merchants_model.dart';
import 'package:shopping_client/view/BaseScaffold.dart';
import '../../common/custom_color.dart';
import '../../model/ShopDetailModel.dart';
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
  Key _mapKey = UniqueKey();

  List<CustomerMerchantsModelRecords?> customerMerchantsModelRecords = [];
  late GoogleMapController _mapController;

  // 坐标
  List<LatLng> latlongPoint = [];
  double latitude = 35.82046850;
  double longitude = 139.77565940;
  final RxInt clickCount = 0.obs;
  String merchantName = "";
  final Rx<LatLngBounds?> _bounds = Rx<LatLngBounds?>(null);

  @override
  void initState() {
    getData();
    getUncheckNotice();
    debounce(
      clickCount,
      (_) async => _fetchDetail(),
      time: const Duration(milliseconds: 500),
    );
    debounce(
      _bounds,
      (_) async => _fetchMapdata(),
      time: const Duration(milliseconds: 2000),
    );
    super.initState();
  }

  _fetchMapdata() async {
    // ignore: unnecessary_null_comparison
    if (_mapController == null) return;
    final bounds = await _mapController.getVisibleRegion();

    final double minLat = bounds.southwest.latitude; // 南边界
    final double maxLat = bounds.northeast.latitude; // 北边界
    final double minLng = bounds.southwest.longitude; // 西边界
    final double maxLng = bounds.northeast.longitude; // 东边界

    backEndRepository.doPost(Constant.homes, params: {
      "latitude": latitude,
      "longitude": longitude,
      "merchantName": merchantName,
      "pageNum": Constant.FLAG_ONE,
      "minLat": minLat,
      "maxLat": maxLat,
      "minLng": minLng,
      "maxLng": maxLng
    }, successRequest: (res) {
      CustomerMerchantsModel customerMerchants =
          CustomerMerchantsModel.fromJson(res["data"] ?? {});
      List<LatLng> latlongPointData = [];
      for (var data in customerMerchants.records!) {
        latlongPointData.add(LatLng(
            double.parse(data!.latitude!), double.parse(data.longitude!)));
      }
      setState(() {
        customerMerchantsModelRecords = customerMerchants.records!;
        latlongPoint = latlongPointData;
      });
      _loadIcon();
    });
  }

  _fetchDetail() async {
    final id = infoData.id;
    final res =
        await backEndRepository.doGetAsync("${Constant.psMerchantDetail}$id");

    final shopDetailModel = ShopDetailModel.fromJson(res['data']);

    if (context.mounted) {
      Routes.goPage(context, "/GoodsListPage",
          param: {Constant.FLAG: id, 'shopDetailModel': shopDetailModel});
    }
  }

  Future<void> _onCameraIdle() async {
    final bounds = await _mapController.getVisibleRegion();
    _bounds.value = bounds;
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

  Future<void> getData() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return Future.error('位置情報の利用を許可しましょう現在地周辺のパン屋さんを検索できます。');

    // 2. 检查/请求权限
    LocationPermission p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) {
      p = await Geolocator.requestPermission();
      if (p == LocationPermission.denied ||
          p == LocationPermission.deniedForever) {
        // return Future.error('无定位权限');
      }
    }

    // 3. 获取位置
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = pos.latitude;
      longitude = pos.longitude;
      _mapKey = UniqueKey();
    });
    _onCameraIdle();
  }

  // marker数据
  Set<Marker> markers = {};

  CustomerMerchantsModelRecords infoData =
      CustomerMerchantsModelRecords.fromJson({});

  late BitmapDescriptor _myIcon;

  Future<void> _loadIcon() async {
    _myIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(24, 24)), // 可指定显示尺寸
      'assets/marker.png',
    );
    displayInfo();
  }

  displayInfo() {
    Set<Marker> markersData = {};
    markersData.add(Marker(
      markerId: const MarkerId("0"),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(latitude, longitude),
    ));
    for (var i = 0; i < latlongPoint.length; i++) {
      markersData.add(Marker(
        markerId: MarkerId((i + 1).toString()),
        icon: _myIcon,
        position: latlongPoint[i],
        onTap: () {
          setState(() {
            infoData = customerMerchantsModelRecords[i]!;
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
      extendBodyBehindAppBar: true,
      appBar: customWidget.setAppBar(
          isLeftShow: false,
          isTitle: false,
          backgroundColor: Colors.transparent,
          titleChild: customWidget.setTextFieldForLogin(
            controller,
            hintText: "店舗名を入力してください",
            textInputAction: TextInputAction.search,
            icon: "icon_search.png",
            isFilled: true,
            isHaveBorder: false,
            onTap: () {
              if (controller!.text.trim().isNotEmpty) {
                getData();
              }
            },
            onChanged: (e) {
              merchantName = e;
              getData();
            },
            onSubmitted: (e) {
              merchantName = e;
              getData();
            },
          ),
          isRightShow: true,
          right: Container(
              padding:
                  const EdgeInsets.only(right: 15, bottom: 12, left: 5, top: 5),
              child: const Icon(
                Icons.notifications,
                color: CustomColor.black_3,
              )),
          onTap: () =>
              Routes.goPage(context, "/MessagePage", param: {'tabIndex': 0})),
      body: Stack(
        children: [
          GoogleMap(
            key: _mapKey,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 15,
            ),
            compassEnabled: false, // 隐藏指南针
            zoomControlsEnabled: false, // 隐藏缩放按钮（+ -）
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (c) => _mapController = c,
            onCameraIdle: _onCameraIdle,
            markers: markers,
            onTap: (argument) => setState(() {
              infoData = CustomerMerchantsModelRecords.fromJson({});
            }),
          ),
          if (infoData.id != "") ...[
            Positioned(
                top: 95,
                child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      infoData = CustomerMerchantsModelRecords.fromJson({});
                      merchantName = "";
                    });
                    getData();
                  },
                  child: Container(
                    width: Get.width,
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(30, 5, 30, 6),
                      decoration: BoxDecoration(
                          border: Border.all(color: CustomColor.redE8),
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.white),
                      child: customWidget.setText("このエリアで再検索",
                          color: CustomColor.redE8, fontSize: 15),
                    ),
                  ),
                )),
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
                        child: CachedNetworkImage(
                          imageUrl:
                              '${Constant.picture_url}${infoData.filePath}',
                          placeholder: (context, url) => const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  CustomColor.redE8),
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.image,
                            color: CustomColor.blackD,
                          ),
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => clickCount.value++,
                        child: Container(
                          width: Get.width - 60 - 80 - 15,
                          margin: const EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customWidget.setText(
                                infoData.merchantName ?? "",
                                color: CustomColor.black_3,
                                fontWeight: FontWeight.bold,
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              customWidget.setText(
                                infoData.merchantDescription ?? "",
                                color: CustomColor.black_3,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ))
          ]
        ],
      ),
    );
  }
}
