import Foundation
import MultipartForm

public enum Files {}

extension Files {
  
  /// Retrieves a list of all uploaded files.
  public struct List: GetCall {
    public struct Response: JSONResponse, Equatable {
      public let data: [File]
    }
    
    public var path: String { "files" }
    
    public init() {}
  }
  
  /// Uploads the provided `file` with a nominated ``Files/Purpose``.
  public struct Upload: MultipartPostCall {
    /// The purpose of the file
    public enum Purpose: String, Equatable, Codable {
      case fineTune = "fine-tune"
      case answers
      case search
      case classifications
    }
    
    public typealias Response = File
    
    public var path: String { "files" }
    
    public let boundary: String = UUID().uuidString
    
    public let purpose: Purpose
    
    public let file: URL
    
    public init(purpose: Purpose, file: URL) {
      self.purpose = purpose
      self.file = file
    }
    
    public func getForm() throws -> MultipartForm {
      let data = try Data(contentsOf: file)

      return MultipartForm(
        parts: [
          .init(name: "purpose", value: purpose.rawValue),
          .init(name: "file", data: data, filename: file.lastPathComponent),
        ],
        boundary: boundary
      )
    }
  }
  
  /// Attempts to delete the nominated file, if one exists with the provided ``File/ID``.
  public struct Delete: DeleteCall {
    /// The `Response` to the ``Delete`` call.
    public struct Response: JSONResponse {
      /// The ``File/ID`` that was attempted to be deleted.
      public let id: File.ID
      
      /// Indicates if the file was successfully deleted.
      public let deleted: Bool
      
      /// Initializes the ``Files//Delete`` call.
      ///
      /// - Parameter id: The ``File/ID`` to delete.
      /// - Parameter deleted: Indicates if the delete was successful.
      public init(id: File.ID, deleted: Bool) {
        self.id = id
        self.deleted = deleted
      }
    }
    
    /// The path to the file deletion URL.
    public var path: String { "files/\(id)" }
    
    /// The ``File/ID``.
    public let id: File.ID
    
    /// Creates a new `Delete File` call, providing the ``File/ID`` to delete.
    ///
    /// - Parameter id: The ``File/ID``.
    public init(id: File.ID) {
      self.id = id
    }
  }
  
  /// Retrieves file information for the specified ``File/ID``.
  public struct Details: GetCall {
    public typealias Response = File
    
    public var path: String { "files/\(id)" }
    
    public let id: File.ID
    
    public init(id: File.ID) {
      self.id = id
    }
  }
  
  public struct Content: GetCall {
    public typealias Response = BinaryResponse
    
    public var path: String { "files/\(id)/content" }
    
    public let id: File.ID
    
    public init(id: File.ID) {
      self.id = id
    }
  }
}
