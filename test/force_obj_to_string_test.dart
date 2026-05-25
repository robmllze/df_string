//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Coverage for forceObjToString — the defensive toString that must never throw.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:df_string/df_string.dart';
import 'package:test/test.dart';

class _Good {
  @override
  String toString() => 'good-object';
}

class _BadToString {
  @override
  String toString() => throw StateError('toString boom');
}

class _BadEverything {
  @override
  String toString() => throw StateError('toString boom');

  // Forcing hashCode to throw makes the fallback "<RuntimeType>@<hex>" branch
  // also throw, exercising the innermost defensive catch.
  @override
  // ignore: hash_and_equals
  int get hashCode => throw StateError('hashCode boom');
}

void main() {
  group('forceObjToString — happy path', () {
    test('uses the object\'s toString result', () {
      expect(forceObjToString(_Good()), equals('good-object'));
    });
    test('null becomes the literal "null"', () {
      expect(forceObjToString(null), equals('null'));
    });
    test('primitives use their natural toString', () {
      expect(forceObjToString(42), equals('42'));
      expect(forceObjToString(3.14), equals('3.14'));
      expect(forceObjToString(true), equals('true'));
      expect(forceObjToString(false), equals('false'));
      expect(forceObjToString('hello'), equals('hello'));
      expect(forceObjToString(''), equals(''));
    });
    test('collections use their natural toString', () {
      expect(forceObjToString(<int>[1, 2, 3]), equals('[1, 2, 3]'));
      expect(forceObjToString(<String, int>{'a': 1}), equals('{a: 1}'));
    });
  });

  group('forceObjToString — toString throws', () {
    test('falls back to "<RuntimeType>@<hex-hashcode>" and never throws', () {
      final bad = _BadToString();
      late final String out;
      expect(() => out = forceObjToString(bad), returnsNormally);
      // Format: ClassName@hexdigits
      expect(out, matches(r'^_BadToString@[0-9a-f]+$'));
      // Cross-check the hash component matches the object's identityHashCode-ish form.
      expect(out, endsWith(bad.hashCode.toRadixString(16)));
    });
  });

  group('forceObjToString — toString AND hashCode throw', () {
    test('falls back to "<unrepresentable object>" and never throws', () {
      final bad = _BadEverything();
      late final String out;
      expect(() => out = forceObjToString(bad), returnsNormally);
      expect(out, equals('<unrepresentable object>'));
    });
  });

  group('ForceObjToStringOnObjectExt extension', () {
    test('extension on Object proxies to forceObjToString', () {
      final g = _Good();
      expect(g.forceObjToString(), equals('good-object'));
      expect(42.forceObjToString(), equals('42'));
      expect('hello'.forceObjToString(), equals('hello'));
    });
    test('extension catches toString errors from the underlying object', () {
      final out = _BadToString().forceObjToString();
      expect(out, matches(r'^_BadToString@[0-9a-f]+$'));
    });
    test('extension catches even when hashCode also throws', () {
      expect(
        _BadEverything().forceObjToString(),
        equals('<unrepresentable object>'),
      );
    });
  });
}
