import OpenAIAPI

struct Format {
  static let `default` = Format(indent: "")
  
  static func indent(by count: Int) -> Format {
    Format(indent: String(repeating: " ", count: count))
  }
  
  static func verbose() -> Format {
    Format(showVerbose: true)
  }
  
  let indent: String
  let showVerbose: Bool
  
  init(indent: String = "", showVerbose: Bool = false) {
    self.indent = indent
    self.showVerbose = showVerbose
  }
  
  func indent(by count: Int) -> Format {
    Format(indent: indent.appending(String(repeating: " ", count: count)))
  }
  
  func verbose() -> Format {
    guard showVerbose else {
      return Format(indent: indent, showVerbose: true)
    }
    return self
  }
}

/// Creates an indent ``String`` of the specified length.
///
/// - Parameter by: The number of characters to indent by.
/// - Returns the indent ``String``.
func indent(by: Int) -> String {
  String(repeating: " ", count: by)
}

/// A `Printer` will take a `value` and a ``Format`` and print it with that format.
typealias Printer<T> = (_ value: T, _ format: Format) -> Void

/// Prints a line of text with the specified ``Format``.
///
/// - Parameter text: The text to print.
/// - Parameter format: The ``Format`` to print with.
func print(text: CustomStringConvertible, format: Format) {
  print("\(format.indent)\(text)")
}

/// Prints the provided text, underlined on the next line with the `char` character matching the text length.
///
/// - Parameter underline: The text of the title.
/// - Parameter with: The ``Character`` to use for the underline (eg. `"="`).
/// - Parameter indentBy: The number of spaces to indent by (defaults to `0`).
func print(underline text: CustomStringConvertible, with char: Character, format: Format) {
  let text = String(describing: text)
  print(text: text, format: format)
  print(text: String(repeating: char, count: text.count), format: format)
}

/// Prints the provided title text, underlined with `"="` on the next line.
///
/// - Parameter title: The title text ``String``.
/// - Parameter indentBy: The amount to indent by (defaults to `0`).
func print(title text: CustomStringConvertible, format: Format) {
  print(underline: text, with: "=", format: format)
}

/// Prints the provided subtitle text, underlined with `"-"` on the next line.
///
/// - Parameter title: The title text ``String``.
/// - Parameter indentBy: The amount to indent by (defaults to `0`).
func print(subtitle text: String, format: Format) {
  print(underline: text, with: "-", format: format)
}

/// Prints an item, with a subtitle leading it.
///
/// - Parameters:
///   - item: The item to print.
///   - label: The prefix label (optional).
///   - index: The index of the item. Will have `+1` added to it before printing.
///   - indentBy: The amount to indent by (defaults to `0`).
///   - printer: The ``Printer`` function to use to print the item.
func print<T>(item: T, label: String? = nil, index: Int, format: Format, with printer: Printer<T>) {
  var subtitle = ""
  if let label = label {
    subtitle += "\(label) "
  }
  subtitle += "#\(index+1):"
  print(subtitle: subtitle, format: format)
  printer(item, format)
}

func print<T>(list: [T], label: String? = nil, format: Format, with printer: Printer<T>) {
  for (i, item) in list.enumerated() {
    print(item: item, label: label, index: i, format: format, with: printer)
  }
}

func print<T: CustomStringConvertible>(label: String, value: T, format: Format) {
  print("\(format.indent)\(label): \(value)")
}

enum WhenNil {
  case skip
  case print(String)
}

func print<T: CustomStringConvertible>(label: String, value: T?, verbose: Bool = false, format: Format, whenNil: WhenNil = .skip) {
  guard !verbose || format.showVerbose else {
    return
  }
  
  if let value = value {
    print(label: label, value: value, format: format)
  } else {
    switch whenNil {
    case .skip: break
    case .print(let value):
      print(label: label, value: value, format: format)
    }
  }
}

// ===============================================
// Printers for specific types.
// ===============================================

func print(file: File, format: Format) {
  print(label: "ID", value: file.id, format: format)
  print(label: "Bytes", value: file.bytes, format: format)
  print(label: "Created At", value: file.createdAt, format: format)
  print(label: "Filename", value: file.filename, format: format)
  print(label: "Purpose", value: file.purpose, format: format)
  
  if let status = file.status {
    print(label: "Status", value: status, format: format)
  }
  if let statusDetails = file.statusDetails {
    print(label: "Status Details", value: statusDetails, format: format)
  }
}

func print(completion: Completions.Response, format: Format) {
  print(label: "ID", value: completion.id, verbose: true, format: format)
  print(label: "Created", value: completion.created, verbose: true, format: format)
  print(label: "Model", value: completion.model, format: format)
  
  print("")
  print(list: completion.choices, label: "Choice", format: format, with: print(choice:format:))
  
  print(usage: completion.usage, format: format)
}

func print(choice: Completions.Choice, format: Format) {
  let border = String(repeating: "~", count: 40)
  
  print(label: "Logprobs", value: choice.logprobs, verbose: true, format: format)
  print(label: "Finish Reason", value: choice.finishReason, format: format)
  
  print(text: border, format: format)
  print(choice.text)
  print(text: border, format: format)
}

func print(usage: Usage, format: Format) {
  print("")
  print(label: "Tokens Used", value: "Prompt: \(usage.promptTokens); Completion: \(usage.completionTokens ?? 0); Total: \(usage.totalTokens)", format: format)
}
