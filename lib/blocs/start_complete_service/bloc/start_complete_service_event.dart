part of 'start_complete_service_bloc.dart';

abstract class StartCompleteServiceEvent extends Equatable {
  const StartCompleteServiceEvent();
}

class StartService extends StartCompleteServiceEvent {
  final String bookingId;
  final String otp;
  const StartService({
    required this.bookingId,
    required this.otp,
  });

  @override
  List<Object> get props => [bookingId, otp];
}

class CompleteService extends StartCompleteServiceEvent {
  final String bookingId;
  const CompleteService({
    required this.bookingId,
  });

  @override
  List<Object> get props => [bookingId];
}
