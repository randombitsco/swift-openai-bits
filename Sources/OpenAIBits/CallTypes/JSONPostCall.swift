import Foundation

protocol JSONPostCall: PostCall, Encodable {}

extension JSONPostCall {
  var contentType: String? { "application/json" }
  
  func getBody() throws -> Data? {
    try jsonEncodeData(self)
  }
}
