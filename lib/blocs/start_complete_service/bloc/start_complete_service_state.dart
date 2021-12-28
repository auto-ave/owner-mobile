part of 'start_complete_service_bloc.dart';

abstract class StartCompleteServiceState extends Equatable {
  const StartCompleteServiceState();
}

class StartCompleteServiceInitial extends StartCompleteServiceState {
  @override
  List<Object> get props => [];
}

class ServiceStarted extends StartCompleteServiceState {
  @override
  List<Object> get props => [];
}

class StartingService extends StartCompleteServiceState {
  @override
  List<Object> get props => [];
}

class CompletingService extends StartCompleteServiceState {
  @override
  List<Object> get props => [];
}

class WrongOTPEntered extends StartCompleteServiceState {
  @override
  List<Object> get props => [];
}

class ServiceCompleted extends StartCompleteServiceState {
  @override
  List<Object> get props => [];
}

class StartServiceError extends StartCompleteServiceState {
  final String message;
  StartServiceError({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class CompleteServiceError extends StartCompleteServiceState {
  final String message;

  CompleteServiceError({required this.message});
  @override
  List<Object> get props => [];
}
