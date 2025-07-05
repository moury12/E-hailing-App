class ChatModel {
  String? sId;
  List<Participants>? participants;
  List<String>? messages;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ChatModel({
    this.sId,
    this.participants,
    this.messages,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['participants'] != null) {
      participants = <Participants>[];
      json['participants'].forEach((v) {
        participants!.add(Participants.fromJson(v));
      });
    }
    messages = json['messages'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (participants != null) {
      data['participants'] = participants!.map((v) => v.toJson()).toList();
    }
    data['messages'] = messages;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
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

class ChatMessage {
  final String content;
  final String time;
  final bool isFromDriver;
  final bool isTyping;

  ChatMessage({
    required this.content,
    required this.time,
    required this.isFromDriver,
    this.isTyping = false,
  });
}
