import 'package:json_annotation/json_annotation.dart';

part 'vehicle_model.g.dart';

class VehicleModel {
  final String? model;

  final String? vehicleType;

  final String? description;

  final String? image;

  final String? brand;
  VehicleModel({
    required this.model,
    required this.vehicleType,
    this.description,
    this.image,
    required this.brand,
  });

  factory VehicleModel.fromEntity(VehicleModelEntity e) {
    return VehicleModel(
        model: e.model,
        brand: e.brand,
        vehicleType: e.vehicleType,
        description: e.description,
        image: e.image);
  }

  @override
  String toString() {
    return 'VehicleModel(model: $model, vehicleType: $vehicleType, description: $description, image: $image, brand: $brand)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VehicleModel &&
        other.model == model &&
        other.vehicleType == vehicleType &&
        other.description == description &&
        other.image == image &&
        other.brand == brand;
  }

  @override
  int get hashCode {
    return model.hashCode ^
        vehicleType.hashCode ^
        description.hashCode ^
        image.hashCode ^
        brand.hashCode;
  }
}

@JsonSerializable()
class VehicleModelEntity {
  final String? model;
  @JsonKey(name: 'vehicle_type')
  final String? vehicleType;

  final String? brand;
  final String? description;
  final String? image;
  VehicleModelEntity({
    required this.model,
    required this.vehicleType,
    required this.brand,
    this.description,
    this.image,
  });

  factory VehicleModelEntity.fromJson(Map<String, dynamic> data) =>
      _$VehicleModelEntityFromJson(data);

  Map<String, dynamic> toJson() => _$VehicleModelEntityToJson(this);

  @override
  String toString() {
    return 'VehicleModelEntity(model: $model, vehicleType: $vehicleType, brand: $brand, description: $description, image: $image)';
  }
}
