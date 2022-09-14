import Foundation

public protocol JSONPostCall: PostCall, Encodable {}

extension JSONPostCall {
  public var contentType: String { "application/json" }
  
  public func getBody() throws -> Data {
    try jsonEncodeData(self)
  }
}
