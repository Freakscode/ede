import 'package:equatable/equatable.dart';

import '../error/failures.dart';

// Result wrapper for use cases
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends Result<T> {
  final Failure failure;
  const Error(this.failure);
}

abstract class UseCase<Type, Params> {
  Future<Result<Type>> call(Params params);
}

abstract class StreamUseCase<Type, Params> {
  Stream<Result<Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
