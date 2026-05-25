//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Copyright © dev-cetera.com & contributors.
//
// The use of this source code is governed by an MIT-style license described in
// the LICENSE file located in this project's root directory.
//
// See: https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

extension CaseConversionsOnStringExt on String {
  /// Converts the string to UPPER_SNAKE_CASE.
  /// Example: 'helloWorld' -> 'HELLO_WORLD'
  String toUpperSnakeCase() => toSnakeCase().toUpperCase();

  /// Converts the string to lower_snake_case (alias for [toSnakeCase]).
  /// Example: 'HelloWorld' -> 'hello_world'
  String toLowerSnakeCase() => toSnakeCase();

  /// Converts the string to snake_case.
  String toSnakeCase() => _extractComponents().join('_');

  /// Converts the string to UPPER-KEBAB-CASE.
  /// Example: 'helloWorld' -> 'HELLO-WORLD'
  String toUpperKebabCase() => toKebabCase().toUpperCase();

  /// Converts the string to lower-kebab-case (alias for [toKebabCase]).
  /// Example: 'HelloWorld' -> 'hello-world'
  String toLowerKebabCase() => toKebabCase();

  /// Converts the string to kebab-case.
  String toKebabCase() => _extractComponents().join('-');

  /// Converts the string to Capitalized-Kebab-Case.
  /// Example: 'helloWorld' -> 'Hello-World'
  String toCapitalizedKebabCase() =>
      _extractComponents().map((e) => e.capitalize()).join('-');

  /// Converts the string to dot.case.
  String toDotCase() => _extractComponents().join('.');

  /// Converts the string to lower.dot.case (alias for [toDotCase]).
  /// Example: 'HelloWorld' -> 'hello.world'
  String toLowerDotCase() => toDotCase();

  /// Converts the string to UPPER.DOT.CASE.
  /// Example: 'HelloWorld' -> 'HELLO.WORLD'
  String toUpperDotCase() => toDotCase().toUpperCase();

  /// Converts the string to path/case.
  /// Example: 'helloWorld' -> 'hello/world'
  String toPathCase([String separator = '/']) =>
      _extractComponents().join(separator);

  /// Converts the string to camelCase.
  /// Example: 'Hello World' -> 'helloWorld'
  String toCamelCase() => toPascalCase().withFirstLetterAsLowerCase();

  /// Converts the string to PascalCase.
  /// Example: 'hello world' -> 'HelloWorld'
  String toPascalCase() =>
      _extractComponents().map((e) => e.capitalize()).join();

  /// Robustly extracts word components from a string and returns them in lowercase.
  List<String> _extractComponents() {
    if (trim().isEmpty) return []; // Return empty list for empty input
    return trim()
        // 1. Add a space before an uppercase letter followed by a lowercase one. (e.g., 'HelloWorld' -> 'Hello World')
        .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}')
        // 2. Add a space before an uppercase letter that is followed by a lowercase letter,
        //    effectively splitting acronyms. (e.g., 'HTTPRequest' -> 'HTTP Request')
        .replaceAllMapped(
          RegExp(r'([A-Z])([A-Z][a-z])'),
          (m) => '${m[1]} ${m[2]}',
        )
        // 3. Add a space between letters and numbers. (e.g., 'version1' -> 'version 1')
        .replaceAllMapped(
          RegExp(r'([a-zA-Z])([0-9])'),
          (m) => '${m[1]} ${m[2]}',
        )
        .replaceAllMapped(
          RegExp(r'([0-9])([a-zA-Z])'),
          (m) => '${m[1]} ${m[2]}',
        )
        // 4. Replace any non-alphanumeric characters with a space. (e.g., 'hello_world-123' -> 'hello world 123')
        .replaceAll(RegExp(r'[^a-zA-Z0-9]+'), ' ')
        // 5. Split by spaces and filter out any empty strings.
        .split(' ')
        .where((s) => s.isNotEmpty)
        // 6. Convert all components to lowercase.
        .map((s) => s.toLowerCase())
        .toList();
  }

  /// Returns `true` if the string is identical to its uppercase form.
  ///
  /// Note that strings without any cased letters (empty, digit-only,
  /// punctuation-only, etc.) trivially equal their uppercase form and
  /// therefore also return `true`.
  bool get isUpperCase => this == toUpperCase();

  /// Returns `true` if the string is identical to its lowercase form.
  ///
  /// Note that strings without any cased letters (empty, digit-only,
  /// punctuation-only, etc.) trivially equal their lowercase form and
  /// therefore also return `true`.
  bool get isLowerCase => this == toLowerCase();

  /// Capitalizes the first letter of the string.
  ///
  /// The same as [withFirstLetterAsUpperCase].
  String capitalize() => withFirstLetterAsUpperCase();

  /// Converts the first letter of the string to uppercase.
  ///
  /// The same as [capitalize].
  String withFirstLetterAsUpperCase() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Converts the first letter of the string to lowercase.
  String withFirstLetterAsLowerCase() {
    if (isEmpty) return this;
    return this[0].toLowerCase() + substring(1);
  }

  /// Capitalizes each word in the string, assuming words are separated by spaces, hyphens, or underscores.
  String withCapitalizedWords() {
    if (trim().isEmpty) return '';
    // FIX: Added '_' to the regex to correctly handle snake_case inputs.
    return trim()
        .split(RegExp(r'[\s-_]+'))
        .where((e) => e.isNotEmpty)
        .map((e) => e.toLowerCase().capitalize())
        .join(' ');
  }
}
