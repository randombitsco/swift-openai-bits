import Foundation

public struct ListOf<Data: Codable>: Codable {
  public let data: [Data]
}

extension ListOf: Equatable where Data: Equatable {}
