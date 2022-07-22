import Foundation

public enum Files {}

extension Files {
  public struct List: GetCall {
    public var path: String { "files" }
    
    public struct Response: Equatable, Codable {
      public let data: [File]
    }
  }
  
  public struct Upload {
    public struct Request: Equatable, Codable {
      public let file: String
      public let purpose: String
    }
    
    public typealias Response = File
  }
}
