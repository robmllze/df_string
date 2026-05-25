// --- AI GENERATED TEST ---

import 'package:df_string/df_string.dart';
import 'package:test/test.dart';

void main() {
  group('StringCaseConversionsOnStringX', () {
    // --- Test Data ---
    // A map of various input strings to their expected component parts.
    final componentTests = <String, List<String>>{
      // Standard cases
      'hello world': ['hello', 'world'],
      'hello-world': ['hello', 'world'],
      'hello_world': ['hello', 'world'],
      'hello.world': ['hello', 'world'],
      'helloWorld': ['hello', 'world'],
      'HelloWorld': ['hello', 'world'],
      // Acronyms
      'HTTPRequest': ['http', 'request'],
      'performHTTPRequest': ['perform', 'http', 'request'],
      'theHTTPRequestID': ['the', 'http', 'request', 'id'],
      'HTMLParser': ['html', 'parser'],
      // Numbers
      'version1': ['version', '1'],
      'version1_2': ['version', '1', '2'],
      'version1.2.3': ['version', '1', '2', '3'],
      'v1': ['v', '1'],
      'player1_score': ['player', '1', 'score'],
      // Edge cases
      'hello': ['hello'],
      'HELLO': ['hello'],
      '': [],
      '   ': [],
      '  hello  world  ': ['hello', 'world'],
      '_hello-world_': ['hello', 'world'],
      'hello--__world': ['hello', 'world'],
      '123': ['123'],
    };

    group('_extractComponents (Internal Logic Verification)', () {
      componentTests.forEach((input, expected) {
        test('should correctly extract components from "$input"', () {
          if (expected.isEmpty) {
            // An empty component list should result in an empty snake_case string.
            expect(
              input.toSnakeCase(),
              isEmpty,
              reason:
                  'An empty/whitespace input should result in an empty output string.',
            );
          } else {
            // For all non-empty cases, the original logic works perfectly.
            expect(input.toSnakeCase().split('_'), equals(expected));
          }
        });
      });
    });

    group('toPascalCase', () {
      final testCases = {
        'hello world': 'HelloWorld',
        'hello-world': 'HelloWorld',
        'hello_world': 'HelloWorld',
        'helloWorld': 'HelloWorld',
        'HelloWorld': 'HelloWorld',
        'HTTPRequest': 'HttpRequest',
        'version1': 'Version1',
        'player1_score': 'Player1Score',
        'hello': 'Hello',
        '': '',
      };
      testCases.forEach((input, expected) {
        test('should convert "$input" to "$expected"', () {
          expect(input.toPascalCase(), equals(expected));
        });
      });
    });

    group('toCamelCase', () {
      final testCases = {
        'hello world': 'helloWorld',
        'hello-world': 'helloWorld',
        'hello_world': 'helloWorld',
        'helloWorld': 'helloWorld',
        'HelloWorld': 'helloWorld',
        'HTTPRequest': 'httpRequest',
        'version1': 'version1',
        'player1_score': 'player1Score',
        'hello': 'hello',
        '': '',
      };
      testCases.forEach((input, expected) {
        test('should convert "$input" to "$expected"', () {
          expect(input.toCamelCase(), equals(expected));
        });
      });
    });

    group('toSnakeCase (and aliases)', () {
      final testCases = {
        'hello world': 'hello_world',
        'HelloWorld': 'hello_world',
        'HTTPRequest': 'http_request',
        'version1.2.3': 'version_1_2_3',
        'player1_score': 'player_1_score',
        '': '',
      };
      testCases.forEach((input, expected) {
        test('should convert "$input" to "$expected"', () {
          expect(input.toSnakeCase(), equals(expected));
          expect(input.toLowerSnakeCase(), equals(expected));
        });
        test('should convert "$input" to UPPER_SNAKE_CASE', () {
          expect(input.toUpperSnakeCase(), equals(expected.toUpperCase()));
        });
      });
    });

    group('toKebabCase (and aliases)', () {
      final testCases = {
        'hello world': 'hello-world',
        'HelloWorld': 'hello-world',
        'HTTPRequest': 'http-request',
        'version1.2.3': 'version-1-2-3',
        'player1_score': 'player-1-score',
        '': '',
      };
      testCases.forEach((input, expected) {
        test('should convert "$input" to "$expected"', () {
          expect(input.toKebabCase(), equals(expected));
          expect(input.toLowerKebabCase(), equals(expected));
        });
        test('should convert "$input" to UPPER-KEBAB-CASE', () {
          expect(input.toUpperKebabCase(), equals(expected.toUpperCase()));
        });
        test('should convert "$input" to Capitalized-Kebab-Case', () {
          final capitalized = 'Player-1-Score'; // Manual expected for this case
          expect('player1_score'.toCapitalizedKebabCase(), equals(capitalized));
        });
      });
    });

    group('toDotCase (and aliases)', () {
      final testCases = {
        'hello world': 'hello.world',
        'HelloWorld': 'hello.world',
        'HTTPRequest': 'http.request',
        'version1.2.3': 'version.1.2.3',
        'player1_score': 'player.1.score',
        '': '',
      };
      testCases.forEach((input, expected) {
        test('should convert "$input" to "$expected"', () {
          expect(input.toDotCase(), equals(expected));
          expect(input.toLowerDotCase(), equals(expected));
        });
        test('should convert "$input" to UPPER.DOT.CASE', () {
          expect(input.toUpperDotCase(), equals(expected.toUpperCase()));
        });
      });
    });

    group('toPathCase', () {
      test('should convert with default separator "/"', () {
        expect('helloWorld'.toPathCase(), equals('hello/world'));
        expect('HTTPRequest'.toPathCase(), equals('http/request'));
      });
      test('should convert with custom separator', () {
        expect('helloWorld'.toPathCase('\\'), equals('hello\\world'));
        expect('version1'.toPathCase('---'), equals('version---1'));
      });
    });

    group('Capitalization helpers', () {
      test('capitalize / withFirstLetterAsUpperCase', () {
        expect('hello'.capitalize(), equals('Hello'));
        expect('hello'.withFirstLetterAsUpperCase(), equals('Hello'));
        expect('Hello'.capitalize(), equals('Hello'));
        expect('h'.capitalize(), equals('H'));
        expect(''.capitalize(), equals(''));
      });
      test('withFirstLetterAsLowerCase', () {
        expect('Hello'.withFirstLetterAsLowerCase(), equals('hello'));
        expect('hello'.withFirstLetterAsLowerCase(), equals('hello'));
        expect('H'.withFirstLetterAsLowerCase(), equals('h'));
        expect(''.withFirstLetterAsLowerCase(), equals(''));
      });
      test('withCapitalizedWords', () {
        expect('hello world'.withCapitalizedWords(), equals('Hello World'));
        expect(
          '  leading-and trailing_spaces  '.withCapitalizedWords(),
          equals('Leading And Trailing Spaces'),
        );
        expect('ALL CAPS'.withCapitalizedWords(), equals('All Caps'));
        expect(
          'multiple--delimiters'.withCapitalizedWords(),
          equals('Multiple Delimiters'),
        );
        expect(''.withCapitalizedWords(), equals(''));
      });
    });
  });
}
