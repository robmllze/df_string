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

/// Converts an object to a string, returning a fallback representation if
/// the object's `toString()` method throws.
///
/// This is a defensive utility, primarily for logging and debugging, to keep
/// a misbehaving object from crashing the application. It is guaranteed to
/// never throw — even if `toString`, `runtimeType`, and `hashCode` all
/// misbehave — and is safe to call from logging code on the critical path.
///
/// For `null`, returns the literal `'null'` (Dart's default `Object?.toString`
/// behaviour for null).
///
/// The fallback when `toString` throws is `'<RuntimeType>@<hex-hashcode>'`.
/// If even that path throws, the final fallback is the literal string
/// `'<unrepresentable object>'`.
String forceObjToString(Object? obj) {
  try {
    return obj.toString();
  } catch (_) {
    try {
      return '${obj.runtimeType}@${obj.hashCode.toRadixString(16)}';
    } catch (_) {
      return '<unrepresentable object>';
    }
  }
}

/// An extension method for conveniently calling [forceObjToString].
extension ForceObjToStringOnObjectExt on Object {
  /// Safely converts this object to a string. See [forceObjToString].
  String forceObjToString() => _forceObjToString(this);
}

// A private alias used by the extension method.
final _forceObjToString = forceObjToString;
