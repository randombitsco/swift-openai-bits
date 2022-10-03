import Foundation

fileprivate let ATTACHMENT_FILENAME: Pattern = #"attachment; filename="(.*)""#

/// Represents an HTTP response that returns binary data, typically a file.
public struct BinaryResponse {
  /// The filename, if available.
  public let filename: String?
  
  /// The binary data.
  public let data: Data
}

extension BinaryResponse: HTTPResponse {
  
  /// Initialises the response with the returned `Foundation.Data` and `Foundation.HTTPURLResponse`.
  ///
  /// - Parameter data: The `Data` from the response.
  /// - Parameter response: The `HTTPURLResponse`.
  public init(data: Data, response: HTTPURLResponse) {
    self.data = data
    
    if let contentDisposition = response.value(forHTTPHeaderField: "Content-Disposition") {
      let result = ATTACHMENT_FILENAME.matchGroups(in: contentDisposition)
      let filename = result?[1]
      self.filename = filename != nil ? String(filename!) : nil
    } else {
      self.filename = nil
    }
  }
}
