//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Edge-case coverage for CaseConversionsOnStringExt.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:df_string/df_string.dart';
import 'package:test/test.dart';

void main() {
  group('CaseConversionsOnStringExt — empty & whitespace', () {
    for (final input in <String>['', ' ', '   ', '\t', '\n', '\r\n', '\t \n']) {
      test('all conversions of ${jsonStr(input)} return ""', () {
        expect(input.toSnakeCase(), equals(''));
        expect(input.toLowerSnakeCase(), equals(''));
        expect(input.toUpperSnakeCase(), equals(''));
        expect(input.toKebabCase(), equals(''));
        expect(input.toLowerKebabCase(), equals(''));
        expect(input.toUpperKebabCase(), equals(''));
        expect(input.toCapitalizedKebabCase(), equals(''));
        expect(input.toDotCase(), equals(''));
        expect(input.toLowerDotCase(), equals(''));
        expect(input.toUpperDotCase(), equals(''));
        expect(input.toPathCase(), equals(''));
        expect(input.toPathCase('|'), equals(''));
        expect(input.toCamelCase(), equals(''));
        expect(input.toPascalCase(), equals(''));
      });
    }
  });

  group('CaseConversionsOnStringExt — single character', () {
    test('lowercase single char round-trips through all conversions', () {
      expect('a'.toSnakeCase(), equals('a'));
      expect('a'.toUpperSnakeCase(), equals('A'));
      expect('a'.toKebabCase(), equals('a'));
      expect('a'.toUpperKebabCase(), equals('A'));
      expect('a'.toCapitalizedKebabCase(), equals('A'));
      expect('a'.toDotCase(), equals('a'));
      expect('a'.toUpperDotCase(), equals('A'));
      expect('a'.toPathCase(), equals('a'));
      expect('a'.toCamelCase(), equals('a'));
      expect('a'.toPascalCase(), equals('A'));
    });

    test('uppercase single char is lowercased by component extraction', () {
      expect('A'.toSnakeCase(), equals('a'));
      expect('A'.toUpperSnakeCase(), equals('A'));
      expect('A'.toCamelCase(), equals('a'));
      expect('A'.toPascalCase(), equals('A'));
    });

    test('digit-only single char stays unchanged', () {
      expect('7'.toSnakeCase(), equals('7'));
      expect('7'.toKebabCase(), equals('7'));
      expect('7'.toDotCase(), equals('7'));
      expect('7'.toPathCase(), equals('7'));
      expect('7'.toCamelCase(), equals('7'));
      expect('7'.toPascalCase(), equals('7'));
    });

    test('symbol-only single char yields empty (stripped as non-alphanumeric)',
        () {
      for (final c in <String>['_', '-', '.', '!', '#', '/', '\\']) {
        expect(c.toSnakeCase(), equals(''), reason: 'input: ${jsonStr(c)}');
        expect(c.toKebabCase(), equals(''), reason: 'input: ${jsonStr(c)}');
        expect(c.toDotCase(), equals(''), reason: 'input: ${jsonStr(c)}');
        expect(c.toCamelCase(), equals(''), reason: 'input: ${jsonStr(c)}');
        expect(c.toPascalCase(), equals(''), reason: 'input: ${jsonStr(c)}');
      }
    });
  });

  group('CaseConversionsOnStringExt — acronyms & mixed case', () {
    // The algorithm splits acronyms only when followed by a single Pascal-cased
    // word ("XMLParser" -> ["XML","Parser"]). Digits attach to the letter run
    // they touch, so an acronym followed by digits stays whole
    // ("HTTP2" -> ["http2"]).
    test('XMLParser splits as expected', () {
      expect('XMLParser'.toSnakeCase(), equals('xml_parser'));
    });
    test('XMLHTTPRequest splits each Pascal word', () {
      expect('XMLHTTPRequest'.toSnakeCase(), equals('xmlhttp_request'));
    });
    test('HTTP2 stays as one component, digit attaches to the acronym', () {
      expect('HTTP2'.toSnakeCase(), equals('http2'));
    });
    test('iOS / iOSDevice (camel-leading acronym)', () {
      expect('iOS'.toSnakeCase(), equals('i_os'));
      expect('iOSDevice'.toSnakeCase(), equals('i_os_device'));
    });
    test('alternating case stays preserved by component split', () {
      expect('AbCdEf'.toSnakeCase(), equals('ab_cd_ef'));
    });
  });

  group('CaseConversionsOnStringExt — numbers & alphanumerics', () {
    test('digits stay attached to the letter run they touch', () {
      expect('version1'.toSnakeCase(), equals('version1'));
      expect('v1'.toSnakeCase(), equals('v1'));
      expect('1a'.toSnakeCase(), equals('1a'));
      expect('1abc2'.toSnakeCase(), equals('1abc2'));
      expect('a1b2c3'.toSnakeCase(), equals('a1b2c3'));
    });
    test('a digit followed by an uppercase letter is still a boundary', () {
      expect('foo1Bar'.toSnakeCase(), equals('foo1_bar'));
      expect('player1Score'.toSnakeCase(), equals('player1_score'));
    });
    test('digit-only strings stay as a single component', () {
      expect('123'.toSnakeCase(), equals('123'));
      expect('1234567890'.toSnakeCase(), equals('1234567890'));
    });
    test('dotted version-like numbers split on the dot', () {
      expect('1.2.3'.toSnakeCase(), equals('1_2_3'));
      expect('v1.2.3'.toSnakeCase(), equals('v1_2_3'));
    });
    // Regression: snake_case / camelCase must round-trip identifier names that
    // embed digits without inserting spurious underscores at the digit
    // boundary. Column names like `phone_e164` / `line1` are code-generated by
    // camel-casing then snake-casing; a digit split there produced
    // `phone_e_164` / `line_1`, which no longer matched the database column.
    test('digit-embedded identifiers survive a snake -> camel -> snake trip',
        () {
      for (final column in <String>[
        'phone_e164',
        'line1',
        'line2',
        'sha256_hash',
        'oauth2_token',
        'utf8_payload',
      ]) {
        expect(
          column.toCamelCase().toSnakeCase(),
          equals(column),
          reason: 'column: $column',
        );
      }
      expect('phone_e164'.toCamelCase(), equals('phoneE164'));
      expect('phoneE164'.toSnakeCase(), equals('phone_e164'));
      expect('line1'.toCamelCase(), equals('line1'));
      expect('line1'.toSnakeCase(), equals('line1'));
    });
  });

  group('CaseConversionsOnStringExt — delimiters', () {
    test('leading and trailing delimiters are stripped', () {
      expect('_hello_world_'.toSnakeCase(), equals('hello_world'));
      expect('-hello-world-'.toKebabCase(), equals('hello-world'));
      expect('.hello.world.'.toDotCase(), equals('hello.world'));
      expect('/hello/world/'.toPathCase(), equals('hello/world'));
    });
    test('runs of delimiters collapse into a single boundary', () {
      expect('hello___world'.toSnakeCase(), equals('hello_world'));
      expect('hello---world'.toKebabCase(), equals('hello-world'));
      expect('hello...world'.toDotCase(), equals('hello.world'));
      expect('hello   world'.toSnakeCase(), equals('hello_world'));
    });
    test('mixed delimiters are normalised', () {
      expect('hello-_.world'.toSnakeCase(), equals('hello_world'));
      expect('hello-_.world'.toKebabCase(), equals('hello-world'));
      expect('hello-_.world'.toDotCase(), equals('hello.world'));
    });
  });

  group('CaseConversionsOnStringExt — Unicode (documented current behavior)',
      () {
    // The component extractor matches ASCII letters/digits only.
    // Non-ASCII characters are treated as delimiters and stripped.
    test('accented letters are stripped (ASCII-only matcher)', () {
      expect('café'.toSnakeCase(), equals('caf'));
      expect('jalapeño'.toSnakeCase(), equals('jalape_o'));
      expect('naïve'.toSnakeCase(), equals('na_ve'));
    });
    test('emoji are stripped', () {
      expect('hello👋world'.toSnakeCase(), equals('hello_world'));
      expect('🎉party🎉'.toSnakeCase(), equals('party'));
    });
    test('non-latin scripts (CJK / Cyrillic) are stripped', () {
      expect('hello世界'.toSnakeCase(), equals('hello'));
      expect('привет'.toSnakeCase(), equals(''));
    });
  });

  group('CaseConversionsOnStringExt — toPathCase separator', () {
    test('default separator is /', () {
      // Each Pascal/camel boundary creates a component, so 'aB cD' becomes
      // ['a','b','c','d'] joined with '/'.
      expect('aB cD'.toPathCase(), equals('a/b/c/d'));
      expect('helloWorld'.toPathCase(), equals('hello/world'));
    });
    test('custom separator can be any string, including empty', () {
      expect('helloWorld'.toPathCase('\\'), equals('hello\\world'));
      expect('helloWorld'.toPathCase('::'), equals('hello::world'));
      expect('helloWorld'.toPathCase(''), equals('helloworld'));
    });
  });

  group('CaseConversionsOnStringExt — idempotency', () {
    final samples = <String>[
      'helloWorld',
      'HelloWorld',
      'hello_world',
      'hello-world',
      'hello.world',
      'HTTPRequest',
      'player1_score',
      'a',
      'A',
      '',
      '  hello  world  ',
    ];

    test('toSnakeCase is idempotent', () {
      for (final s in samples) {
        final once = s.toSnakeCase();
        expect(
          once.toSnakeCase(),
          equals(once),
          reason: 'input: ${jsonStr(s)}',
        );
      }
    });
    test('toKebabCase is idempotent', () {
      for (final s in samples) {
        final once = s.toKebabCase();
        expect(
          once.toKebabCase(),
          equals(once),
          reason: 'input: ${jsonStr(s)}',
        );
      }
    });
    test('toDotCase is idempotent', () {
      for (final s in samples) {
        final once = s.toDotCase();
        expect(once.toDotCase(), equals(once), reason: 'input: ${jsonStr(s)}');
      }
    });
    test('toPascalCase is idempotent', () {
      for (final s in samples) {
        final once = s.toPascalCase();
        expect(
          once.toPascalCase(),
          equals(once),
          reason: 'input: ${jsonStr(s)}',
        );
      }
    });
    test('toCamelCase is idempotent', () {
      for (final s in samples) {
        final once = s.toCamelCase();
        expect(
          once.toCamelCase(),
          equals(once),
          reason: 'input: ${jsonStr(s)}',
        );
      }
    });
  });

  group('CaseConversionsOnStringExt — round-trip preservation of components',
      () {
    // For inputs that ALREADY have purely-ASCII alphanumerics and clean
    // word boundaries, converting between cases should preserve the
    // underlying word components.
    final samples = <String>[
      'helloWorld',
      'HelloWorld',
      'hello_world',
      'hello-world',
      'hello.world',
      'foo_bar_baz',
      'fooBar123',
    ];

    test('snake -> camel -> snake preserves snake form', () {
      for (final s in samples) {
        final snake = s.toSnakeCase();
        expect(
          snake.toCamelCase().toSnakeCase(),
          equals(snake),
          reason: 'input: ${jsonStr(s)}',
        );
      }
    });
    test('snake -> kebab -> snake preserves snake form', () {
      for (final s in samples) {
        final snake = s.toSnakeCase();
        expect(
          snake.toKebabCase().toSnakeCase(),
          equals(snake),
          reason: 'input: ${jsonStr(s)}',
        );
      }
    });
    test('snake -> dot -> snake preserves snake form', () {
      for (final s in samples) {
        final snake = s.toSnakeCase();
        expect(
          snake.toDotCase().toSnakeCase(),
          equals(snake),
          reason: 'input: ${jsonStr(s)}',
        );
      }
    });
    test('pascal -> snake -> pascal preserves pascal form', () {
      for (final s in samples) {
        final pascal = s.toPascalCase();
        expect(
          pascal.toSnakeCase().toPascalCase(),
          equals(pascal),
          reason: 'input: ${jsonStr(s)}',
        );
      }
    });
  });

  group('CaseConversionsOnStringExt — capitalize helpers', () {
    test('capitalize is alias of withFirstLetterAsUpperCase', () {
      for (final s in <String>['hello', 'Hello', 'h', 'H', '', '1abc']) {
        expect(
          s.capitalize(),
          equals(s.withFirstLetterAsUpperCase()),
          reason: 'input: ${jsonStr(s)}',
        );
      }
    });
    test('withFirstLetterAsUpperCase leaves leading non-letter unchanged', () {
      expect('1abc'.withFirstLetterAsUpperCase(), equals('1abc'));
      expect(' hello'.withFirstLetterAsUpperCase(), equals(' hello'));
      expect('-x'.withFirstLetterAsUpperCase(), equals('-x'));
    });
    test('withFirstLetterAsLowerCase leaves leading non-letter unchanged', () {
      expect('1ABC'.withFirstLetterAsLowerCase(), equals('1ABC'));
      expect(' HELLO'.withFirstLetterAsLowerCase(), equals(' HELLO'));
    });
    test('withFirstLetterAsUpperCase on empty stays empty', () {
      expect(''.withFirstLetterAsUpperCase(), equals(''));
      expect(''.withFirstLetterAsLowerCase(), equals(''));
      expect(''.capitalize(), equals(''));
    });
    test('only first letter is affected, rest is preserved verbatim', () {
      expect('hELLO'.withFirstLetterAsUpperCase(), equals('HELLO'));
      expect('Hello WORLD'.withFirstLetterAsLowerCase(), equals('hello WORLD'));
    });
  });

  group('CaseConversionsOnStringExt — withCapitalizedWords', () {
    test('splits on whitespace, hyphen, and underscore (not camelCase)', () {
      expect('hello world'.withCapitalizedWords(), equals('Hello World'));
      expect('hello-world'.withCapitalizedWords(), equals('Hello World'));
      expect('hello_world'.withCapitalizedWords(), equals('Hello World'));
      // camelCase is NOT split:
      expect('helloWorld'.withCapitalizedWords(), equals('Helloworld'));
    });
    test('collapses runs of delimiters', () {
      expect(
        'hello---world___foo   bar'.withCapitalizedWords(),
        equals('Hello World Foo Bar'),
      );
    });
    test('leading/trailing delimiters are trimmed', () {
      expect(
        '  -__hello world__-  '.withCapitalizedWords(),
        equals('Hello World'),
      );
    });
    test('empty / whitespace returns empty', () {
      expect(''.withCapitalizedWords(), equals(''));
      expect('   '.withCapitalizedWords(), equals(''));
      expect('\n\t'.withCapitalizedWords(), equals(''));
    });
    test('uppercase words are lowercased then capitalized', () {
      expect('HELLO WORLD'.withCapitalizedWords(), equals('Hello World'));
      expect('HELLO'.withCapitalizedWords(), equals('Hello'));
    });
    test('digits remain unchanged inside words', () {
      expect('player1 score2'.withCapitalizedWords(), equals('Player1 Score2'));
    });
  });

  group('CaseConversionsOnStringExt — isUpperCase / isLowerCase', () {
    // Documented semantic: `s == s.toUpperCase()` / `s == s.toLowerCase()`.
    // This means strings without cased letters trivially answer true.
    test('all-uppercase letters', () {
      expect('HELLO'.isUpperCase, isTrue);
      expect('HELLO'.isLowerCase, isFalse);
    });
    test('all-lowercase letters', () {
      expect('hello'.isLowerCase, isTrue);
      expect('hello'.isUpperCase, isFalse);
    });
    test('mixed case is neither', () {
      expect('Hello'.isUpperCase, isFalse);
      expect('Hello'.isLowerCase, isFalse);
    });
    test('uncased characters (digits, symbols, empty) are BOTH', () {
      for (final s in <String>['', '1', '123', '!?', '   ', '_']) {
        expect(s.isUpperCase, isTrue, reason: 'isUpperCase ${jsonStr(s)}');
        expect(s.isLowerCase, isTrue, reason: 'isLowerCase ${jsonStr(s)}');
      }
    });
    test('mix of digits + uppercase letters is upper, not lower', () {
      expect('A1B2'.isUpperCase, isTrue);
      expect('A1B2'.isLowerCase, isFalse);
    });
  });

  group('CaseConversionsOnStringExt — large input does not crash', () {
    test('very long ASCII string is processed', () {
      final s = 'helloWorld' * 1000; // 10_000 chars
      final out = s.toSnakeCase();
      // helloWorld -> hello_world ; concatenated repeatedly produces
      // hello_worldhello_world... with no extra underscores between repeats
      // because the last 'd' is followed by 'h' (lowercase-lowercase, no split).
      // We only assert that conversion completes and contains the expected
      // markers.
      expect(out, contains('hello_world'));
      expect(out.length, greaterThan(10000));
    });
  });
}

// Helper: produce a human-readable form of weird inputs (\n, tabs etc).
String jsonStr(String s) =>
    '"${s.replaceAll(r'\', r'\\').replaceAll('"', r'\"').replaceAll('\n', r'\n').replaceAll('\t', r'\t').replaceAll('\r', r'\r')}"';
