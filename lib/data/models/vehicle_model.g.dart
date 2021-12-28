// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleModelEntity _$VehicleModelEntityFromJson(Map<String, dynamic> json) =>
    VehicleModelEntity(
      model: json['model'] as String?,
      vehicleType: json['vehicle_type'] as String?,
      brand: json['brand'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$VehicleModelEntityToJson(VehicleModelEntity instance) =>
    <String, dynamic>{
      'model': instance.model,
      'vehicle_type': instance.vehicleType,
      'brand': instance.brand,
      'description': instance.description,
      'image': instance.image,
    };
