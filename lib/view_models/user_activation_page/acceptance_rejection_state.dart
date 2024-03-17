part of 'acceptance_rejection_cubit.dart';

@immutable
abstract class AcceptanceRejectionState {}

class AcceptanceRejectionInitial extends AcceptanceRejectionState {}

class AcceptanceRejectionAccepted extends AcceptanceRejectionState {}

class AcceptanceRejectionRejected extends AcceptanceRejectionState {}

class AcceptanceRejectionError extends AcceptanceRejectionState {}