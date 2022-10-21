import Foundation
import MultipartForm

/// Represents a `POST` HTTP request that submits as a Multi-Part Form.
protocol MultipartPostCall: PostCall {
  /// The MIME boundary for a `multipart/form-data` call.
  var boundary: String { get }
  
  /// The ``MultipartForm`` to post.
  func getForm() throws -> MultipartForm
}

extension MultipartPostCall {
  /// The `"Content-Type"` header for the call.
  var contentType: String? {
    return "multipart/form-data; boundary=\(self.boundary)"
  }
  
  /// Retrieves the body `Data` from the form, if available.
  func getBody() throws -> Data? {
    try getForm().bodyData
  }
}
