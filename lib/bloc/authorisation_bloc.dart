import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            .then((_) {
          emit(Authorised());
          Navigator.of(event.context).pushReplacementNamed('/home');
        }).catchError((e) {
          if (e is FirebaseAuthException) {
            switch (e.code) {
              case 'wrong-password':
                ScaffoldMessenger.of(event.context).showSnackBar(
                    const SnackBar(content: Text('Неверный пароль')));
                emit(Initial());
                break;
              case 'user-not-found':
                ScaffoldMessenger.of(event.context).showSnackBar(
                    const SnackBar(content: Text('Пользователь не найден')));
                emit(Initial());
                break;
              case 'invalid-email':
                ScaffoldMessenger.of(event.context).showSnackBar(
                    const SnackBar(content: Text('Неверный почтовый адрес')));
                emit(Initial());
                break;
              default:
                emit(Initial());
                break;
            }
          } else {
            throw 'Unhandled exception due sign in user $e';
          }
        });
      }
    });

    on<LogOut>((event, emit) async {
      await userRepository.signOut().then((_) {
        emit(Initial());
        Navigator.of(event.context).pushReplacementNamed('/authorisation');
      });
    });

    on<Register>((event, emit) async {
      if (state is Initial) {
        emit(RegistrationInProcess());
        return;
      }
      if (event.formKey.currentState!.validate()) {
        await userRepository
            .signUp(email: event.email, password: event.password)
            .then((_) {
          emit(Authorised());
          Navigator.of(event.context).pushReplacementNamed('/home');
        }).catchError((e) {
          switch (e.code) {
            case 'weak-password':
              ScaffoldMessenger.of(event.context)
                  .showSnackBar(const SnackBar(content: Text('Слабый пароль')));
              emit(RegistrationInProcess());
              break;
            case 'email-already-in-use':
              event.formKey.currentState!.reset();
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
