abstract class Result<TFailure, TSuccess> {
  bool get isLeft;
  bool get isRight;

  T when<T>(
    T Function(TFailure error) whenError,
    T Function(TSuccess success) whenSuccess,
  );

  Result<TFailure, T> map<T>(T Function(TSuccess success) fn) {
    return when(Failure.new, (success) => Success(fn(success)));
  }

  Result<T, TSuccess> mapError<T>(T Function(TFailure error) fn) {
    return when((error) => Failure(fn(error)), Success.new);
  }

  Result<TFailure, T> flatMap<T>(
      Result<TFailure, T> Function(TSuccess success) fn) {
    return when(Failure.new, fn);
  }

  Result<TFailure, TSuccess> recovery<T>(
      Result<TFailure, TSuccess> Function(TFailure error) fn) {
    return when(fn, Success.new);
  }
}

class Failure<TFailure, TSuccess> extends Result<TFailure, TSuccess> {
  Failure(this._value);

  final TFailure _value;

  @override
  bool get isLeft => true;

  @override
  bool get isRight => false;

  @override
  T when<T>(
    T Function(TFailure error) whenError,
    T Function(TSuccess success) whenSuccess,
  ) {
    return whenError(_value);
  }
}

class Success<TFailure, TSuccess> extends Result<TFailure, TSuccess> {
  Success(this._value);

  final TSuccess _value;

  @override
  bool get isLeft => false;

  @override
  bool get isRight => true;

  @override
  T when<T>(
    T Function(TFailure error) whenError,
    T Function(TSuccess success) whenSuccess,
  ) {
    return whenSuccess(_value);
  }
}
