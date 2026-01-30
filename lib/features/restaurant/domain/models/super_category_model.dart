import 'dart:convert';

List<SuperCategoryModel> superCategoryModelFromJson(String str) =>
    List<SuperCategoryModel>.from(
        json.decode(str).map((x) => SuperCategoryModel.fromJson(x)));

String superCategoryModelToJson(List<SuperCategoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SuperCategoryModel {
  int? id;
  String? name;
  String? startTime;
  String? endTime;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;

  SuperCategoryModel({
    this.id,
    this.name,
    this.startTime,
    this.endTime,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory SuperCategoryModel.fromJson(Map<String, dynamic> json) =>
      SuperCategoryModel(
        id: json["id"],
        name: json["name"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        image: json["image"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "start_time": startTime,
        "end_time": endTime,
        "image": image,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
