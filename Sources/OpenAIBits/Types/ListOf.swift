import Foundation

/// Represents a list of `Element` values.
public struct ListOf<Element>: JSONResponse where Element: Codable, Element: Equatable {
  public let data: [Element]
  public let usage: Usage?

  public init(data: [Element], usage: Usage? = nil) {
    self.data = data
    self.usage = usage
  }
}

// MARK: Equatable

extension ListOf: Equatable where Element: Equatable {}

// MARK: Sequence

extension ListOf: Sequence {
  public typealias Iterator = AnyIterator<Element>
  
  public func makeIterator() -> Iterator {
    var iterator = data.makeIterator()
    
    return AnyIterator {
      iterator.next()
    }
  }
}

// MARK: Collection

extension ListOf: Collection {
  public typealias Index = Int
  
  public var startIndex: Int {
    data.startIndex
  }
  
  public var endIndex: Int {
    data.endIndex
  }
  
  public subscript(position: Int) -> Element {
    data[position]
  }
  
  public func index(after i: Int) -> Int {
    data.index(after: i)
  }
}
