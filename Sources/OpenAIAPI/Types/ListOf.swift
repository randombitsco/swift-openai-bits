import Foundation

public struct ListOf<Element: Decodable>: JSONResponse {
  public let data: [Element]
  public let usage: Usage?

  public init(data: [Element], usage: Usage? = nil) {
    self.data = data
    self.usage = usage
  }
}

extension ListOf: Equatable where Element: Equatable {}
