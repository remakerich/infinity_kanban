import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinity_kanban/core/models/either.dart';

part 'failure.freezed.dart';

@freezed
class Failure with _$Failure {
  const Failure._();

  const factory Failure.client(String message) = FailureClient;
}

Future<Either<Failure, T>> handleExceptions<T>(
  Future<T> Function() future,
) async {
  try {
    final result = await future();
    return Right(result);
  } catch (e, trace) {
    return Left(Failure.client('$e $trace'));
  }
}
