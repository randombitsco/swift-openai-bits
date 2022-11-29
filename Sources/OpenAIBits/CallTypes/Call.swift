import Foundation

/// A common protocol for all values which represent an OpenAI client call.
/// These are passed into the ``OpenAI``.``OpenAI/call(_:)`` function to be executed,
/// returning the ``Call/Response`` when successful, or throwing an `Error` if not.
public protocol Call<Response>: Equatable {
  
  /// Every call has a `Response` type, which must be `Equitable`.
  associatedtype Response: Equatable
}
