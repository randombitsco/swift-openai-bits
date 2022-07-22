import Foundation

/// Represents an `Edits` request.
public struct Edits: PostCall {
  
  public var path: String { "edits" }
  
  public let model: Model.ID
  public let input: String?
  public let instruction: String
  public let n: Int?
  public let temperature: Percentage?
  public let topP: Percentage?

  public init(
    model: Model.ID,
    input: String? = nil,
    instruction: String,
    n: Int? = nil,
    temperature: Percentage? = nil,
    topP: Percentage? = nil
  ) {
    self.model = model
    self.input = input
    self.instruction = instruction
    self.n = n
    self.temperature = temperature
    self.topP = topP
  }
}

extension Edits {
  public struct Response: Equatable, Codable {
    public let created: Date
    public let choices: [Choice]
    public let usage: Usage

    public init(created: Date, choices: [Choice], usage: Usage) {
      self.created = created
      self.choices = choices
      self.usage = usage
    }
  }

  public struct Choice: Equatable, Codable {
    public let text: String
    public let index: Int

    public init(text: String, index: Int) {
      self.text = text
      self.index = index
    }
  }
}
