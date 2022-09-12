import Foundation

public struct File: Equatable, Codable {
  
  public struct ID: Identifier {
    public let value: String
    
    public init(_ value: String) {
      self.value = value
    }
  }
  
  public let id: ID
  public let bytes: Int64
  public let createdAt: Date
  public let filename: String
  public let purpose: String
}
