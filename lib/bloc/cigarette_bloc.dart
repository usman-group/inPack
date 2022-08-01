import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:in_pack/models/cigarette.dart';
import 'package:meta/meta.dart';

part 'cigarette_event.dart';
part 'cigarette_state.dart';

class CigaretteBloc extends Bloc<CigaretteEvent, CigaretteState> {
  CigaretteBloc() : super(CigaretteInitial()) {
    on<LoadCigarette>((event, emit) async {
      await Future.delayed(const Duration(seconds: 1));
      emit(const CigaretteLoaded(cigarettes: <Cigarette>[]));
    });
    on<AddCigarette>((event, emit) {
      if (state is CigaretteLoaded) {
        List<Cigarette> cigarettes =
            List.from((state as CigaretteLoaded).cigarettes);
        emit(CigaretteLoaded(cigarettes: cigarettes..add(event.cigarette)));
      }
    });
    on<RemoveCigarette>((event, emit) {
      if (state is CigaretteLoaded) {
        List<Cigarette> cigarettes =
            List.from((state as CigaretteLoaded).cigarettes);
        emit(CigaretteLoaded(cigarettes: cigarettes..remove(event.cigarette)));
      }
    });
  }
}
