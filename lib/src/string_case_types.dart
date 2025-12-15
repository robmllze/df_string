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

import 'extensions/case_conversions_on_string_ext.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Enum for different string case types.
enum StringCaseType {
  //
  //
  //

  UNCHANGED(_UNCHANGED),
  LOWER_SNAKE_CASE(_LOWER_SNAKE_CASE),
  UPPER_SNAKE_CASE(_UPPER_SNAKE_CASE),
  LOWER_KEBAB_CASE(_LOWER_KEBAB_CASE),
  UPPER_KEBAB_CASE(_UPPER_KEBAB_CASE),
  CAPITALIZED_KEBAB_CASE(_CAPITALIZED_KEBAB_CASE),
  CAMEL_CASE(_CAMEL_CASE),
  PASCAL_CASE(_PASCAL_CASE),
  LOWER_DOT_CASE(_LOWER_DOT_CASE),
  UPPER_DOT_CASE(_UPPER_DOT_CASE),
  PATH_CASE(_PATH_CASE);

  //
  //
  //

  final String code;

  //
  //
  //

  const StringCaseType(this.code);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A key representing an unchanged string.
/// This is used when no conversion is needed.
const UNCHANGED = 'UNCHANGED';

/// A key representing camel case.
const CAMEL_CASE = 'CAMEL_CASE';

/// A key representing lower dot case.
const LOWER_DOT_CASE = 'LOWER_DOT_CASE';

/// A key representing lower kebab case.
const LOWER_KEBAB_CASE = 'LOWER_KEBAB_CASE';

/// A key representing lower kebab case.
const CAPITALIZED_KEBAB_CASE = 'CAPITALIZED_KEBAB_CASE';

/// A key representing lower snake case.
const LOWER_SNAKE_CASE = 'LOWER_SNAKE_CASE';

/// A key representing pascal case.
const PASCAL_CASE = 'PASCAL_CASE';

/// A key representing path case.
const PATH_CASE = 'PATH_CASE';

/// A key representing upper dot case.
const UPPER_DOT_CASE = 'UPPER_DOT_CASE';

/// A key representing upper kebab case.
const UPPER_KEBAB_CASE = 'UPPER_KEBAB_CASE';

/// A key representing upper snake case.
const UPPER_SNAKE_CASE = 'UPPER_SNAKE_CASE';

const _UNCHANGED = UNCHANGED;
const _CAMEL_CASE = CAMEL_CASE;
const _LOWER_DOT_CASE = LOWER_DOT_CASE;
const _LOWER_KEBAB_CASE = LOWER_KEBAB_CASE;
const _LOWER_SNAKE_CASE = LOWER_SNAKE_CASE;
const _PASCAL_CASE = PASCAL_CASE;
const _PATH_CASE = PATH_CASE;
const _UPPER_DOT_CASE = UPPER_DOT_CASE;
const _UPPER_KEBAB_CASE = UPPER_KEBAB_CASE;
const _CAPITALIZED_KEBAB_CASE = CAPITALIZED_KEBAB_CASE;
const _UPPER_SNAKE_CASE = UPPER_SNAKE_CASE;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Converts a string to a specific case type.
String convertToStringCaseType(String value, StringCaseType? stringCaseType) {
  switch (stringCaseType) {
    case StringCaseType.UNCHANGED:
      return value; // No conversion needed, return the original value.
    case StringCaseType.LOWER_SNAKE_CASE:
      return value.toLowerSnakeCase();
    case StringCaseType.UPPER_SNAKE_CASE:
      return value.toUpperSnakeCase();
    case StringCaseType.LOWER_KEBAB_CASE:
      return value.toLowerKebabCase();
    case StringCaseType.UPPER_KEBAB_CASE:
      return value.toUpperKebabCase();
    case StringCaseType.CAPITALIZED_KEBAB_CASE:
      return value.toCapitalizedKebabCase();
    case StringCaseType.CAMEL_CASE:
      return value.toCamelCase();
    case StringCaseType.PASCAL_CASE:
      return value.toPascalCase();
    case StringCaseType.LOWER_DOT_CASE:
      return value.toLowerDotCase();
    case StringCaseType.UPPER_DOT_CASE:
      return value.toUpperDotCase();
    case StringCaseType.PATH_CASE:
      return value.toPathCase();
    default:
      return value;
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

extension ConvertOnStringCaseTypeExtension on StringCaseType {
  /// Converts [value] to a specific case type.
  String convert(String value) {
    return convertToStringCaseType(value, this);
  }

  /// Converts [values] to a specific case type.
  Iterable<String> convertAll(Iterable<String> values) {
    return values.map((e) => convert(e));
  }
}
