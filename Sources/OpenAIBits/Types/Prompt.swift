import Foundation

/// A ``Prompt`` can be a single ``String``, an array of ``String``s, a ``Token`` array, or an array of ``Token`` arrays.
/// You can also assign it directly with ``String`` literal value, which will result in a ``Prompt/string(_:)`` value.
public enum Prompt: Equatable {
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

extension Prompt: Codable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    do {
      self = .string(try container.decode(String.self))
      return
    } catch {}
    
    do {
      self = .strings(try container.decode([String].self))
      return
    } catch {}
    
    do {
      self = .tokenArray(try container.decode([Token].self))
      return
    } catch {}
    
    self = .tokenArrays(try container.decode([[Token]].self))
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .string(let value):
      try container.encode(value)
    case .strings(let values):
      try container.encode(values)
    case .tokenArray(let tokens):
      try container.encode(tokens)
    case .tokenArrays(let tokens):
      try container.encode(tokens)
    }
  }
}
