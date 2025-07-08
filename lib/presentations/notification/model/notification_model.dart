class NotificationModel {
  String? sId;
  String? toId;
  String? title;
  String? message;
  bool? isRead;
  String? createdAt;
  String? updatedAt;

  NotificationModel({
    this.sId,
    this.toId,
    this.title,
    this.message,
    this.isRead,
    this.createdAt,
    this.updatedAt,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    toId = json['toId'];
    title = json['title'];
    message = json['message'];
    isRead = json['isRead'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['toId'] = toId;
    data['title'] = title;
    data['message'] = message;
    data['isRead'] = isRead;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
