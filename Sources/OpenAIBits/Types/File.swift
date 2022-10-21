import Foundation

/// Represents a file that has been uploaded to OpenAI. Created via the ``Files/Upload`` and retrieved by ``Files/Detail``.
///
/// ## See Also
///
/// - [OpenAI API](https://beta.openai.com/docs/api-reference/files)
public struct File: Identified, JSONResponse, Equatable {
  /// A ``File`` `ID`.
  public struct ID: Identifier {
    /// The value.
    public let value: String
    
    /// Creates an `ID` with the specified value.
    ///
    /// - Parameter value: The value.
    public init(_ value: String) {
      self.value = value
    }
  }
  
  /// The ``File/ID-swift.struct`` of the file.
  public let id: ID
  
  /// The number of bytes in the file.
  public let bytes: Int64
  
  /// The date it was created at.
  public let createdAt: Date
  
  /// The filename.
  public let filename: String
  
  /// The purpose of the file.
  public let purpose: String
  
  /// The status of the file.
  public let status: String?
  
  /// The details of the file status.
  public let statusDetails: String?
}
