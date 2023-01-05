import 'result.dart';

typedef AsyncResult<TFailure, TSuccess> = Future<Result<TFailure, TSuccess>>;

extension AsyncResultExt<TFailure, TSuccess>
    on AsyncResult<TFailure, TSuccess> {
  Future<T> when<T>(
    T Function(TFailure error) whenError,
    T Function(TSuccess success) whenSuccess,
  ) {
    return then((value) => value.when(whenError, whenSuccess));
  }

  Future<TSuccess?> tryGetSuccess() {
    return then((value) => value.tryGetSuccess());
  }

  Future<TFailure?> tryGetFailure() {
    return then((value) => value.tryGetFailure());
  }

  AsyncResult<TFailure, T> map<T>(T Function(TSuccess success) fn) {
    return then((value) => value.map(fn));
  }

  AsyncResult<T, TSuccess> mapError<T>(T Function(TFailure error) fn) {
    return then((value) => value.mapError(fn));
  }

  AsyncResult<TFailure, T> flatMap<T>(
      AsyncResult<TFailure, T> Function(TSuccess success) fn) {
    return then((value) => value.when(Failure.new, fn));
  }

  AsyncResult<TFailure, TSuccess> recovery<T>(
      AsyncResult<TFailure, TSuccess> Function(TFailure error) fn) {
    return then((value) => value.when(fn, Success.new));
  }

  AsyncResult<TFailure, T> pure<T>(AsyncResult<TFailure, T> Function() fn) {
    return then((value) => value.when(Failure.new, (_) => fn()));
  }
}

extension ResultExt<TFailure, TSuccess> on Result<TFailure, TSuccess> {
  AsyncResult<TFailure, TSuccess> toAsyncResult() async => this;
}
