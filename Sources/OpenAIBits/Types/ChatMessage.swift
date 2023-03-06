/// Represents a chat message.
public struct ChatMessage: Equatable, Codable {
  /// The role of the message.
  public let role: Role

  /// The content of the message.
  public let content: String

  /// Creates a ``ChatMessage``.
  ///
  /// - Parameters:
  ///   - role: The role of the message.
  ///   - content: The content of the message.
  public init(role: Role, content: String) {
    self.role = role
    self.content = content
  }
}

extension ChatMessage {
  /// The role of a ``ChatMessage``.
  public enum Role: String, Equatable, Codable, CustomStringConvertible {
    /// Sets up the context for the conversation.
    case system

    /// The message is from the assistant.
    case assistant

    /// The message is from the user.
    case user
    
    public var description: String { rawValue }
  }
}

// MARK: Array of ChatMessage

public extension Array where Element == ChatMessage {
  /// Creates a new array of ``ChatMessage``s with a single ``ChatMessage/Role/system`` role message.
  ///
  /// - Parameter content: The message to add.
  /// - Returns: A new array of ``ChatMessage``s with a single ``ChatMessage/Role/system`` role message.  
  static func from(system content: String) -> [ChatMessage] {
    [.init(role: .system, content: content)]
  }

  /// Creates a new array of ``ChatMessage``s with a single `assistant` role message.
  ///
  /// - Parameter message: The message to add.
  /// - Returns: A new array of ``ChatMessage``s with a single `assistant` role message.
  static func from(assistant message: String) -> [ChatMessage] {
    [.init(role: .assistant, content: message)]
  }

  /// Creates a new array of ``ChatMessage``s with a single `user` role message.
  ///
  /// - Parameter message: The message to add.
  /// - Returns: A new array of ``ChatMessage``s with a single `user` role message.
  static func from(user message: String) -> [ChatMessage] {
    [.init(role: .user, content: message)]
  }

  /// Adds a new ``ChatMessage/Role/system`` role message to the returned array.
  ///
  /// - Parameter content: The message to add.
  /// - Returns: A new array of ``ChatMessage``s with a single ``ChatMessage/Role/system`` role message.
  func from(system content: String) -> [ChatMessage] {
    var messages = self
    messages.append(.init(role: .system, content: content))
    return messages
  }

  /// Adds a new `assistant` role message to the returned array.
  ///
  /// - Parameter message: The message to add.
  /// - Returns: A new array of ``ChatMessage``s with a single `assistant` role message.
  func from(assistant message: String) -> [ChatMessage] {
    var messages = self
    messages.append(.init(role: .assistant, content: message))
    return messages
  }

  /// Adds a new `user` role message to the returned array.
  ///
  /// - Parameter message: The message to add.
  /// - Returns: A new array of ``ChatMessage``s with a single `user` role message.
  func from(user message: String) -> [ChatMessage] {
    var messages = self
    messages.append(.init(role: .user, content: message))
    return messages
  }
}
