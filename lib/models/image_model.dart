import 'package:json_annotation/json_annotation.dart';

part 'image_model.g.dart';

@JsonSerializable()
class UploadedImage {
  final String? id;
  final String url;
  final String name;
  final DateTime createdAt;

  UploadedImage({
    this.id,
    required this.url,
    required this.name,
    required this.createdAt,
  });

  factory UploadedImage.fromJson(Map<String, dynamic> json) =>
      _$UploadedImageFromJson(json);

  Map<String, dynamic> toJson() => _$UploadedImageToJson(this);
}
