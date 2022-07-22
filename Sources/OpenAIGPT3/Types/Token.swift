// A single token

public struct Token: Equatable, Hashable {
  public let value: Int64
  
  public init(_ value: Int64) {
    self.value = value
  }
}

extension Token: Codable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    try self.init(container.decode(Int64.self))
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}

extension Token: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: Int64) {
    self.init(value)
  }
}
