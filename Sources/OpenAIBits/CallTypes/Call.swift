import Foundation

public protocol Call: Equatable {
  /// The response data type.
  associatedtype Response: Equatable
}
