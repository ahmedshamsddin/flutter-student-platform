import 'package:flutter_bloc/flutter_bloc.dart';

class ArchiveQuestionState {
  final Map<int, bool> archiveStatus;

  ArchiveQuestionState({required this.archiveStatus});
}

class ArchiveQuestionCubit extends Cubit<ArchiveQuestionState> {
  ArchiveQuestionCubit() : super(ArchiveQuestionState(archiveStatus: {}));

  void initialize(Map<int, bool> initialStatus) {
    emit(ArchiveQuestionState(archiveStatus: Map<int, bool>.from(initialStatus)));
  }

  void updateStatus(int questionId, bool newStatus) {
    final updated = Map<int, bool>.from(state.archiveStatus);
    updated[questionId] = newStatus;
    emit(ArchiveQuestionState(archiveStatus: updated));
  }
}
