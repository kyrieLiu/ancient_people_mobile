import 'dart:convert' show json;

T asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }

  return null;
}

class BannerModel {
  BannerModel({
    this.data,
    this.errorCode,
    this.errorMsg,
  });

  factory BannerModel.fromJson(Map<String, dynamic> jsonRes) {
    if (jsonRes == null) {
      return null;
    }

    final List<BannerBean> data =
    jsonRes['data'] is List ? <BannerBean>[] : null;
    if (data != null) {
      for (final dynamic item in jsonRes['data']) {
        if (item != null) {
          data.add(BannerBean.fromJson(asT<Map<String, dynamic>>(item)));
        }
      }
    }
    return BannerModel(
      data: data,
      errorCode: asT<int>(jsonRes['errorCode']),
      errorMsg: asT<String>(jsonRes['errorMsg']),
    );
  }

  List<BannerBean> data;
  int errorCode;
  String errorMsg;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'data': data,
    'errorCode': errorCode,
    'errorMsg': errorMsg,
  };
  @override
  String toString() {
    return json.encode(this);
  }
}

class BannerBean {
  BannerBean({
    this.desc,
    this.id,
    this.imagePath,
    this.isVisible,
    this.order,
    this.title,
    this.type,
    this.url,
  });

  factory BannerBean.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : BannerBean(
    desc: asT<String>(jsonRes['desc']),
    id: asT<int>(jsonRes['id']),
    imagePath: asT<String>(jsonRes['imagePath']),
    isVisible: asT<int>(jsonRes['isVisible']),
    order: asT<int>(jsonRes['order']),
    title: asT<String>(jsonRes['title']),
    type: asT<int>(jsonRes['type']),
    url: asT<String>(jsonRes['url']),
  );

  String desc;
  int id;
  String imagePath;
  int isVisible;
  int order;
  String title;
  int type;
  String url;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'desc': desc,
    'id': id,
    'imagePath': imagePath,
    'isVisible': isVisible,
    'order': order,
    'title': title,
    'type': type,
    'url': url,
  };
  @override
  String toString() {
    return json.encode(this);
  }
}
