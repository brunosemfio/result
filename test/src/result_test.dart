import 'package:result/identity.dart';
import 'package:result/result.dart';
import 'package:test/test.dart';

void main() {
  test('left', () {
    final error = Failure(0);

    expect(error.isFailure, true);
    expect(error.isSuccess, false);
    expect(error.when(id, id), equals(0));
  });

  test('right', () {
    final sucess = Success(1);

    expect(sucess.isFailure, false);
    expect(sucess.isSuccess, true);
    expect(sucess.when(id, id), equals(1));
  });

  test('when', () {
    final error = Failure(0);
    final success = Success(1);

    expect(error.when(id, id), equals(0));
    expect(success.when(id, id), equals(1));
  });

  test('tryGetSuccess', () {
    final error = Failure(0);
    final success = Success(1);

    expect(error.tryGetSuccess(), isNull);
    expect(success.tryGetSuccess(), equals(1));
  });

  test('tryGetFailure', () {
    final error = Failure(0);
    final success = Success(1);

    expect(error.tryGetFailure(), equals(0));
    expect(success.tryGetFailure(), isNull);
  });

  test('map', () {
    final error = Failure(0);
    final success = Success(0);

    final errorMap = error.map((r) => r + 1);
    final successMap = success.map((r) => r + 1);

    expect(errorMap.when(id, id), equals(0));
    expect(successMap.when(id, id), equals(1));
  });

  test('mapError', () {
    final error = Failure(0);
    final success = Success(0);

    final errorMap = error.mapError((l) => l + 1);
    final successMap = success.mapError((l) => l + 1);

    expect(errorMap.when(id, id), equals(1));
    expect(successMap.when(id, id), equals(0));
  });

  test('flatMap', () {
    final error = Failure(0);
    final success = Success(0);

    final a = error.flatMap((r) => Failure(r + 1));
    final b = error.flatMap((r) => Success(r + 2));
    final c = success.flatMap((r) => Failure(r + 1));
    final d = success.flatMap((r) => Success(r + 2));

    expect(a.isFailure, isTrue);
    expect(b.isFailure, isTrue);
    expect(c.isFailure, isTrue);
    expect(d.isSuccess, isTrue);
    expect(a.when(id, id), equals(0));
    expect(b.when(id, id), equals(0));
    expect(c.when(id, id), equals(1));
    expect(d.when(id, id), equals(2));
  });

  test('recovery', () {
    final error = Failure(0);
    final success = Success(0);

    final a = error.recovery((l) => Failure(l + 1));
    final b = error.recovery((l) => Success(l + 2));
    final c = success.recovery((l) => Failure(l + 1));
    final d = success.recovery((l) => Success(l + 2));

    expect(a.isFailure, isTrue);
    expect(b.isSuccess, isTrue);
    expect(c.isSuccess, isTrue);
    expect(d.isSuccess, isTrue);
    expect(a.when(id, id), equals(1));
    expect(b.when(id, id), equals(2));
    expect(c.when(id, id), equals(0));
    expect(d.when(id, id), equals(0));
  });

  test('pure', () {
    final error = Failure(0);
    final success = Success(0);

    final a = error.pure(() => Failure(1));
    final b = error.pure(() => Success(2));
    final c = success.pure(() => Failure(1));
    final d = success.pure(() => Success(2));

    expect(a.isFailure, isTrue);
    expect(b.isFailure, isTrue);
    expect(c.isFailure, isTrue);
    expect(d.isSuccess, isTrue);
    expect(a.when(id, id), equals(0));
    expect(b.when(id, id), equals(0));
    expect(c.when(id, id), equals(1));
    expect(d.when(id, id), equals(2));
  });
}
