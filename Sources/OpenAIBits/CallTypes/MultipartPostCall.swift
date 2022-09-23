import Foundation
import MultipartForm

/// Represents a `POST` HTTP request that submits as a Multi-Part Form.
protocol MultipartPostCall: PostCall {
  var boundary: String { get }
  
  /// The ``MultipartForm`` to post.
  func getForm() throws -> MultipartForm
}

extension MultipartPostCall {
  var contentType: String? {
    return "multipart/form-data; boundary=\(self.boundary)"
  }
  
  func getBody() throws -> Data? {
    try getForm().bodyData
  }
}
