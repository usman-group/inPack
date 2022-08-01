part of 'cigarette_bloc.dart';

@immutable
abstract class CigaretteEvent extends Equatable {
  const CigaretteEvent();
  @override
  List<Object?> get props => [];
}

class LoadCigarette extends CigaretteEvent {}

class AddCigarette extends CigaretteEvent {
  final Cigarette cigarette;
  const AddCigarette(this.cigarette);
  @override
  List<Object?> get props => [cigarette];
}

class RemoveCigarette extends CigaretteEvent {
  final Cigarette cigarette;
  const RemoveCigarette(this.cigarette);
  @override
  List<Object?> get props => [cigarette];
}
