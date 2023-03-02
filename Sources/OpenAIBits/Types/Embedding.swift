import Foundation

/// Represents an embedding, a vector representation of a given input that can be easily consumed by machine learning models and algorithms. Created via ``Embeddings/Create``.
///
/// ## Related Calls
///
///- ``Embeddings/Create``
///
/// ## See Also
///
/// - [OpenAI API](https://platform.openai.com/docs/api-reference/embeddings)
/// - [Embeddings Guide](https://platform.openai.com/docs/guides/embeddings)
public struct Embedding: Equatable, Codable {
  /// The embedding digits.
  public let embedding: [Decimal]
  
  /// The index of the embedding result (`0`-based).
  public let index: Int
  
  /// Creates an embedding.
  /// - Parameters:
  ///   - embedding: The embedding vector values.
  ///   - index: The index of the result.
  public init(embedding: [Decimal], index: Int) {
    self.embedding = embedding
    self.index = index
  }
}
