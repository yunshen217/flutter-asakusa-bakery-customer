class Records {
  Records({
    this.id,
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.delFlag,
    this.merchantName,
    this.merchantDescription,
    this.phoneNumber,
    this.status,
    this.longitudeLatitude,
    this.basicInformation,
    this.remark,
    this.businessHoursBegin,
    this.businessHoursEnd,
    this.fixedHolidayArray,
    this.fixedHoliday,
    this.specialRestDay,
    this.eatingArea,
    this.postcode,
    this.prefecturesCode,
    this.municipalities,
    this.streetAddress,
    this.building,
    this.snsType1,
    this.snsType2,
    this.snsType3,
    this.snsType4,
    this.snsLink1,
    this.snsLink2,
    this.snsLink3,
    this.snsLink4,
    this.snsLink,
    this.businessStatus,
    this.storeHomepageLink,
    this.deliveryFlag,
    this.deadLineDays,
    this.approvalDays,
    this.deadLineTime,
    this.email,
    this.contractStartDate,
    this.reference,
    this.contractEndDate,
    this.terminateReason,
    this.contractCd,
    this.contractStatus,
    this.merchantUserName,
    this.ymtCustomerCd,
    this.tradeLawInfoLink,
    this.customerOrderLimit,
    this.customerDailyOrderLimit,
    this.revItemCountLimit,
    this.revAmountLimit,
    this.merchantNotice,
    this.timePeriod,
    this.filePath,
    this.banFilePathList,
    this.psFiles,
    this.psOrderEvaluates,
    this.sumPrice,
    this.sendPrice,
    this.address,
    this.addressDetail,
    this.prefecturesCodeName,
    this.prefectures,
    this.specialRestDayList,
  });

  Records.fromJson(dynamic json) {
    id = json['id'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    delFlag = json['delFlag'];
    merchantName = json['merchantName'];
    merchantDescription = json['merchantDescription'];
    phoneNumber = json['phoneNumber'];
    status = json['status'];
    longitudeLatitude = json['longitudeLatitude'];
    basicInformation = json['basicInformation'];
    remark = json['remark'];
    businessHoursBegin = json['businessHoursBegin'];
    businessHoursEnd = json['businessHoursEnd'];
    fixedHolidayArray = json['fixedHolidayArray'];
    fixedHoliday = json['fixedHoliday'];
    specialRestDay = json['specialRestDay'];
    eatingArea = json['eatingArea'];
    postcode = json['postcode'];
    prefecturesCode = json['prefecturesCode'];
    municipalities = json['municipalities'];
    streetAddress = json['streetAddress'];
    building = json['building'];
    snsType1 = json['snsType1'];
    snsType2 = json['snsType2'];
    snsType3 = json['snsType3'];
    snsType4 = json['snsType4'];
    snsLink1 = json['snsLink1'];
    snsLink2 = json['snsLink2'];
    snsLink3 = json['snsLink3'];
    snsLink4 = json['snsLink4'];
    snsLink = json['snsLink'];
    businessStatus = json['businessStatus'];
    storeHomepageLink = json['storeHomepageLink'];
    deliveryFlag = json['deliveryFlag'];
    deadLineDays = json['deadLineDays'];
    approvalDays = json['approvalDays'];
    deadLineTime = json['deadLineTime'];
    email = json['email'];
    contractStartDate = json['contractStartDate'];
    reference = json['reference'];
    contractEndDate = json['contractEndDate'];
    terminateReason = json['terminateReason'];
    contractCd = json['contractCd'];
    contractStatus = json['contractStatus'];
    merchantUserName = json['merchantUserName'];
    ymtCustomerCd = json['ymtCustomerCd'];
    tradeLawInfoLink = json['tradeLawInfoLink'];
    customerOrderLimit = json['customerOrderLimit'];
    customerDailyOrderLimit = json['customerDailyOrderLimit'];
    revItemCountLimit = json['revItemCountLimit'];
    revAmountLimit = json['revAmountLimit'];
    merchantNotice = json['merchantNotice'];
    timePeriod = json['timePeriod'];
    filePath = json['filePath'] ?? "";
    banFilePathList = json['banFilePathList'];
    psFiles = json['psFiles'];
    psOrderEvaluates = json['psOrderEvaluates'];
    sumPrice = json['sumPrice'];
    sendPrice = json['sendPrice'];
    address = json['address'];
    addressDetail = json['addressDetail'];
    prefecturesCodeName = json['prefecturesCodeName'];
    prefectures = json['prefectures'];
    specialRestDayList = json['specialRestDayList'];
  }

  String? id;
  dynamic createBy;
  dynamic createTime;
  dynamic updateBy;
  dynamic updateTime;
  String? delFlag;
  String? merchantName;
  String? merchantDescription;
  String? phoneNumber;
  dynamic status;
  String? longitudeLatitude;
  dynamic basicInformation;
  String? remark;
  String? businessHoursBegin;
  String? businessHoursEnd;
  String? fixedHolidayArray;
  dynamic fixedHoliday;
  String? specialRestDay;
  String? eatingArea;
  String? postcode;
  String? prefecturesCode;
  String? municipalities;
  String? streetAddress;
  String? building;
  String? snsType1;
  String? snsType2;
  String? snsType3;
  String? snsType4;
  String? snsLink1;
  String? snsLink2;
  String? snsLink3;
  String? snsLink4;
  dynamic snsLink;
  dynamic businessStatus;
  String? storeHomepageLink;
  dynamic deliveryFlag;
  num? deadLineDays;
  num? approvalDays;
  String? deadLineTime;
  String? email;
  String? contractStartDate;
  dynamic reference;
  String? contractEndDate;
  dynamic terminateReason;
  dynamic contractCd;
  String? contractStatus;
  String? merchantUserName;
  String? ymtCustomerCd;
  String? tradeLawInfoLink;
  dynamic customerOrderLimit;
  dynamic customerDailyOrderLimit;
  dynamic revItemCountLimit;
  dynamic revAmountLimit;
  dynamic merchantNotice;
  dynamic timePeriod;
  String? filePath;
  dynamic banFilePathList;
  dynamic psFiles;
  dynamic psOrderEvaluates;
  dynamic sumPrice;
  dynamic sendPrice;
  dynamic address;
  dynamic addressDetail;
  dynamic prefecturesCodeName;
  dynamic prefectures;
  dynamic specialRestDayList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['createBy'] = createBy;
    map['createTime'] = createTime;
    map['updateBy'] = updateBy;
    map['updateTime'] = updateTime;
    map['delFlag'] = delFlag;
    map['merchantName'] = merchantName;
    map['merchantDescription'] = merchantDescription;
    map['phoneNumber'] = phoneNumber;
    map['status'] = status;
    map['longitudeLatitude'] = longitudeLatitude;
    map['basicInformation'] = basicInformation;
    map['remark'] = remark;
    map['businessHoursBegin'] = businessHoursBegin;
    map['businessHoursEnd'] = businessHoursEnd;
    map['fixedHolidayArray'] = fixedHolidayArray;
    map['fixedHoliday'] = fixedHoliday;
    map['specialRestDay'] = specialRestDay;
    map['eatingArea'] = eatingArea;
    map['postcode'] = postcode;
    map['prefecturesCode'] = prefecturesCode;
    map['municipalities'] = municipalities;
    map['streetAddress'] = streetAddress;
    map['building'] = building;
    map['snsType1'] = snsType1;
    map['snsType2'] = snsType2;
    map['snsType3'] = snsType3;
    map['snsType4'] = snsType4;
    map['snsLink1'] = snsLink1;
    map['snsLink2'] = snsLink2;
    map['snsLink3'] = snsLink3;
    map['snsLink4'] = snsLink4;
    map['snsLink'] = snsLink;
    map['businessStatus'] = businessStatus;
    map['storeHomepageLink'] = storeHomepageLink;
    map['deliveryFlag'] = deliveryFlag;
    map['deadLineDays'] = deadLineDays;
    map['approvalDays'] = approvalDays;
    map['deadLineTime'] = deadLineTime;
    map['email'] = email;
    map['contractStartDate'] = contractStartDate;
    map['reference'] = reference;
    map['contractEndDate'] = contractEndDate;
    map['terminateReason'] = terminateReason;
    map['contractCd'] = contractCd;
    map['contractStatus'] = contractStatus;
    map['merchantUserName'] = merchantUserName;
    map['ymtCustomerCd'] = ymtCustomerCd;
    map['tradeLawInfoLink'] = tradeLawInfoLink;
    map['customerOrderLimit'] = customerOrderLimit;
    map['customerDailyOrderLimit'] = customerDailyOrderLimit;
    map['revItemCountLimit'] = revItemCountLimit;
    map['revAmountLimit'] = revAmountLimit;
    map['merchantNotice'] = merchantNotice;
    map['timePeriod'] = timePeriod;
    map['filePath'] = filePath;
    map['banFilePathList'] = banFilePathList;
    map['psFiles'] = psFiles;
    map['psOrderEvaluates'] = psOrderEvaluates;
    map['sumPrice'] = sumPrice;
    map['sendPrice'] = sendPrice;
    map['address'] = address;
    map['addressDetail'] = addressDetail;
    map['prefecturesCodeName'] = prefecturesCodeName;
    map['prefectures'] = prefectures;
    map['specialRestDayList'] = specialRestDayList;
    return map;
  }
}
