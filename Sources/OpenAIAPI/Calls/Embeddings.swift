/// Creates an embedding vector representing the input text.
public struct Embeddings: JSONPostCall {
  public var path: { "embeddings" }

  public typealias Response = ListOf<Embedding>

  public let id: Model.ID

  public let input: Prompt

  public let user: String?

  public init(id: Model.ID, input: Prompt, user: String? = nil) {
    self.id = id
    self.input = input
    self.user = user
  }
}
