/// Represents an embedding.
public struct Embedding: Equatable, Codable {
  public let embedding: [Double]
  public let index: Int

  public init(embedding: [Double], index: Int) {
    self.embedding = embedding
    self.index = index
  }
}
