import 'city.dart';

class District {
  District({
      this.id, 
      this.createdOn, 
      this.name, 
      this.city,});

  District.fromJson(dynamic json) {
    id = json['id'];
    createdOn = json['createdOn'];
    name = json['name'];
    city = json['city'] != null ? City.fromJson(json['city']) : null;
  }
  String? id;
  String? createdOn;
  String? name;
  City? city;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['createdOn'] = createdOn;
    map['name'] = name;
    if (city != null) {
      map['city'] = city!.toJson();
    }
    return map;
  }

}