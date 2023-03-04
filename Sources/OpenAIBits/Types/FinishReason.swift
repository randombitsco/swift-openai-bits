// MARK: Completion.FinishReason

/// The reason that the result ``Completion/Choice`` finished.
public enum FinishReason: RawRepresentable, Equatable, Codable, CustomStringConvertible {
  /// It finished due to hitting the token maximum.
  case length
  /// The model has no further predictions given the input.
  case stop
  /// Some other result.
  case other(String)

  /// The raw value, as a `String`.
  public var rawValue: String {
    switch self {
    case .length: return "length"
    case .stop: return "stop"
    case .other(let value): return value
    }
  }

  /// Initialize given a raw `String` value.
  /// - Parameter rawValue: The value.
  public init(rawValue: String) {
    switch rawValue {
    case "length": self = .length
    case "stop": self = .stop
    default: self = .other(rawValue)
    }
  }

  /// The `String` value.
  public var description: String { rawValue }
}
