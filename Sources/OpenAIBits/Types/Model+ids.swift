
// MARK: Common Model IDs.

extension Model.ID {
  /// Most capable GPT-3 model. Can do any task the other models can do, often with less context. In addition to responding to ``Completions``, also supports [inserting](https://beta.openai.com/docs/guides/completion/inserting-text) completions within text.
  ///
  /// - Max Tokens: 4,000
  /// - Training Data: Up to Jun 2021
  public static var text_davinci_003: Self { "text-davinci-003" }

  /// Previous generation of `Davinci`. Can do any task the other models can do, often with less context. In addition to responding to ``Completions``, also supports [inserting](https://beta.openai.com/docs/guides/completion/inserting-text) completions within text.
  ///
  /// - Max Tokens: 4,000
  /// - Training Data: Up to Jun 2021
  @available(*, deprecated, message: "Use text_davinci_003 instead.", renamed: "text_davinci_003")
  public static var text_davinci_002: Self { "text-davinci-002" }
  
  /// Very capable, but faster and lower cost than `Davinci`.
  ///
  /// - Max Tokens: 2,048
  /// - Training Data: Up to Oct 2019
  public static var text_curie_001: Self { "text-curie-001" }
  
  /// Capable of straightforward tasks, very fast, and lower cost.
  ///
  /// - Max Tokens: 2,048
  /// - Training Data: Up to Oct 2019
  public static var text_babbage_001: Self { "text-babbage-001" }
  
  /// Capable of very simple tasks, usually the fastest model in the GPT-3 series, and lowest cost.
  ///
  /// - Max Tokens: 2,048
  /// - Training Data: Up to Oct 2019
  public static var text_ada_001: Self { "text-ada-001" }
  
  /// A variation of the `Davinci` model for use with ``Edits``.
  public static var text_davinci_edit_001: Self { "text-davinci-edit-001" }
  
  /// A code-focused variation of the `Davinci` model for use with ``Edits``.
  public static var code_davinci_edit_001: Self { "code-davinci-edit-001" }
  
  /// Most capable Codex model. Particularly good at translating natural language to code. In addition to completing code, also supports inserting completions within code.
  ///
  /// - Max Tokens: 8,000
  /// - Training Data: Up to Jun 2021
  ///
  /// - Note: Currently in Private beta.
  public static var code_davinci_001: Self {  "code-davinci-001" }
  
  /// Almost as capable as Davinci Codex, but slightly faster. This speed advantage may make it preferable for real-time applications.
  ///
  /// - Max Tokens: 2,048
  /// - Training Data: Unknown
  ///
  /// - Note: Currently in Private beta.
  public static var code_cushman_001: Self { "code-cushman-001" }
}
