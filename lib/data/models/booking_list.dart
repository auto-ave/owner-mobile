import 'package:json_annotation/json_annotation.dart';

import 'package:owner_app/data/models/booked_by.dart';
import 'package:owner_app/data/models/event.dart';
import 'package:owner_app/data/models/price_time_list.dart';
import 'package:owner_app/data/models/vehicle_model.dart';

part 'booking_list.g.dart';

class BookingListModel {
  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? bookingId;
  BookingStatus status;
  final DateTime? statusChangedTime;
  final String? otp;
  final EventModel? event;

  final VehicleModel? vehicleModel;
  final BookedBy? bookedBy;
  final bool? isRefunded;
  final List<PriceTimeListModel>? serviceNames;
  final String? amount;
  final num? remainingAmount;
  BookingListModel(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.bookingId,
      required this.status,
      this.statusChangedTime,
      this.otp,
      this.event,
      this.serviceNames,
      this.bookedBy,
      this.isRefunded,
      this.amount,
      this.vehicleModel,
      required this.remainingAmount});
  factory BookingListModel.fromEntity(BookingListEntity e) {
    return BookingListModel(
        amount: e.amount,
        bookedBy: e.bookedBy != null ? BookedBy.fromEntity(e.bookedBy!) : null,
        bookingId: e.bookingId,
        createdAt: DateTime.parse(e.createdAt!),
        event: EventModel.fromEntity(e.event!),
        id: e.id,
        isRefunded: e.isRefunded,
        otp: e.otp,
        serviceNames: e.serviceNames != null
            ? e.serviceNames!
                .map<PriceTimeListModel>(
                    (e) => PriceTimeListModel.fromEntity(e))
                .toList()
            : null,
        status: e.status != null
            ? getBookingStatusFromCode(e.status!)
            : BookingStatus.notDefined,
        statusChangedTime: e.statusChangedTime != null
            ? DateTime.parse(e.statusChangedTime!)
            : null,
        updatedAt: DateTime.parse(e.updatedAt!),
        vehicleModel: e.vehicleModel != null
            ? VehicleModel.fromEntity(e.vehicleModel!)
            : null,
        remainingAmount: e.remainingAmount);
  }

  @override
  String toString() {
    return 'BookingListModel(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, bookingId: $bookingId, status: $status, statusChangedTime: $statusChangedTime, otp: $otp, amount: $amount, remainingAmount: $remainingAmount event: $event, vehicleModel: $vehicleModel, bookedBy: $bookedBy, isRefunded: $isRefunded, serviceNames: $serviceNames)';
  }
}

@JsonSerializable(explicitToJson: true)
class BookingListEntity {
  final int? id;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @JsonKey(name: 'booking_id')
  final String? bookingId;

  @JsonKey(name: 'booking_status')
  final String? status;

  @JsonKey(name: 'status_changed_time')
  final String? statusChangedTime;

  final String? otp;
  final EventEntity? event;

  @JsonKey(name: 'vehicle_model')
  final VehicleModelEntity? vehicleModel;

  @JsonKey(name: 'booked_by')
  final BookedByEntity? bookedBy;

  @JsonKey(name: 'is_refunded')
  final bool? isRefunded;

  @JsonKey(name: 'price_times')
  final List<PriceTimeListEntity>? serviceNames;

  final String? amount;

  @JsonKey(name: 'remaining_amount')
  final num? remainingAmount;
  BookingListEntity(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.bookingId,
      this.status,
      this.statusChangedTime,
      this.otp,
      this.event,
      this.bookedBy,
      this.isRefunded,
      this.serviceNames,
      this.amount,
      this.remainingAmount,
      this.vehicleModel});
  factory BookingListEntity.fromJson(Map<String, dynamic> data) =>
      _$BookingListEntityFromJson(data);

  Map<String, dynamic> toJson() => _$BookingListEntityToJson(this);

  @override
  String toString() {
    return 'BookingListEntity(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, bookingId: $bookingId, status: $status, statusChangedTime: $statusChangedTime, otp: $otp, event: $event,   bookedBy: $bookedBy, isRefunded: $isRefunded, serviceNames: $serviceNames, amount: $amount, )';
  }
}

BookingStatus getBookingStatusFromCode(String code) {
  switch (code) {
    case 'INITIATED':
      return BookingStatus.initiated;
    case 'PAYMENT_SUCCESS':
      return BookingStatus.paymentSuccess;
    case 'PAYMENT_FAILED':
      return BookingStatus.paymentFailed;
    case 'NOT_ATTENDED':
      return BookingStatus.notAttended;
    case 'SERVICE_STARTED':
      return BookingStatus.serviceStarted;
    case 'SERVICE_COMPLETED':
      return BookingStatus.serviceCompleted;
    case 'CANCELLATION_REQUEST_APPROVED':
      return BookingStatus.cancellationRequestApproved;
    case 'CANCELLATION_REQUEST_REJECTED':
      return BookingStatus.cancellationRequestRejected;
    case 'CANCELLATION_REQUEST_SUBMITTED':
      return BookingStatus.cancellationRequestSubmitted;

    default:
      return BookingStatus.notDefined;
  }
}

enum BookingStatus {
  initiated,

  paymentSuccess,
  paymentFailed,
  notAttended,
  serviceStarted,
  serviceCompleted,
  notDefined,
  cancellationRequestRejected,
  cancellationRequestApproved,
  cancellationRequestSubmitted
}
