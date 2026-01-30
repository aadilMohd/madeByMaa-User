

import 'dart:convert';

import 'package:image_compression_flutter/image_compression_flutter.dart';

UploadPhotoBody uploadPhotoBodyFromJson(String str) => UploadPhotoBody.fromJson(json.decode(str));

String uploadPhotoBodyToJson(UploadPhotoBody data) => json.encode(data.toJson());

class UploadPhotoBody {
  String? userId;
  XFile? photo;

  UploadPhotoBody({
    this.userId,
    this.photo,
  });

  factory UploadPhotoBody.fromJson(Map<String, dynamic> json) => UploadPhotoBody(
    userId: json["user_id"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "photo": photo,
  };
}
