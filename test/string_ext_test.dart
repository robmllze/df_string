//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Coverage for StringExt1: nullIfEmpty, truncToLength, withNormalizedWhitespace,
// replaceLast, splitByLastOccurrenceOf.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:df_string/df_string.dart';
import 'package:test/test.dart';

void main() {
  group('StringExt1.nullIfEmpty', () {
    test('returns null when empty', () {
      expect(''.nullIfEmpty, isNull);
    });
    test('returns string when non-empty (even whitespace-only)', () {
      expect('x'.nullIfEmpty, equals('x'));
      expect(' '.nullIfEmpty, equals(' '));
      expect('\n'.nullIfEmpty, equals('\n'));
    });
  });

  group('StringExt1.truncToLength — no truncation', () {
    test('original shorter than length: returned unchanged, no ellipsis', () {
      expect('hello'.truncToLength(10), equals('hello'));
      expect('hello'.truncToLength(10, ellipsis: '...'), equals('hello'));
      expect(''.truncToLength(5, ellipsis: '...'), equals(''));
      expect(''.truncToLength(0, ellipsis: '...'), equals(''));
    });
    test('original exactly length: returned unchanged, no ellipsis', () {
      expect('hello'.truncToLength(5), equals('hello'));
      expect('hello'.truncToLength(5, ellipsis: '...'), equals('hello'));
    });
  });

  group('StringExt1.truncToLength — truncation happens', () {
    test('cut at word boundary, trailing space is trimmed (then ellipsis)', () {
      // 'Hello World' -> substring(0,6) = 'Hello ' -> trimRight = 'Hello'
      expect(
        'Hello World'.truncToLength(6, ellipsis: '...'),
        equals('Hello...'),
      );
    });
    test('cut mid-word: ellipsis still applied', () {
      // Was a bug: previously 'HelloWo' (no ellipsis). Now 'HelloWo...'.
      expect(
        'HelloWorld'.truncToLength(7, ellipsis: '...'),
        equals('HelloWo...'),
      );
    });
    test('docstring example: 5-cut of "Hello World" with "..."', () {
      expect(
        'Hello World'.truncToLength(5, ellipsis: '...'),
        equals('Hello...'),
      );
    });
    test('no ellipsis specified: just the truncated/trimmed core', () {
      expect('Hello World'.truncToLength(5), equals('Hello'));
      expect('Hello World'.truncToLength(6), equals('Hello'));
      expect('Hello World'.truncToLength(7), equals('Hello W'));
    });
    test('length 0 collapses to ellipsis (or empty string when no ellipsis)',
        () {
      expect('hello'.truncToLength(0), equals(''));
      expect('hello'.truncToLength(0, ellipsis: '...'), equals('...'));
    });
    test('leading whitespace is preserved (only trailing is trimmed)', () {
      expect(
        '  Hello World'.truncToLength(8, ellipsis: '…'),
        equals('  Hello…'),
      );
    });
    test('very long string is truncated correctly', () {
      final long = 'a' * 10000;
      final out = long.truncToLength(50, ellipsis: '...');
      expect(out, equals('${'a' * 50}...'));
      expect(out.length, equals(53));
    });
  });

  group('StringExt1.truncToLength — invalid length', () {
    test('negative length throws RangeError', () {
      expect(() => 'hello'.truncToLength(-1), throwsA(isA<RangeError>()));
      expect(
        () => 'hello'.truncToLength(-100, ellipsis: '...'),
        throwsA(isA<RangeError>()),
      );
    });
  });

  group('StringExt1.withNormalizedWhitespace', () {
    test('collapses runs of any whitespace to single space by default', () {
      expect('a  b'.withNormalizedWhitespace(), equals('a b'));
      expect('a\t\tb'.withNormalizedWhitespace(), equals('a b'));
      expect('a\n\nb'.withNormalizedWhitespace(), equals('a b'));
      expect('a \t\n\r b'.withNormalizedWhitespace(), equals('a b'));
    });
    test('leading and trailing whitespace becomes a single replacement', () {
      expect('  hello  '.withNormalizedWhitespace(), equals(' hello '));
    });
    test('custom replacement string', () {
      expect('a  b'.withNormalizedWhitespace('-'), equals('a-b'));
      expect('a b c'.withNormalizedWhitespace('__'), equals('a__b__c'));
      expect('a b'.withNormalizedWhitespace(''), equals('ab'));
    });
    test('no whitespace: input returned unchanged', () {
      expect('abc'.withNormalizedWhitespace(), equals('abc'));
    });
    test('empty input', () {
      expect(''.withNormalizedWhitespace(), equals(''));
    });
    test('only whitespace becomes a single replacement', () {
      expect('   '.withNormalizedWhitespace(), equals(' '));
      expect('\t\n\r '.withNormalizedWhitespace(), equals(' '));
    });
  });

  group('StringExt1.replaceLast', () {
    test('replaces only the last occurrence of a string pattern', () {
      expect('a-b-c'.replaceLast('-', '/'), equals('a-b/c'));
      expect('aaa'.replaceLast('a', 'X'), equals('aaX'));
    });
    test('returns original when pattern not found', () {
      expect('abc'.replaceLast('z', 'X'), equals('abc'));
      expect(''.replaceLast('x', 'Y'), equals(''));
    });
    test('respects startIndex (searches from that index onward)', () {
      // 'aaaa' lastOccurrence-of('a') starting at index 2 -> last at index 3.
      expect('aaaa'.replaceLast('a', 'X', 2), equals('aaaX'));
      // startIndex past last 'a' -> not found, original returned.
      expect('aaaa'.replaceLast('a', 'X', 4), equals('aaaa'));
    });
    test('works with RegExp patterns', () {
      expect(
        'foo123bar456baz'.replaceLast(RegExp(r'\d+'), 'N'),
        equals('foo123barNbaz'),
      );
      expect('abcabc'.replaceLast(RegExp('a'), 'Z'), equals('abcZbc'));
    });
    test('replacement may be longer or shorter than match', () {
      expect('a-b-c'.replaceLast('-', '---'), equals('a-b---c'));
      expect('abc--xyz'.replaceLast('--', ''), equals('abcxyz'));
    });
    test('replacement at the very end of the string', () {
      expect('foo!'.replaceLast('!', '?'), equals('foo?'));
    });
    test('replacement at the very start of the string', () {
      expect('!foo'.replaceLast('!', '?'), equals('?foo'));
    });
  });

  group('StringExt1.splitByLastOccurrenceOf', () {
    test('splits non-empty input on existing separator', () {
      expect('a/b/c'.splitByLastOccurrenceOf('/'), equals(['a/b', 'c']));
      expect(
        'one.two.three'.splitByLastOccurrenceOf('.'),
        equals(['one.two', 'three']),
      );
    });
    test('returns [this] when separator is not found', () {
      expect('abc'.splitByLastOccurrenceOf('/'), equals(['abc']));
      expect(''.splitByLastOccurrenceOf('/'), equals(['']));
    });
    test('multi-char separator', () {
      expect(
        'foo--bar--baz'.splitByLastOccurrenceOf('--'),
        equals(['foo--bar', 'baz']),
      );
    });
    test('separator at the start', () {
      expect('/abc'.splitByLastOccurrenceOf('/'), equals(['', 'abc']));
    });
    test('separator at the end', () {
      expect('abc/'.splitByLastOccurrenceOf('/'), equals(['abc', '']));
    });
    test('whole string is the separator', () {
      expect('//'.splitByLastOccurrenceOf('//'), equals(['', '']));
    });
    test('empty separator: documented quirk — returns [input, ""]', () {
      // lastIndexOf('') returns this.length, so we split "after the end".
      expect('hello'.splitByLastOccurrenceOf(''), equals(['hello', '']));
    });
  });
}
