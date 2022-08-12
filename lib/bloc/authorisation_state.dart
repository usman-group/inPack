part of 'authorisation_bloc.dart';

@immutable
abstract class AuthorisationState {}

class Initial extends AuthorisationState {}

class RegistrationInProcess extends AuthorisationState {}

class Authorised extends AuthorisationState {}
