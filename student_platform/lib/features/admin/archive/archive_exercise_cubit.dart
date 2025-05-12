import 'package:flutter_bloc/flutter_bloc.dart';

class ArchiveExerciseState {
  final Map<int, bool> archiveStatus;
  ArchiveExerciseState({required this.archiveStatus});
}

class ArchiveExerciseCubit extends Cubit<ArchiveExerciseState> {
  ArchiveExerciseCubit() : super(ArchiveExerciseState(archiveStatus: {}));

  void updateStatus(int exerciseId, bool newStatus) {
    if (isClosed) return; // prevent crash
    final updated = Map<int, bool>.from(state.archiveStatus);
    updated[exerciseId] = newStatus;
    emit(ArchiveExerciseState(archiveStatus: updated));
  }

  void initialize(Map<int, bool> initialStatus) {
    if (isClosed) return; // prevent crash
    emit(ArchiveExerciseState(archiveStatus: initialStatus));
  }
}
