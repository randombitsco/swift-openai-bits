import Foundation

protocol HTTPResponse: Equatable {
  init(data: Data, response: HTTPURLResponse) throws
}
