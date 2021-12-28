// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booked_by.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookedBy _$BookedByFromJson(Map<String, dynamic> json) => BookedBy(
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$BookedByToJson(BookedBy instance) => <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
    };

BookedByEntity _$BookedByEntityFromJson(Map<String, dynamic> json) =>
    BookedByEntity(
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$BookedByEntityToJson(BookedByEntity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
    };
