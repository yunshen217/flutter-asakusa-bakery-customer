import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shopping_client/common/constant.dart';

import '../common/Global.dart';
import '../common/custom_widget.dart';
import '../common/navigation_service.dart';
import '../model/base_model.dart';
import '../model/base_res.dart';

class BaseInterceptors extends InterceptorsWrapper {
  final Dio dio;

  BaseInterceptors(this.dio);

  final exactExcludedPaths = {
    Constant.psItemKindList,
    Constant.getLink,
    Constant.queryPsTimePeriod,
    Constant.calculatePrice,
    Constant.psItemList,
    Constant.customerInfoDetail,
    Constant.psCustomerAddressList,
    Constant.orderList,
    Constant.getSearchParam,
    Constant.allPsItemList,
    Constant.homes,
    Constant.submitOrder,
    Constant.getRestWeekDay,
  };

  final prefixExcludedPaths = [
    '${Constant.orderDetail}/', // 动态路径前缀，如 "orderDetail/"
    Constant.getFirstAvailableDay, // 或其他需要部分匹配的路径
  ];

  void _dismissLoadingIfNeeded(String path) {
    bool isExcluded = exactExcludedPaths.contains(path) ||
        prefixExcludedPaths.any((prefix) => path.startsWith(prefix)) ||
        path.contains(Constant.getFirstAvailableDay);

    if (!isExcluded &&
        SmartDialog.checkExist(dialogTypes: {SmartAllDialogType.loading})) {
      SmartDialog.dismiss();
    }
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (Global.token.isEmpty) {
      SmartDialog.dismiss(); // 防止 loading 卡住
    }

    if (_refreshCompleter != null) {
      bool success = await _refreshCompleter!.future;
      if (!success) {
        return handler.reject(DioError(
          requestOptions: options,
          error: "Token refresh failed",
          type: DioErrorType.cancel,
        ));
      }
    }
    bool isExcluded = exactExcludedPaths.contains(options.path) ||
        prefixExcludedPaths.any((prefix) => options.path.startsWith(prefix)) ||
        options.path.contains(Constant.getFirstAvailableDay);
    if (!isExcluded) {
      if (SmartDialog.checkExist(dialogTypes: {SmartAllDialogType.loading})) {
        SmartDialog.showLoading(
            useAnimation: true,
            animationType: SmartAnimationType.centerScale_otherSlide,
            displayTime: Duration(seconds: 15));
      }
    }
    handler.next(options);
  }

  String getAutorizationString(String accessToken) {
    return 'Bearer ' + accessToken;
  }

  Completer<bool>? _refreshCompleter;

