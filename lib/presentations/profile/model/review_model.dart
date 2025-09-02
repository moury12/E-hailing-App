class ReviewModel {
  String? sId;
  User? user;
  num? rating;
  String? review;

  ReviewModel({this.sId, this.user, this.rating, this.review});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    rating = (json['rating'] as num).toDouble();;
    review = json['review'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['rating'] = rating;
    data['review'] = review;
    return data;
  }
}

class User {
  String? sId;
  String? name;
  String? profileImage;

  User({this.sId, this.name, this.profileImage});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['profile_image'] = profileImage;
    return data;
  }
}
