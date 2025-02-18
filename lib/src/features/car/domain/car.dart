import 'package:json_annotation/json_annotation.dart';

part 'car.g.dart';

@JsonSerializable()
class Car {
  Car({
    required this.id,
    required this.type,
    required this.description,
  });

  final String id;
  final String type;
  final String description;

  factory Car.fromJson(Map<String, dynamic> json) => _$CarFromJson(json);

  Map<String, dynamic> toJson() => _$CarToJson(this);

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'] as String,
      type: map['type'] as String,
      description: map['description'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      // Required fields
      'id': id,
      'type': type,
      'description': description,
    };

    return data;
  }
}
