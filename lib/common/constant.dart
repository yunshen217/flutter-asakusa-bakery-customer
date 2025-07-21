import 'package:flutter/foundation.dart';

///常量

class Constant {
  Constant._();

  static const bool _isDebug = kDebugMode;
  static final String connectError = '404';
  static final String connectError_500 = '500';
  static final String connectError_401 = '401';
  static final String connectTimeOut =
      'Network connection timed out, please try again later';
  static final String connectOut =
      'Can not connect to server, please check network configuration';
  static final String otherError = 'An error occurred, please try again later';
  static final String jsonError = 'json parse error';

  static const String TOKEN = 'token';
  static const String USER_MODEL = 'userModel';

  static const String FLAG = "FLAG";
  static const String TITLE = "TITLE";
  static const String ID = "ID";
  static const String ID_2 = "ID_2";
  static const String REFRESH_O = "refreshOrderPage";

  static const int FLAG_ZERO = 0;
  static const int FLAG_ONE = 1;
  static const int FLAG_TWO = 2;
  static const int FLAG_THREE = 3;
  static const int FLAG_FOUR = 4;
  static const int FLAG_FIVE = 5;
  static const int FLAG_SIX = 6;
  static const int FLAG_SEVEN = 7;
  static const int FLAG_EIGHT = 8;
  static const int FLAG_NINE = 9;
  static const int FLAG_TEN = 10;
  static const int FLAG_ELEVEN = 11;
  static const int FLAG_TWELVE = 12;
  static const int FLAG_THIRTEEN = 13;
  static const int FLAG_FOURTEEN = 14;
  static const int FLAG_FIFTEEN = 15;
  static const int FLAG_SIXTEEN = 16;
  static const int FLAG_SEVENTEEN = 17;

  /// 正式
  static var base_url = "https://app.asakusa-bakery.com/api/";

  static var web_url = "https://app.asakusa-bakery.com/";

  static var picture_url = "https://asakusabakery.s3.ap-northeast-1.amazonaws.com";

  /// 测试环境
  //static var base_url = "https://test.asakusa-bakery.com/api/";
  // //static var base_url = "https://test.asakusa-bakery.com/prod-api/";
  //static var web_url = "https://test.asakusa-bakery.com/api/";
  // //static var web_url = "https://test.asakusa-bakery.com/";
  // //static var picture_url = "https://test.asakusa-bakery.com/";
  //static var picture_url =
  //    "https://asakusa-bakery-file.s3.ap-northeast-1.amazonaws.com";

  static final homes = "${base_url}customer/merchants";
  static final resetAccountPassword = "${base_url}customer/auth/password/reset";
  static final login = "${base_url}customer/auth/login";
  static final sendEmailCode = "${base_url}customer/auth/verification-code";
  static final register = "${base_url}customer/auth/register";
  static final deleteCustomerAccount = "${base_url}customer/auth/deactivate";
  static final resetPassword = "${base_url}customer/auth/password";
  static final refreshToken = "${base_url}customer/auth/refresh-token";

  static final editCustomerAddress = "${base_url}customer/addresses";
  static final editDefaultAddress = "${base_url}customer/addresses/default/";
  static final psCustomerAddressList = "${base_url}customer/addresses";
  static final deleteAddress = "${base_url}customer/addresses/";

  static final calculatePrice = "${base_url}customer/orders/calculate";
  static final submitOrder = "${base_url}customer/orders/submit";
  static final payMoney = "${base_url}customer/orders/payment/paypay";
  static final orderCancle = "${base_url}customer/orders/";
  static final orderList = "${base_url}customer/orders/list";
  static final orderDetail = "${base_url}customer/orders/";

  static final psMerchantDetail = "${base_url}customer/merchants/";
  static final queryPsTimePeriod = "${base_url}customer/merchants/time-periods";

  static final getRestWeekDay = "${base_url}customer/days/rest";
  static final getFirstAvailableDay = "${base_url}customer/days/";
  static final getRsvStopDay = "${base_url}customer/days/";

  static final psItemKindList = "${base_url}customer/items/";
  static final psItemList = "${base_url}customer/items";
  static final psItemDetail = "${base_url}customer/items/";
  static final allPsItemList = "${base_url}customer/items/all";

  static final getMessageList = "${base_url}customer/messages";
  static final getUncheckNotice =
      "${base_url}customer/messages/system/unchecked";
  static final checkNotice = "${base_url}customer/messages/system/check/";
  static final getSystemNotice = "${base_url}customer/messages/system";
  static final remarkOrderList = "${base_url}customer/remarkOrderList/";
  static final remarkOrder = "${base_url}customer/remarkOrder";
  static final editCustomerInfo = "${base_url}customer/info";
  static final customerInfoDetail = "${base_url}customer/info";
  static final getPoint = "${base_url}customer/points";

  static final getInfoByPostcode = "${base_url}common/postcode/";
  static final getSearchParam = "${base_url}common/search-param";
  static final getLink = "${base_url}common/sns";

  static final getCreditCardToken = "https://api3.veritrans.co.jp/4gtoken";
  static final creditCard = "${base_url}customer/cards";
  static final defaultCreditCard = "${base_url}customer/cards/default";
  static final creditCardPay = "${base_url}customer/orders/payment/card";
  static final creditCardApiKey = "${base_url}customer/key";
}
