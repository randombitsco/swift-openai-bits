import Foundation
import MultipartForm

/// Represents a `POST` HTTP request that submits as a Multi-Part Form.
public protocol MultipartPostCall: PostCall {
  var boundary: String { get }
  
  /// The ``MultipartForm`` to post.
  func getForm() throws -> MultipartForm
}

public extension MultipartPostCall {
  var contentType: String? {
    return "multipart/form-data; boundary=\(self.boundary)"
  }
  
  func getBody() throws -> Data? {
    try getForm().bodyData
  }
}
