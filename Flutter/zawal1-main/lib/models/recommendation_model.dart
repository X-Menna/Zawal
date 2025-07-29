class recommendation_model {
  Preferences? preferences;

  recommendation_model({this.preferences});

  recommendation_model.fromJson(Map<String, dynamic> json) {
    preferences = json['preferences'] != null
        ? new Preferences.fromJson(json['preferences'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.preferences != null) {
      data['preferences'] = this.preferences!.toJson();
    }
    return data;
  }
}

class Preferences {
  int? id;
  String? userId;
  String? country;
  String? budget;
  int? age;
  List<String>? activities;
  int? isKidFriendlyRequired;
  String? createdAt;
  String? updatedAt;
  String? language;
  String? season;
  int? isSoloTravel;

  Preferences(
      {this.id,
      this.userId,
      this.country,
      this.budget,
      this.age,
      this.activities,
      this.isKidFriendlyRequired,
      this.createdAt,
      this.updatedAt,
      this.language,
      this.season,
      this.isSoloTravel});

  Preferences.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    country = json['country'];
    budget = json['budget'];
    age = json['age'];
    activities = json['activities'].cast<String>();
    isKidFriendlyRequired = json['is_kid_friendly_required'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    language = json['language'];
    season = json['season'];
    isSoloTravel = json['is_solo_travel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['country'] = this.country;
    data['budget'] = this.budget;
    data['age'] = this.age;
    data['activities'] = this.activities;
    data['is_kid_friendly_required'] = this.isKidFriendlyRequired;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['language'] = this.language;
    data['season'] = this.season;
    data['is_solo_travel'] = this.isSoloTravel;
    return data;
  }
}
