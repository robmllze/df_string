# Changelog

## [0.4.0]

- Released @ 8/2026 (UTC)
- fix: case conversions (`toSnakeCase`, `toKebabCase`, `toDotCase`, `toCamelCase`, `toPascalCase`, `toPathCase`, and their variants) no longer split at letter↔digit boundaries — digits now stay attached to the letter run they touch, matching the Rails `underscore` convention. `phoneE164` → `phone_e164` (was `phone_e_164`), `line1` → `line1` (was `line_1`), `version1` → `version1` (was `version_1`). A digit immediately before an uppercase letter is still a word boundary (`foo1Bar` → `foo1_bar`), so camel/snake round-trips stay stable. This keeps generated wire keys aligned with database columns that embed digits. **Behavioural change:** consumers that relied on the old digit-splitting output will see different results.

## [0.3.0]

- Released @ 5/2026 (UTC)
- fix: `truncToLength` now appends `ellipsis` only when truncation actually occurs, returns short inputs unchanged, preserves leading whitespace (only trailing whitespace exposed by the cut is trimmed), and throws `RangeError` on negative `length`
- fix: `forceObjToString` is guaranteed not to throw even when both `toString` and `hashCode` misbehave; falls back to `'<unrepresentable object>'` in that case

## [0.2.10]

- Released @ 12/2025 (UTC)
- Add an UNCHANGED StringCaseType

## [0.2.9]

- Released @ 6/2025 (UTC)
- Update dependencies

## [0.2.8]

- Released @ 6/2025 (UTC)
- Update dependencies

## [0.2.7]

- Released @ 6/2025 (UTC)
- Refactor and clean

## [0.2.6]

- Released @ 6/2025 (UTC)
- Update dependencies

## [0.2.5]

- Released @ 6/2025 (UTC)
- Make string type conversions more robust

## [0.2.4]

- Released @ 12/2024 (UTC)
- refactor: Improve code structure

## [0.2.3]

- Released @ 12/2024 (UTC)
- chore: Update CI/CD script

## [0.2.2]

- Released @ 12/2024 (UTC)
- docs: Update readme and comments

## [0.2.1]

- Released @ 12/2024 (UTC)
- chore: Update topics in pubspec.yaml, docs and comments

## [0.2.0]

- Released @ 12/2024 (UTC)
- chore: Update docs and format code

## [0.1.2]

- Released @ 12/2024 (UTC)
- feat: Add extension NullIfEmptyOnStringX

## [0.1.1]

- Released @ 12/2024 (UTC)
- chore: Update workflow scripts

## [0.1.0]

- Released @ 12/2024 (UTC)
- Initial commit
