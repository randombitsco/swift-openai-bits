/// Creates an embedding vector representing the input text.
public struct Embeddings: JSONPostCall, Equatable {
  public var path: String { "embeddings" }

  public typealias Response = ListOf<Embedding>

  public let model: Model.ID

  public let input: Prompt

  public let user: String?

  public init(model: Model.ID, input: Prompt, user: String? = nil) {
    self.model = model
    self.input = input
    self.user = user
  }
}
