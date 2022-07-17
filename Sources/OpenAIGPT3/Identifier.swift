// Represents a value that is an ID.

import Foundation

/// Describes a value intended to be a single ``String`` that is ``Codable`` and can be created via a hard-coded ``String``
public protocol Identifier: Hashable, Codable, ExpressibleByStringLiteral, CustomStringConvertible {
  var value: String { get }
  
  init(value: String)
}

extension Identifier {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    try self.init(value: container.decode(String.self))
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
  
  public init(stringLiteral value: StaticString) {
    self.init(value: String(describing: value))
  }
  
  public var description: String { value }
}
