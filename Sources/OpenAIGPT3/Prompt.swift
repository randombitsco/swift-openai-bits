import Foundation

/// A ``Prompt`` can be a single ``String``, an array of ``String``s, a ``Token`` array, or an array of ``Token`` arrays.
/// You can also assign it directly with ``String`` literal value, which will result in a ``Prompt/string(_:)`` value.
public enum Prompt: Equatable {
  case string(String)
  case strings([String])
  // TODO: Figure out tokens.
//  case tokenArray([Token])
//  case tokenArrays([[Token]])
}

extension Prompt: ExpressibleByStringLiteral, ExpressibleByStringInterpolation {
  /// Initialises the ``Prompt`` with a ``String`` literal value.
  public init(stringLiteral value: String) {
    self = .string(value)
  }
}

extension Prompt: Codable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    do {
      self = .string(try container.decode(String.self))
      return
    } catch {}
    
    self = .strings(try container.decode([String].self))
  }
  
  public func encode(to encoder: Encoder) throws {
    switch self {
    case .string(let value):
      var container = encoder.singleValueContainer()
      try container.encode(value)
    case .strings(let values):
      var container = encoder.singleValueContainer()
      try container.encode(values)
    }
  }
}
