import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:in_pack/repositories/user_repository.dart';

part 'authorisation_event.dart';
part 'authorisation_state.dart';

class AuthorisationBloc extends Bloc<AuthorisationEvent, AuthorisationState> {
  final UserRepository userRepository;
  AuthorisationBloc(this.userRepository) : super(Initial()) {
    on<LogIn>((event, emit) async {
      if (event.formKey.currentState!.validate()) {
        await userRepository
            .signIn(email: event.email, password: event.password)
            .then((_) => emit(Authorised()))
            .catchError((e) {
          switch (e.code) {
            case 'wrong-password':
              emit(Initial());
              break;
            case 'user-not-found':
              emit(Initial());
              break;
            case 'invalid-email':
              emit(Initial());
              break;
            default:
              emit(Initial());
              break;
          }
        });
      }
    });

    on<LogOut>((event, emit) async {
      await userRepository.signOut().then((_) => emit(Initial()));
    });

    on<Register>((event, emit) async {
      if (event.formKey.currentState!.validate()) {
        if (state is Initial) emit(RegistrationInProcess());
        await userRepository
            .signUp(email: event.email, password: event.password)
            .then((_) => emit(Authorised()))
            .catchError((e) {
          switch (e.code) {
            case 'weak-password':
              ScaffoldMessenger.of(event.context)
                  .showSnackBar(const SnackBar(content: Text('Слабый пароль')));
              emit(RegistrationInProcess());
              break;
            case 'email-already-in-use':
              ScaffoldMessenger.of(event.context).showSnackBar(const SnackBar(
                  content: Text('Почтовый адрес уже используется')));
              emit(RegistrationInProcess());
              break;
            case 'invalid-email':
              ScaffoldMessenger.of(event.context).showSnackBar(
                  const SnackBar(content: Text('Неверный почтовый адрес')));
              emit(RegistrationInProcess());
              break;
          }
        });
      }
    });
  }
}
