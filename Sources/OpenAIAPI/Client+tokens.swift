extension Client {
  /// Returns an estimate for the set of tokens for the provided `text` will result in.
  ///
  /// - Parameters:
  ///   - text: The ``String`` value to tokenize.
  ///   - model: The model to use. Defaults to ``TokenEncoder/Model/gpt3``.
  /// - Returns the list of tokens as ``Int`` values.
  /// - Throws an error if there is an issue loading the encoding resources.
  public func tokens(for text: String, model: TokenEncoder.Model = .gpt3) throws -> [Int] {
    let encoder = try TokenEncoder(model: model)
    return try encoder.encode(text: text)
  }
  
  /// Returns an estimate of the number of tokens the provided `text` will be parsed as.
  ///
  /// - Parameters:
  ///   - text: The ``String`` value to tokenize.
  ///   - model: The model to use. Defaults to ``TokenEncoder/Model/gpt3``.
  /// - Returns the number of tokens estimated.
  /// - Throws an error if there is an issue loading the encoding resources.
  public func tokenCount(for text: String, model: TokenEncoder.Model = .gpt3) throws -> Int {
    return try tokens(for: text).count
  }
}
