import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_platform/features/admin/circle/domain/usecases/add_circle.dart';
import 'circle_event.dart';
import 'circle_state.dart';

class CircleBloc extends Bloc<CircleEvent, CircleState> {
  final AddCircle addCircle;

  CircleBloc(this.addCircle) : super(CircleInitial()) {
    on<SubmitCircle>(_onSubmit);
  }

  Future<void> _onSubmit(SubmitCircle event, Emitter<CircleState> emit) async {
    emit(CircleLoading());
    try {
      await addCircle(event.circle);
      emit(CircleSuccess());
    } catch (e) {
      print(e);
      emit(CircleFailure('فشل في إضافة الحلقة'));
    }
  }
}
