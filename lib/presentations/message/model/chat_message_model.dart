class ChatModel {
  String? sId;
  List<Participants>? participants;
  List<Messages>? messages;
  String? createdAt;
  String? updatedAt;
  int? iV;
  Meta? meta;

  ChatModel({
    this.sId,
    this.participants,
    this.messages,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.meta,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['participants'] != null) {
      participants = <Participants>[];
      json['participants'].forEach((v) {
        participants!.add(Participants.fromJson(v));
      });
    }
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(Messages.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (participants != null) {
      data['participants'] = participants!.map((v) => v.toJson()).toList();
    }
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    return data;
  }
}

class Participants {
  String? sId;
  String? name;
  String? phoneNumber;
  String? profileImage;

  Participants({this.sId, this.name, this.phoneNumber, this.profileImage});

  Participants.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['profile_image'] = profileImage;
    return data;
  }
}

class Messages {
  String? sId;
  String? sender;
  String? receiver;
  String? message;
  String? english;
  String? malay;
  bool? isRead;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Messages({
    this.sId,
    this.sender,
    this.receiver,
    this.message,
    this.english,
    this.malay,
    this.isRead,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Messages.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sender = json['sender'];
    english = json['english'];
    malay = json['malay'];
    receiver = json['receiver'];
    message = json['message'];
    isRead = json['isRead'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['sender'] = sender;
    data['receiver'] = receiver;
    data['english'] = english;
    data['malay'] = malay;
    data['message'] = message;
    data['isRead'] = isRead;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Meta {
  int? page;
  int? limit;
  int? total;
  int? totalPage;

  Meta({this.page, this.limit, this.total, this.totalPage});

  Meta.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
    totalPage = json['totalPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['limit'] = limit;
    data['total'] = total;
    data['totalPage'] = totalPage;
    return data;
  }
}
