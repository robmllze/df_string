//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Coverage for the StringCaseType enum, convertToStringCaseType, and the
// ConvertOnStringCaseTypeExtension. Every enum value is exercised against
// a stable input so regressions are immediately visible.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:df_string/df_string.dart';
import 'package:test/test.dart';

void main() {
  group('StringCaseType — enum invariants', () {
    test('all enum values have unique non-empty codes', () {
      final codes = StringCaseType.values.map((e) => e.code).toList();
      expect(
        codes.toSet().length,
        equals(codes.length),
        reason: 'codes should be unique',
      );
      for (final c in codes) {
        expect(c, isNotEmpty, reason: 'code should be non-empty');
      }
    });

    test('each enum code matches its corresponding top-level constant', () {
      expect(StringCaseType.UNCHANGED.code, equals(UNCHANGED));
      expect(StringCaseType.LOWER_SNAKE_CASE.code, equals(LOWER_SNAKE_CASE));
      expect(StringCaseType.UPPER_SNAKE_CASE.code, equals(UPPER_SNAKE_CASE));
      expect(StringCaseType.LOWER_KEBAB_CASE.code, equals(LOWER_KEBAB_CASE));
      expect(StringCaseType.UPPER_KEBAB_CASE.code, equals(UPPER_KEBAB_CASE));
      expect(
        StringCaseType.CAPITALIZED_KEBAB_CASE.code,
        equals(CAPITALIZED_KEBAB_CASE),
      );
      expect(StringCaseType.CAMEL_CASE.code, equals(CAMEL_CASE));
      expect(StringCaseType.PASCAL_CASE.code, equals(PASCAL_CASE));
      expect(StringCaseType.LOWER_DOT_CASE.code, equals(LOWER_DOT_CASE));
      expect(StringCaseType.UPPER_DOT_CASE.code, equals(UPPER_DOT_CASE));
      expect(StringCaseType.PATH_CASE.code, equals(PATH_CASE));
    });

    test('top-level constants have their literal expected names', () {
      expect(UNCHANGED, equals('UNCHANGED'));
      expect(LOWER_SNAKE_CASE, equals('LOWER_SNAKE_CASE'));
      expect(UPPER_SNAKE_CASE, equals('UPPER_SNAKE_CASE'));
      expect(LOWER_KEBAB_CASE, equals('LOWER_KEBAB_CASE'));
      expect(UPPER_KEBAB_CASE, equals('UPPER_KEBAB_CASE'));
      expect(CAPITALIZED_KEBAB_CASE, equals('CAPITALIZED_KEBAB_CASE'));
      expect(CAMEL_CASE, equals('CAMEL_CASE'));
      expect(PASCAL_CASE, equals('PASCAL_CASE'));
      expect(LOWER_DOT_CASE, equals('LOWER_DOT_CASE'));
      expect(UPPER_DOT_CASE, equals('UPPER_DOT_CASE'));
      expect(PATH_CASE, equals('PATH_CASE'));
    });
  });

  group('convertToStringCaseType — full enum coverage', () {
    const input = 'helloWorldExample';
    final expected = <StringCaseType, String>{
      StringCaseType.UNCHANGED: 'helloWorldExample',
      StringCaseType.LOWER_SNAKE_CASE: 'hello_world_example',
      StringCaseType.UPPER_SNAKE_CASE: 'HELLO_WORLD_EXAMPLE',
      StringCaseType.LOWER_KEBAB_CASE: 'hello-world-example',
      StringCaseType.UPPER_KEBAB_CASE: 'HELLO-WORLD-EXAMPLE',
      StringCaseType.CAPITALIZED_KEBAB_CASE: 'Hello-World-Example',
      StringCaseType.CAMEL_CASE: 'helloWorldExample',
      StringCaseType.PASCAL_CASE: 'HelloWorldExample',
      StringCaseType.LOWER_DOT_CASE: 'hello.world.example',
      StringCaseType.UPPER_DOT_CASE: 'HELLO.WORLD.EXAMPLE',
      StringCaseType.PATH_CASE: 'hello/world/example',
    };

    test('every enum value has an expected mapping in this test table', () {
      expect(expected.keys.toSet(), equals(StringCaseType.values.toSet()));
    });

    expected.forEach((type, want) {
      test('convertToStringCaseType(input, ${type.name}) == "$want"', () {
        expect(convertToStringCaseType(input, type), equals(want));
      });
    });

    test('null type returns the input unchanged (default branch)', () {
      expect(convertToStringCaseType(input, null), equals(input));
      expect(convertToStringCaseType('', null), equals(''));
    });

    test('UNCHANGED preserves the input verbatim (whitespace, case, etc.)', () {
      const weird = '  hello  WORLD\nfoo\tbar  ';
      expect(
        convertToStringCaseType(weird, StringCaseType.UNCHANGED),
        equals(weird),
      );
    });

    test('empty input is empty for every conversion (except UNCHANGED)', () {
      for (final t in StringCaseType.values) {
        final out = convertToStringCaseType('', t);
        expect(out, equals(''), reason: t.name);
      }
    });
  });

  group('ConvertOnStringCaseTypeExtension', () {
    test('.convert delegates to convertToStringCaseType', () {
      const s = 'helloWorld';
      for (final t in StringCaseType.values) {
        expect(
          t.convert(s),
          equals(convertToStringCaseType(s, t)),
          reason: t.name,
        );
      }
    });
    test('.convertAll maps each value', () {
      final values = ['helloWorld', 'fooBar', 'BazQux'];
      final got = StringCaseType.LOWER_SNAKE_CASE.convertAll(values).toList();
      expect(got, equals(['hello_world', 'foo_bar', 'baz_qux']));
    });
    test('.convertAll returns an Iterable that is lazy but safe to re-iterate',
        () {
      final iter = StringCaseType.UPPER_SNAKE_CASE.convertAll(['a', 'bC']);
      expect(iter.toList(), equals(['A', 'B_C']));
      // Re-iteration of the same iterable should yield the same result.
      expect(iter.toList(), equals(['A', 'B_C']));
    });
    test('.convertAll on empty iterable returns empty', () {
      final iter = StringCaseType.CAMEL_CASE.convertAll(<String>[]);
      expect(iter.toList(), isEmpty);
    });
  });
}
