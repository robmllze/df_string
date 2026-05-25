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

extension StringExt1 on String {
  /// Returns null if the String is empty, otherwise returns the String.
  String? get nullIfEmpty {
    return isEmpty ? null : this;
  }

  /// Truncates the string to the given [length], trimming trailing whitespace
  /// that may be exposed by the cut, and appending [ellipsis] if and only if
  /// the string was actually truncated.
  ///
  /// - Returns the original string unchanged when its length is `<= length`.
  /// - When truncated, the returned core (before [ellipsis]) is at most
  ///   [length] characters; [ellipsis] is appended on top of that budget.
  /// - [length] must be `>= 0`. Negative values throw [RangeError].
  ///
  /// Examples:
  /// ```dart
  /// 'Hello World'.truncToLength(5, ellipsis: '...'); // 'Hello...'
  /// 'Hello World'.truncToLength(6, ellipsis: '...'); // 'Hello...' (trailing space trimmed)
  /// 'Hello'.truncToLength(10, ellipsis: '...');      // 'Hello' (no truncation)
  /// ''.truncToLength(5, ellipsis: '...');            // '' (no truncation)
  /// ```
  String truncToLength(int length, {String ellipsis = ''}) {
    if (length < 0) {
      throw RangeError.range(length, 0, null, 'length');
    }
    if (this.length <= length) return this;
    return substring(0, length).trimRight() + ellipsis;
  }

  /// Replaces all whitespace characters with [replace].
  String withNormalizedWhitespace([String replace = ' ']) {
    return replaceAll(RegExp(r'[\s]+'), replace);
  }

  /// Replaces the last occurrence of [from] with [replace] starting at
  /// [startIndex].
  ///
  /// See: [replaceFirst].
  String replaceLast(Pattern from, String replace, [int startIndex = 0]) {
    final match = from.allMatches(this, startIndex).lastOrNull;
    if (match == null) return this;
    final lastIndex = match.start;
    final beforeLast = substring(0, lastIndex);
    final group0 = match.group(0);
    if (group0 == null) return this;
    final afterLast = substring(lastIndex + group0.length);
    return beforeLast + replace + afterLast;
  }

  // Splits the string by the last occurrence of [separator].
  List<String> splitByLastOccurrenceOf(String separator) {
    final splitIndex = lastIndexOf(separator);
    if (splitIndex == -1) {
      return [this];
    }
    return [substring(0, splitIndex), substring(splitIndex + separator.length)];
  }
}
