import Foundation
import MultipartForm

/// Files are used to upload documents that can be used with features like ``FineTunes``.
///
/// ## Calls
///
/// - ``Files/List`` - Lists available ``File``s.
/// - ``Files/Upload`` - Uploads a new ``File`` with a specific ``Files/Upload/Purpose-swift.enum``.
/// - ``Files/Delete`` - Deletes a specific ``File``.
/// - ``Files/Detail`` - Retrieves details of a specific ``File``.
/// - ``Files/Content`` - Downloads the content of a ``File``.
///
/// ## See Also
///
/// - [OpenAI API](https://beta.openai.com/docs/api-reference/files)
public enum Files {}

// MARK: List

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

// MARK: Upload

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
    
    /// Responds with a ``File``.
    public typealias Response = File
    
    /// The path.
    var path: String { "files" }
    
    /// The Multipart boundary marker.
    let boundary: String = UUID().uuidString

    /// Name of the [JSON Lines](https://jsonlines.readthedocs.io/en/latest/) file to be uploaded.
    ///
    /// If the purpose is set to `.fineTune`, each line is a JSON record with "prompt" and "completion" fields representing your [training examples](https://beta.openai.com/docs/guides/fine-tuning/prepare-training-data).
    public let filename: String
    
    /// The intended purpose of the uploaded documents.
    ///
    /// Use `.fineTune` for [Fine-tuning](https://beta.openai.com/docs/api-reference/fine-tunes).
    /// This allows OpenAI to validate the format of the uploaded file.
    public let purpose: Purpose
    
    /// The file `Data`.
    public let data: Data
    
    /// Create a new upload call.
    ///
    /// - Parameter filename: The filename.
    /// - Parameter purpose: The ``Files/Upload/Purpose-swift.enum`` of the upload.
    /// - Parameter data: The `Data` to the file to upload.
    public init(
      filename: String,
      purpose: Purpose,
      data: Data
    ) {
      self.filename = filename
      self.purpose = purpose
      self.data = data
    }
    
    /// Create a new upload call from a `URL`.
    /// - Parameters:
    ///   - filename: The filename. Uses the `URL`s `lastPathComponent` if not provided.
    ///   - purpose: The ``purpose-swift.property``.
    ///   - url: The `URL` to load the file from.
    public init(
      filename: String? = nil,
      purpose: Purpose,
      url: URL
    ) throws {
      self.filename = filename ?? url.lastPathComponent
      self.purpose = purpose
      self.data = try Data(contentsOf: url)
    }
    
    /// Create a new upload call.
    ///
    /// - Parameter file: The filename. If not specified, it uses the
    
    /// Returns a `MultipartForm` based on the purpose and file.
    ///
    /// - Returns the form.
    /// - Throws an error if unable to load the file.
    public func getForm() throws -> MultipartForm {
      return MultipartForm(
        parts: [
          .init(name: "purpose", value: purpose.rawValue),
          .init(name: "file", data: data, filename: filename),
        ],
        boundary: boundary
      )
    }
  }
}

// MARK: Delete

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

// MARK: Detail

extension Files { 
  /// Returns information about a specific file ``File/ID-swift.struct``.
  ///
  /// ## See Also
  ///
  /// - [OpenAI API](https://beta.openai.com/docs/api-reference/files/retrieve)
  public struct Detail: GetCall {
    public typealias Response = File
    
    var path: String { "files/\(id)" }
    
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

// MARK: Content

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
