import Foundation

/// A ``Prompt`` can be a single ``String``, an array of ``String``s, a ``Token`` array, or an array of ``Token`` arrays.
/// You can also assign it directly with ``String`` literal value, which will result in a ``Prompt/string(_:)`` value.
public enum Prompt: Equatable, Codable {
  case string(String)
  case strings([String])
  case tokenArray([Token])
  case tokenArrays([[Token]])
}

extension Prompt: ExpressibleByStringLiteral, ExpressibleByStringInterpolation {
  /// Initialises the ``Prompt`` with a ``String`` literal value.
  public init(stringLiteral value: String) {
    self = .string(value)
  }
}
