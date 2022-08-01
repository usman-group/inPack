part of 'cigarette_bloc.dart';

@immutable
abstract class CigaretteState extends Equatable {
  const CigaretteState();
  @override
  List<Object?> get props => [];
}

class CigaretteInitial extends CigaretteState {}

class CigaretteLoaded extends CigaretteState {
  final List<Cigarette> cigarettes;
  final cigaretteCounter = 0;
  const CigaretteLoaded({required this.cigarettes});
  @override
  List<Object?> get props => [cigarettes];
}
