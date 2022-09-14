import Foundation

public struct ListOf<Element: Decodable>: JSONResponse {
  public let data: [Element]
}

extension ListOf: Equatable where Element: Equatable {}
