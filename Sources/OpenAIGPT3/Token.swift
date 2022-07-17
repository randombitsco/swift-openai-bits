// A single token

public struct Token: Equatable, Hashable {
  public let value: String
  
  public init(_ value: String) {
    self.value = value
  }
}

extension Token: Codable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    try self.init(container.decode(String.self))
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}
