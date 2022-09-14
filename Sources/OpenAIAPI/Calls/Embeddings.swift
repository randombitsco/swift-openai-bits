public enum Embeddings {}

extension Embeddings {
  /// Represents a request for embeddings on a model.
  public struct Request: Equatable, Codable {
    
    public let model: Model.ID
    public let input: Prompt
    public let user: String?
    
    public init(model: Model.ID, input: Prompt, user: String? = nil) {
      self.model = model
      self.input = input
      self.user = user
    }
  }
  
  public struct Response: JSONResponse, Equatable {
    public let data: [Embedding]
    public let usage: Usage
    
    public init(data: [Embedding], usage: Usage) {
      self.data = data
      self.usage = usage
    }
  }

  public struct Embedding: Equatable, Codable {
    public let embedding: [Double]
    public let index: Int
    
    public init(embedding: [Double], index: Int) {
      self.embedding = embedding
      self.index = index
    }
  }
}
