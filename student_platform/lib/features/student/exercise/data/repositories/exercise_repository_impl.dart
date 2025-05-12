import '../../domain/entities/exercise.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../datasources/exercise_remote_datasource.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  final ExerciseRemoteDataSource remoteDataSource;

  ExerciseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Exercise>> getExercisesForLesson(int lessonId) {
    print(remoteDataSource.fetchExercisesForLesson(lessonId));
    return remoteDataSource.fetchExercisesForLesson(lessonId);
  }
}