  Future<bool> refreshToken() async {
    // 如果已经在刷新中，直接等待它完成
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer();

    try {
      final response = await Dio().post(
        '${Constant.refreshToken}',
        data: {
          "refreshToken": Global.userInfo?.refreshToken ?? "",
        },
        options: Options(
          headers: {
            'Authorization':
                getAutorizationString(Global.userInfo!.accessToken ?? ""),
            'client-id': Global.userInfo!.clientId,
            'X-API-KEY':
                "58ea70404a4b6652708245af107811ee6903ca2c9fa82f676306dac75f8b65ae",
            'ContentType': ContentType.parse("application/json;charset=UTF-8")
          },
        ),
      );

      if (response.statusCode == 200 && response.data['code'] == 200) {
        print("refreshToken成功");
        await Global.putUserInfo(response.data['data']);
        _refreshCompleter!.complete(true);
        return true;
      } else {
        _refreshCompleter!.complete(false);
        return false;
      }
    } catch (e) {
      SmartDialog.dismiss();
      await Global.clear();
      NavigationService.goLoginPage();
      _refreshCompleter?.complete(false);
      return false;
    } finally {
      _refreshCompleter = null; // 解锁
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _dismissLoadingIfNeeded(err.requestOptions.path);
    if (err is SocketException) {
      //HttpException
      print("检查网络权限====>" + err.response?.data);
      print(err.response?.requestOptions.path);
    } else if (err.error is TimeoutException) {
      print(err.response?.requestOptions.path);
      print("网络连接超时异常--------------->end");
    } else if (err.response?.statusCode == 500) {
      print("服务器异常--------->500");
      print(err.response?.requestOptions.path);
      print("服务器异常-------->500------->end");
    } else if (err.response?.statusCode == 404) {
      print("接口异常-------->404");
      print(err.response?.requestOptions.path);
      customWidget.toastShow(Constant.connectOut);
      print("接口异常-------->404------->end");
    } else if (err.response?.statusCode == 502) {
      print("服务器异常-------->502------->start");
      print(err.response?.requestOptions.path);
      print("服务器异常-------->502------->end");
    } else if (err.response?.statusCode == 401) {
      print("权限不够-------->401------->start");
      print(err.response?.requestOptions.path);
      print("权限不够-------->401------->end");
    }
    print('Url: ${err.response?.requestOptions.uri}');
    print('Headers: ${err.response?.requestOptions.headers}');
    handler.next(err);
  }

  BaseModel? parseBaseModel(dynamic raw) {
    try {
      // 如果是字符串，就先解码
      if (raw is String) {
        raw = json.decode(raw);
      }

      if (raw is Map<String, dynamic>) {
        return BaseJsonRes.fromJson(raw).info;
      } else {
        print("⚠️ Unexpected JSON format: $raw");
      }
    } catch (e, stack) {
      print("❌ JSON解析异常: $e");
      // 如果需要也可以上报错误
    }
    return null;
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    _dismissLoadingIfNeeded(response.requestOptions.path);
    if (response.requestOptions.path == Constant.getCreditCardToken) {
      //do nothing
      handler.next(response);
    } else if (response.statusCode == 200) {
      
      var json = response.data;
      BaseModel? info = parseBaseModel(json);
      // customWidget.toastShow(json);
      // BaseMap<T> info = BaseResForAutoJson.fromJson(json).info;
      if (info?.code == 400 || info?.code == 402) {
        print("-------------------start-------------------");
        print("error===> ${info?.code} ${info?.message}");
        print(response.data);
        print("--------------------end--------------------");
        customWidget.toastShow(info?.message);
      } else if (info?.code == 403) {
        customWidget.toastShow(info?.message, notifyType: NotifyType.error);
        // Routes.goPage(Get.context!, "/LoginPage");
        // Global.clear();
      } else if (info?.code == 46001) {//账号在其他设备上被登录
        customWidget.toastShow(info?.message, notifyType: NotifyType.error);
        Global.clear();
        redirectToLogin();
      } else if (info?.code == 500) {
        customWidget.toastShow(info?.message, notifyType: NotifyType.error);

        print("-------------------start-------------------");
        print("error===> ${info?.code} ${info?.message}");
        print(response.data);
        //SmartDialog.dismiss();
        print("--------------------end--------------------");
      } else if (info?.code == 200) {
        //  SmartDialog.dismiss();
        if (info?.data == null) {
          customWidget.toastShow(info?.message);
        } else {
          print("path====>${response.requestOptions.path}");
          print("data====>${jsonEncode(json)}");
          //handler.next(response);
        }
        handler.next(response);
      } else if (info?.code == 401 && (Global.userInfo!.accessToken != null)) {
        bool refreshSuccess = await refreshToken();
        if (refreshSuccess) {
          final RequestOptions requestOptions = response.requestOptions;
          requestOptions.headers["Authorization"] =
              getAutorizationString(Global.userInfo!.accessToken ?? "");
          requestOptions.headers["client-id"] = Global.userInfo!.clientId;
          try {
            final response = await dio.fetch(requestOptions);
            print("refreshToken成功，更新header重新请求");
            print("header${requestOptions.headers}");
            return handler.resolve(response);
          } catch (e) {
            print("refresh成功后再请求时error");
            return handler.reject(e as DioException);
          }
        } else {
          //redirect login
          print("refreshToken失败，跳转login");
          redirectToLogin();
        }
      } else {
        print("-------------------start-------------------");
        print("error===> ${info?.code} ${info?.message}");
        print('Headers: ${response.requestOptions.headers}');
        print(response.data);
        print("--------------------end--------------------");
      }
      // if (response.requestOptions.path != Constant.psItemKindList &&
      //     response.requestOptions.path != Constant.getLink &&
      //     response.requestOptions.path != Constant.queryPsTimePeriod &&
      //     response.requestOptions.path != Constant.calculatePrice &&
      //     response.requestOptions.path != Constant.psItemList &&
      //     response.requestOptions.path != Constant.psCustomerAddressList &&
      //     response.requestOptions.path != Constant.customerInfoDetail &&
      //     !response.requestOptions.path.contains(Constant.getFirstAvailableDay) &&
      //     response.requestOptions.path != Constant.getRestWeekDay) {
      //   if (!SmartDialog.checkExist(tag: "loading", dialogTypes: {SmartAllDialogType.loading})) {
      //     SmartDialog.dismiss(tag: "loading");
      //   }
      // }
      // if (!SmartDialog.checkExist(tag: "loading", dialogTypes: {SmartAllDialogType.loading})) {
      //   Future.delayed(const Duration(milliseconds: 500), () => SmartDialog.dismiss());
      // }
    }
  }

  void redirectToLogin() {
    NavigationService.goLoginPage();
    SmartDialog.dismiss();
  }
}
