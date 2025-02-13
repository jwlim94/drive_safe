import 'package:json_annotation/json_annotation.dart';

part 'car_data.g.dart';

@JsonSerializable()
class CarData {
  CarData({
    this.id,
    this.type,
    this.description,
  });

  final String? id;
  final String? type;
  final String? description;

  factory CarData.fromJson(Map<String, dynamic> json) =>
      _$CarDataFromJson(json);

  Map<String, dynamic> toJson() => _$CarDataToJson(this);
}
