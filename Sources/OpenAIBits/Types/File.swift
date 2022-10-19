import Foundation

public struct File: Identified, JSONResponse, Equatable {
  
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
  public let status: String?
  public let statusDetails: String?
}
