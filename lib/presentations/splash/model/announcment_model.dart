class AnnouncementModel {
  String? sId;
  int? iV;
  String? createdAt;
  String? description;
  bool? isActive;
  String? title;
  String? updatedAt;

  AnnouncementModel(
      {this.sId,
        this.iV,
        this.createdAt,
        this.description,
        this.isActive,
        this.title,
        this.updatedAt});

  AnnouncementModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    description = json['description'];
    isActive = json['isActive'];
    title = json['title'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['description'] = this.description;
    data['isActive'] = this.isActive;
    data['title'] = this.title;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
