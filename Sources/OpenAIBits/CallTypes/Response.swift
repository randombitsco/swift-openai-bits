import Foundation

public protocol Response {
  init(data: Data, response: HTTPURLResponse) throws
}
