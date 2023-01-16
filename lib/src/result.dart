import 'package:result/identity.dart';

abstract class Result<TFailure, TSuccess> {
  bool get isFailure;
  bool get isSuccess;

  T when<T>(
    T Function(TFailure error) whenError,
    T Function(TSuccess success) whenSuccess,
  );

  TSuccess? successOrNull() {
    return when((_) => null, id);
  }

  TFailure? failureOrNull() {
    return when(id, (_) => null);
  }

  Result<TFailure, T> map<T>(
    T Function(TSuccess success) fn,
  ) {
    return when(Failure.new, (success) => Success(fn(success)));
  }

  Result<T, TSuccess> mapError<T>(
    T Function(TFailure error) fn,
  ) {
    return when((error) => Failure(fn(error)), Success.new);
  }

  Result<TFailure, T> flatMap<T>(
    Result<TFailure, T> Function(TSuccess success) fn,
  ) {
    return when(Failure.new, fn);
  }

  Result<TFailure, TSuccess> recovery<T>(
    Result<TFailure, TSuccess> Function(TFailure error) fn,
  ) {
    return when(fn, Success.new);
  }

  Result<TFailure, T> pure<T>(
    Result<TFailure, T> Function() fn,
  ) {
    return when(Failure.new, (_) => fn());
  }
}

class Failure<TFailure, TSuccess> extends Result<TFailure, TSuccess> {
  Failure(this._value);

  final TFailure _value;

  @override
  bool get isFailure => true;

  @override
  bool get isSuccess => false;

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
  bool get isFailure => false;

  @override
  bool get isSuccess => true;

  @override
  T when<T>(
    T Function(TFailure error) whenError,
    T Function(TSuccess success) whenSuccess,
  ) {
    return whenSuccess(_value);
  }
}
