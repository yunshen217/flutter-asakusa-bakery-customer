class UserModel {
  UserModel({
      this.id, 
      this.createBy, 
      this.createTime, 
      this.updateBy, 
      this.updateTime, 
      this.delFlag, 
      this.userName, 
      this.password,
      this.nickName, 
      this.email, 
      this.phoneNumber, 
      this.avatar, 
      this.sex, 
      this.birthday, 
      this.status, 
      this.userId,
      this.payFlag,
      this.remark, 
      this.loginIp, 
      this.deviceToken, 
      this.defaultSendFlag, 
      this.defaultTimePeriod, 
      this.loginDate, 
      this.headFilePath,
      this.point,
      this.accessToken,
      this.refreshToken,
      this.expiredIn,
      this.clientId});

  UserModel.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId']??"";
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    delFlag = json['delFlag'];
    userName = json['userName'] ?? "ログイン";
    password = json['password'];
    nickName = json['nickName']??"";
    email = json['email'] ??"";
    phoneNumber = json['phoneNumber']??"";
    avatar = json['avatar'];
    sex = json['sex'];
    birthday = json['birthday'] ??"";
    status = json['status'];
    payFlag = json['payFlag'];
    remark = json['remark'];
    loginIp = json['loginIp'];
    deviceToken = json['deviceToken'];
    defaultSend = json['defaultSend'] ??"0";
    defaultSendFlag = json['defaultSendFlag'] ??"-1";
    defaultTime = json['defaultTime'];
    defaultTimePeriod = json['defaultTimePeriod'] ??"";
    loginDate = json['loginDate'];
    point = json['point'];
    headFilePath = json['headFilePath'];
    accessToken = json['accessToken'] ??"";
    refreshToken = json['refreshToken'] ??"";
    expiredIn = json['expiredIn'] ??"";
    clientId = json['clientId'] ??"";
  }
  String? id;
  String? userId;
  dynamic createBy;
  dynamic createTime;
  dynamic updateBy;
  dynamic updateTime;
  String? delFlag;
  String? userName;
  String? password;
  String? nickName;
  String? email;
  String? phoneNumber;
  dynamic avatar;
  String? sex;
  String? birthday;
  String? status;
  String? payFlag;
  dynamic remark;
  dynamic loginIp;
  String? deviceToken;
  dynamic defaultSendFlag;
  String? defaultSend;
  String? defaultTimePeriod;
  String? defaultTime;
  dynamic loginDate;
  dynamic headFilePath;
  dynamic point;
  String? accessToken;
  String? refreshToken;
  dynamic expiredIn;
  String? clientId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['createBy'] = createBy;
    map['createTime'] = createTime;
    map['updateBy'] = updateBy;
    map['updateTime'] = updateTime;
    map['delFlag'] = delFlag;
    map['userName'] = userName;
    map['password'] = password;
    map['nickName'] = nickName;
    map['email'] = email;
    map['phoneNumber'] = phoneNumber;
    map['avatar'] = avatar;
    map['sex'] = sex;
    map['birthday'] = birthday;
    map['status'] = status;
    map['payFlag'] = payFlag;
    map['remark'] = remark;
    map['loginIp'] = loginIp;
    map['deviceToken'] = deviceToken;
    map['defaultSend'] = defaultSend;
    map['defaultSendFlag'] = defaultSendFlag;
    map['defaultTime'] = defaultTime;
    map['defaultTimePeriod'] = defaultTimePeriod;
    map['loginDate'] = loginDate;
    map['point'] = point;
    map['headFilePath'] = headFilePath;
    map['accessToken'] = accessToken;
    map['refreshToken'] = refreshToken;
    map['expiredIn'] = expiredIn;
    map['clientId'] = clientId;
    return map;
  }

}