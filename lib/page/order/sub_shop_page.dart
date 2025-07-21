import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shopping_client/common/constant.dart';
import 'package:shopping_client/common/custom_color.dart';
import 'package:shopping_client/common/custom_widget.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:shopping_client/repository/repository.dart';
import 'package:shopping_client/view/BaseScaffold.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../common/utils.dart';
import '../../model/ShopDetailModel.dart';
import '../../routes/Routes.dart';

class SubShopPage extends StatefulWidget {
  final Map map;

  const SubShopPage(this.map, {super.key});

  @override
  State<SubShopPage> createState() => _SubShopPageState();
}

class _SubShopPageState extends State<SubShopPage> with AutomaticKeepAliveClientMixin {
  ShopDetailModel? shopDetailModel;

  @override
  void initState() {
    shopDetailModel = widget.map['shopDetailModel'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BaseScaffold(
        backgroundColor: CustomColor.white,
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            if (shopDetailModel != null)
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: 350,
                        child: Swiper(
                            itemBuilder: (context, index) {
                              return Image.network(
                                  "${Constant.picture_url}${shopDetailModel!.banFilePathList![index]}",
                                  fit: BoxFit.cover);
                            },
                            autoplay: true,
                            itemCount: shopDetailModel!.banFilePathList!.length,
                            containerHeight: 100,
                            scrollDirection: Axis.horizontal,
                            pagination: const SwiperPagination(
                                alignment: Alignment.bottomCenter,
                                builder: SwiperPagination.dots))),
                    customWidget.setText("${shopDetailModel?.merchantName}",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        margin: const EdgeInsets.only(top: 10, left: 15, right: 15)),
                    Row(
                      children: [
                        customWidget.setAssetsImg("icon_position.png",
                            margin: const EdgeInsets.only(left: 10)),
                        customWidget.setText(shopDetailModel!.getAddress,
                            color: CustomColor.gray_6, fontWeight: FontWeight.w500, fontSize: 12)
                      ],
                    ),
                    customWidget.setText("${shopDetailModel!.merchantDescription}",
                        margin: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15)),
                    Container(color: CustomColor.grayF5, height: 5),
                  ],
                ),
              ),
            if (shopDetailModel != null)
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customWidget.setText("店舗情報",
                        fontWeight: FontWeight.bold, margin: const EdgeInsets.all(15)),
                    customWidget.setText(shopDetailModel!.getAddress,
                        color: CustomColor.gray_6,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        margin: const EdgeInsets.only(left: 15, bottom: 5)),
                    // Container(height: 220, color: CustomColor.info),
                    Container(
                      height: 200,
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: GoogleMap(
                          zoomControlsEnabled: false,
                          myLocationButtonEnabled: false,
                          zoomGesturesEnabled: false,
                          initialCameraPosition: CameraPosition(
                              target: LatLng(
                                  shopDetailModel!.getLongitude!, shopDetailModel!.getLatitude!),
                              zoom: 14),
                          markers: <Marker>{
                            Marker(
                                markerId: const MarkerId(""),
                                position: LatLng(
                                    shopDetailModel!.getLongitude!, shopDetailModel!.getLatitude!))
                          }),
                    ),
                    Center(
                        child: customWidget.setCupertinoButton("地図アプリで見る",
                            height: 25,
                            fontSize: 12,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            fontWeight: FontWeight.normal,
                            onPressed: () => utils.launchInBrowserView(
                                "https://www.google.com/maps/search/?api=1&query=${shopDetailModel!.getLongitude!},${shopDetailModel!.getLatitude!}"))),
                    Container(
                        height: 1,
                        color: CustomColor.grayE,
                        margin: const EdgeInsets.only(left: 15, right: 15)),
                    customWidget.setText("定休日",
                        color: CustomColor.gray_6,
                        margin: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10)),
                    customWidget.setText("${shopDetailModel!.getHoliday()}",
                        color: CustomColor.black_3,
                        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10)),
                    Container(
                        height: 1,
                        color: CustomColor.grayE,
                        margin: const EdgeInsets.only(left: 15, right: 15)),
                    customWidget.setText("営業時間",
                        color: CustomColor.gray_6,
                        margin: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10)),
                    customWidget.setText(
                        "${shopDetailModel!.beginTime()}-${shopDetailModel!.endTime()}",
                        color: CustomColor.black_3,
                        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10)),
                    Container(
                        height: 1,
                        color: CustomColor.grayE,
                        margin: const EdgeInsets.only(left: 15, right: 15)),
                    ListTile(
                        contentPadding: const EdgeInsets.only(left: 15, right: 5),
                        leading: customWidget.setAssetsImg("icon_call.png"),
                        title: customWidget.setText("${shopDetailModel!.phoneNumber}",
                            color: CustomColor.redE8, fontWeight: FontWeight.bold),
                        onTap: () => utils.callPhone("${shopDetailModel!.phoneNumber}")),
                    Container(
                        height: 1,
                        color: CustomColor.grayE,
                        margin: const EdgeInsets.only(left: 15, right: 15)),
                    ListTile(
                        contentPadding: const EdgeInsets.only(left: 15, right: 5),
                        leading: customWidget.setAssetsImg("icon_rice.png"),
                        title: customWidget.setText(shopDetailModel!.getEatingArea,
                            color: CustomColor.black_3)),
                    // Row(
                    //   children: [
                    //     customWidget.setAssetsImg("icon_rice.png",
                    //         margin: const EdgeInsets.only(left: 15)),
                    //     customWidget.setText("1760071991",
                    //         color: CustomColor.black_3,
                    //         margin: const EdgeInsets.only(left: 10, right: 15, top: 10, bottom: 10)),
                    //   ],
                    // ),
                    Container(
                        height: 1,
                        color: CustomColor.grayE,
                        margin: const EdgeInsets.only(left: 15, right: 15)),
                    customWidget.setText("SNS",
                        color: CustomColor.gray_6,
                        margin: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10)),

                    Row(
                      children: [
                        Visibility(
                            visible: shopDetailModel!.snsLink1!.isNotEmpty,
                            child: InkWell(
                                highlightColor: Colors.white,
                                child: customWidget.setAssetsImg(
                                    _imgType(shopDetailModel!.snsType1),
                                    width: 30,
                                    height: 30,
                                    margin: const EdgeInsets.only(left: 15)),
                                onTap: () =>
                                    utils.launchInBrowserView(shopDetailModel!.snsLink1!))),
                        Visibility(
                            visible: shopDetailModel!.snsLink2!.isNotEmpty,
                            child: InkWell(
                                highlightColor: Colors.white,
                                child: customWidget.setAssetsImg(
                                    _imgType(shopDetailModel!.snsType2),
                                    width: 30,
                                    height: 30,
                                    margin: const EdgeInsets.only(left: 15)),
                                onTap: () =>
                                    utils.launchInBrowserView(shopDetailModel!.snsLink2!))),

                        Visibility(
                            visible: shopDetailModel!.snsLink3!.isNotEmpty,
                            child: InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: customWidget.setAssetsImg(
                                    _imgType(shopDetailModel!.snsType3),
                                    width: 30,
                                    height: 30,
                                    margin: const EdgeInsets.only(left: 15)),
                                onTap: () =>
                                    utils.launchInBrowserView(shopDetailModel!.snsLink3!))),
                        Visibility(
                            visible: shopDetailModel!.snsLink4!.isNotEmpty,
                            child: InkWell(
                                highlightColor: Colors.white,
                                child: customWidget.setAssetsImg(
                                    _imgType(shopDetailModel!.snsType4),
                                    width: 30,
                                    height: 30,
                                    margin: const EdgeInsets.only(left: 15)),
                                onTap: () =>
                                    utils.launchInBrowserView(shopDetailModel!.snsLink4!))),
                      ],
                    ),
                    Container(
                        height: 1,
                        color: CustomColor.grayE,
                        margin: const EdgeInsets.only(left: 15, right: 15, top: 10)),
                    customWidget.setText("ホームページ",
                        color: CustomColor.gray_6,
                        margin: const EdgeInsets.only(left: 15, right: 15, top: 10)),
                    InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: customWidget.setText("https://www.asakusa-bakery.com",
                            color: CustomColor.redE8,
                            padding:
                                const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10)),
                        onTap: () => utils.launchInBrowserView("https://www.asakusa-bakery.com")),
                    Container(
                        height: 1,
                        color: CustomColor.grayE,
                        margin: const EdgeInsets.only(left: 15, right: 15)),
                    ListTile(
                        contentPadding: const EdgeInsets.only(left: 15, right: 5),
                        title: customWidget.setText("特定商取引法リンク"),
                        trailing: const Icon(Icons.chevron_right, color: CustomColor.redE8),
                        onTap: () => Routes.goPage(context, "/WebViewPage",
                            param: {Constant.FLAG: shopDetailModel?.tradeLawInfoLink}))
                  ],
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 120))
          ],
        ));
  }

  _imgType(img) {
    if (img == "1") {
      return "icon_ins.jpg";
    } else if (img == "2") {
      return "icon_x.jpg";
    } else if (img == "3") {
      return "icon_line.jpg";
    } else {
      return "icon_fb.jpg";
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
