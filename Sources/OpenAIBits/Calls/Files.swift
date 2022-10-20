import Foundation
import MultipartForm

/// Files are used to upload documents that can be used with features like ``FineTunes``.
///
/// ## See Also
///
/// - [OpenAI API](https://beta.openai.com/docs/api-reference/files)
public enum Files {}

extension Files {
  /// Returns a list of files that belong to the user's organization.
  ///
  /// ## See Also
  ///
  /// - [OpenAI API](https://beta.openai.com/docs/api-reference/files/list)
  public struct List: GetCall {
    /// Results in a ``ListOf`` ``File``s.
    public typealias Response = ListOf<File>

    var path: String { "files" }

    /// Initializes a ``Files/List`` call.
    public init() {}
  }
}

extension Files { 
  /// Upload a file that contains document(s) to be used across various endpoints/features. 
  /// Currently, the size of all the files uploaded by one organization can be up to 1 GB. 
  /// Please contact OpenAI if you need to increase the storage limit.
  ///
  /// ## See Also
  ///
  /// - [OpenAI API](https://beta.openai.com/docs/api-reference/files/upload)
  public struct Upload: MultipartPostCall {
    /// The purpose of the file
    public enum Purpose: String, Equatable, Codable {
      case fineTune = "fine-tune"
      case answers
      case search
      case classifications
    }
    
    public typealias Response = File
    
    var path: String { "files" }
    
    /// The Multipart boundary marker.
    let boundary: String = UUID().uuidString

    /// Name of the [JSON Lines](https://jsonlines.readthedocs.io/en/latest/) file to be uploaded.
    ///
    /// If the purpose is set to `.fineTune`, each line is a JSON record with "prompt" and "completion" fields representing your [training examples](https://beta.openai.com/docs/guides/fine-tuning/prepare-training-data).
    public let file: String?
    
    /// The intended purpose of the uploaded documents.
    ///
    /// Use `.fineTune` for [Fine-tuning](https://beta.openai.com/docs/api-reference/fine-tunes).
    /// This allows OpenAI to validate the format of the uploaded file.
    public let purpose: Purpose
    
    /// The file `URL`, pointing at the file data to upload.
    public let source: URL
    
    /// Create a new upload call.
    ///
    /// - Parameter file: The filename. If not provided, the filename from the `source` is used.
    /// - Parameter purpose: The ``Files/Upload/Purpose-swift.enum`` of the upload.
    /// - Parameter source: The `URL` to the file to upload.
    public init(file: String? = nil, purpose: Purpose, source: URL) {
      self.file = file
      self.purpose = purpose
      self.source = source
    }
    
    /// Returns a ```MultipartForm`` based on the purpose and file.
    ///
    /// - Returns the form.
    /// - Throws an error if unable to load the file.
    public func getForm() throws -> MultipartForm {
      let data = try Data(contentsOf: source)

      let file = file ?? source.lastPathComponent

      return MultipartForm(
        parts: [
          .init(name: "purpose", value: purpose.rawValue),
          .init(name: "file", data: data, filename: file),
        ],
        boundary: boundary
      )
    }
  }
}

extension Files {
  /// Attempts to delete the nominated file, if one exists with the provided ``File/ID-swift.struct``.
  ///
  /// ## See Also
  ///
  /// - [OpenAI API](https://beta.openai.com/docs/api-reference/files/delete)
  public struct Delete: DeleteCall {
    /// The `Response` to the ``Files/Delete`` call.
    public struct Response: JSONResponse {
      /// The ``File/ID-swift.struct`` of the filedeleted.
      public let id: File.ID
      
      /// Indicates if the file was successfully deleted.
      public let deleted: Bool
      
      /// Initializes the ``Files/Delete`` call.
      ///
      /// - Parameter id: The `File` ``File/ID` to delete.
      /// - Parameter deleted: Indicates if the delete was successful.
      public init(id: File.ID, deleted: Bool) {
        self.id = id
        self.deleted = deleted
      }
    }
    
    /// The path to the file deletion `URL`.
    var path: String { "files/\(id)" }
    
    /// The ``File/ID-swift.struct`` of the file to use for this request.
    public let id: File.ID
    
    /// Creates a new `Delete File` call, providing the ``File`` `ID` to delete.
    ///
    /// - Parameter id: The ``File`` `ID`.
    public init(id: File.ID) {
      self.id = id
    }
  }
}

extension Files { 
  /// Returns information about a specific file ``File/ID-swift.struct``.
  ///
  /// ## See Also
  ///
  /// - [OpenAI API](https://beta.openai.com/docs/api-reference/files/retrieve)
  public struct Detail: GetCall {
    public typealias Response = File
    
    public var path: String { "files/\(id)" }
    
    /// The ``File/ID-swift.struct`` of the file to use for this request.
    public let id: File.ID
    
    /// Creates a call to request information about a specific file ``File/ID-swift.struct``.
    ///
    /// - Parameter id: The ``File/ID-swift.struct`` of the file to use for this request.
    public init(id: File.ID) {
      self.id = id
    }
  }
}

extension Files { 
  /// Returns the contents of the specified file ``File/ID-swift.struct``.
  ///
  /// ## See Also
  ///
  /// - [OpenAI API](https://beta.openai.com/docs/api-reference/files/retrieve-content)
  public struct Content: GetCall {
    /// Returns a ``BinaryResponse``.
    public typealias Response = BinaryResponse
    
    /// The path to the request.
    var path: String { "files/\(id)/content" }
    
    /// The ``File/ID-swift.struct`` of the file to use for this request.
    public let id: File.ID
    
    /// Creates a call to return the contents of the specified file ``File/ID-swift.struct``.
    ///
    /// - Parameter id: The ``File/ID-swift.struct``.
    public init(id: File.ID) {
      self.id = id
    }
  }
}
