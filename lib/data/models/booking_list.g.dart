// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingListEntity _$BookingListEntityFromJson(Map<String, dynamic> json) =>
    BookingListEntity(
      id: json['id'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      bookingId: json['booking_id'] as String?,
      status: json['booking_status'] as String?,
      statusChangedTime: json['status_changed_time'] as String?,
      otp: json['otp'] as String?,
      event: json['event'] == null
          ? null
          : EventEntity.fromJson(json['event'] as Map<String, dynamic>),
      bookedBy: json['booked_by'] == null
          ? null
          : BookedByEntity.fromJson(json['booked_by'] as Map<String, dynamic>),
      isRefunded: json['is_refunded'] as bool?,
      serviceNames: (json['price_times'] as List<dynamic>?)
          ?.map((e) => PriceTimeListEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      amount: json['amount'] as String?,
      remainingAmount: json['remaining_amount'] as num?,
      vehicleModel: json['vehicle_model'] == null
          ? null
          : VehicleModelEntity.fromJson(
              json['vehicle_model'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookingListEntityToJson(BookingListEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'booking_id': instance.bookingId,
      'booking_status': instance.status,
      'status_changed_time': instance.statusChangedTime,
      'otp': instance.otp,
      'event': instance.event?.toJson(),
      'vehicle_model': instance.vehicleModel?.toJson(),
      'booked_by': instance.bookedBy?.toJson(),
      'is_refunded': instance.isRefunded,
      'price_times': instance.serviceNames?.map((e) => e.toJson()).toList(),
      'amount': instance.amount,
      'remaining_amount': instance.remainingAmount,
    };
