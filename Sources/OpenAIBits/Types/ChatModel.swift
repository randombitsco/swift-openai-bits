import Foundation

/// The ID of the GPT 3.5 chat model.
public enum ChatModel: RawRepresentable, Equatable, Codable {
  /// The latest turbo model. Will be updated over time to improve performance.
  case gpt_3_5_turbo

  /// A snapshot of the default model at a specific point in time. For example, `gpt-3.5-turbo-0301`. was the initial snapshot, which will be supported up to at least 1st of June, 2023.
  case gpt_3_5_snapshot(String)

  public var rawValue: String {
    switch self {
    case .gpt_3_5_turbo: return "gpt-3.5-turbo"
    case .gpt_3_5_snapshot(let snapshot): return "gpt-3.5-turbo-\(snapshot)"
    }
  }

  public init?(rawValue: String) {
    switch rawValue {
    case "gpt-3.5-turbo":
      self = .gpt_3_5_turbo
    case let rawValue where rawValue.hasPrefix("gpt-3.5-turbo-"):
      self = .gpt_3_5_snapshot(String(rawValue.dropFirst("gpt-3.5-turbo-".count)))
    default:
      return nil
    }
  }
}
