part of 'authorisation_bloc.dart';

@immutable
abstract class AuthorisationEvent {}

class LogIn extends AuthorisationEvent {
  LogIn(
      {required this.email,
      required this.password,
      required this.formKey,
      required this.context});
  final BuildContext context;
  final GlobalKey<FormState> formKey;
  final String email;
  final String password;
}

class LogOut extends AuthorisationEvent {}

class Register extends AuthorisationEvent {
  Register(
      {required this.email,
      required this.password,
      required this.context,
      required this.formKey});

  final BuildContext context;
  final GlobalKey<FormState> formKey;
  final String email;
  final String password;
}
