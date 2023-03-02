// MARK: Stop

/// Represents 1 to 4 "stop" `String` values for a ``Text/Completions`` call.
public struct Stop: Equatable, Encodable {
  /// The "stop" values.
  public let value: [String]

  /// A single stop value.
  ///
  /// - Parameter v1: The only `String`.
  public init(_ v1: String) {
    self.value = [v1]
  }

  /// Two stop values.
  ///
  /// - Parameters:
  ///   - v1: The first `String`.
  ///   - v2: The second `String`.
  public init(_ v1: String, _ v2: String) {
    self.value = [v1, v2]
  }

  /// Three stop values.
  ///
  /// - Parameters:
  ///   - v1: The first `String`.
  ///   - v2: The second `String`.
  ///   - v3: The third `String`.
  public init(_ v1: String, _ v2: String, _ v3: String) {
    self.value = [v1, v2, v3]
  }

  /// Four stop values.
  ///
  /// - Parameters:
  ///   - v1: The first `String`.
  ///   - v2: The second `String`.
  ///   - v3: The third `String`.
  ///   - v4: The fourth `String`.
  public init(_ v1: String, _ v2: String, _ v3: String, _ v4: String) {
    self.value = [v1, v2, v3, v4]
  }

  /// Encodes the this as a `String` array.
  /// - Parameter encoder: The encoder.
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}

extension Stop: ExpressibleByStringLiteral {
  /// Creates a single `Stop` from a single `String` literal.
  /// - Parameter value: The `String` literal.
  public init(stringLiteral value: String) {
    self.init(value)
  }
}
