import 'package:result/identity.dart';
import 'package:result/result.dart';
import 'package:test/test.dart';

void main() {
  test('when', () async {
    final error = Future.value(Failure(0));
    final success = Future.value(Success(1));

    expect(await error.when(id, id), equals(0));
    expect(await success.when(id, id), equals(1));
  });

  test('map', () async {
    final error = Future.value(Failure(0));
    final success = Future.value(Success(0));

    final errorMap = await error.map((r) => r + 1);
    final successMap = await success.map((r) => r + 1);

    expect(errorMap.when(id, id), equals(0));
    expect(successMap.when(id, id), equals(1));
  });

  test('mapError', () async {
    final error = Future.value(Failure(0));
    final success = Future.value(Success(0));

    final errorMap = await error.mapError((l) => l + 1);
    final successMap = await success.mapError((l) => l + 1);

    expect(errorMap.when(id, id), equals(1));
    expect(successMap.when(id, id), equals(0));
  });

  test('flatMap', () async {
    final error = Future.value(Failure('L1'));
    final success = Future.value(Success('R1'));

    final a = await error.flatMap((r) async => Failure('${r}L2'));
    final b = await error.flatMap((r) async => Success('${r}R2'));
    final c = await success
        .flatMap((r) async => Failure('${r}L2'))
        .flatMap((r) async => Failure('${r}L3'));
    final d = await success
        .flatMap((r) async => Success('${r}R2'))
        .flatMap((r) async => Success('${r}R3'));

    expect(a.isLeft, isTrue);
    expect(b.isLeft, isTrue);
    expect(c.isLeft, isTrue);
    expect(d.isRight, isTrue);
    expect(a.when(id, id), equals('L1'));
    expect(b.when(id, id), equals('L1'));
    expect(c.when(id, id), equals('R1L2'));
    expect(d.when(id, id), equals('R1R2R3'));
  });

  test('recovery', () async {
    final error = Future.value(Failure('L1'));
    final success = Future.value(Success('R1'));

    final a = await error.recovery((l) async => Failure('${l}L2'));
    final b = await error.recovery((l) async => Success('${l}R2'));
    final c = await success.recovery((l) async => Failure('${l}L2'));
    final d = await success.recovery((l) async => Success('${l}R2'));

    expect(a.isLeft, isTrue);
    expect(b.isRight, isTrue);
    expect(c.isRight, isTrue);
    expect(d.isRight, isTrue);
    expect(a.when(id, id), equals('L1L2'));
    expect(b.when(id, id), equals('L1R2'));
    expect(c.when(id, id), equals('R1'));
    expect(d.when(id, id), equals('R1'));
  });
}
