import Foundation

public protocol HTTPResponse: Equatable {
  init(data: Data, response: HTTPURLResponse) throws
}
