/// Represents a language code, based on [ISO-639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes).
/// The code is either 2 or 3 letters, from `a` to `z`, and is case-insensitive (the ``code`` property is always lowercased).
public struct Language: Codable, Hashable {
  public let code: String

  /// Creates a new language code.
  ///
  /// - Parameter rawValue: The language code, in two or three letters.
  public init?(_ code: String) {
    let count = code.count
    guard count == 2 || count == 3 else { return nil }
    guard code.allSatisfy({ $0.isLetter }) else { return nil }

    self.code = code.lowercased()
  }
}

// MARK: - Utility protocol extensions.

extension Language: RawRepresentable {

  public var rawValue: String { code }

  public init?(rawValue: String) {
    self.init(rawValue)
  }
}

extension Language: CustomStringConvertible {
  public var description: String { rawValue }
} 

extension Language: CustomDebugStringConvertible {
  public var debugDescription: String { rawValue }
}

extension Language: ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    guard let instance = Language(rawValue: value) else {
      fatalError("Invalid language code: \(value)")
    }
    self = instance
  }
}

// MARK: Officially supported languages.

extension Language {
  public static let english: Language = "en"
  public static let chinese: Language = "zh"
  public static let german: Language = "de"
  public static let spanish: Language = "es"
  public static let russian: Language = "ru"
  public static let korean: Language = "ko"
  public static let french: Language = "fr"
  public static let japanese: Language = "ja"
  public static let portuguese: Language = "pt"
  public static let turkish: Language = "tr"
  public static let polish: Language = "pl"
  public static let catalan: Language = "ca"
  public static let dutch: Language = "nl"
  public static let arabic: Language = "ar"
  public static let swedish: Language = "sv"
  public static let italian: Language = "it"
  public static let indonesian: Language = "id"
  public static let hindi: Language = "hi"
  public static let finnish: Language = "fi"
  public static let vietnamese: Language = "vi"
  public static let hebrew: Language = "he"
  public static let ukrainian: Language = "uk"
  public static let greek: Language = "el"
  public static let malay: Language = "ms"
  public static let czech: Language = "cs"
  public static let romanian: Language = "ro"
  public static let danish: Language = "da"
  public static let hungarian: Language = "hu"
  public static let tamil: Language = "ta"
  public static let norwegian: Language = "no"
  public static let thai: Language = "th"
  public static let urdu: Language = "ur"
  public static let croatian: Language = "hr"
  public static let bulgarian: Language = "bg"
  public static let lithuanian: Language = "lt"
  public static let latin: Language = "la"
  public static let maori: Language = "mi"
  public static let malayalam: Language = "ml"
  public static let welsh: Language = "cy"
  public static let slovak: Language = "sk"
  public static let telugu: Language = "te"
  public static let persian: Language = "fa"
  public static let latvian: Language = "lv"
  public static let bengali: Language = "bn"
  public static let serbian: Language = "sr"
  public static let azerbaijani: Language = "az"
  public static let slovenian: Language = "sl"
  public static let kannada: Language = "kn"
  public static let estonian: Language = "et"
  public static let macedonian: Language = "mk"
  public static let breton: Language = "br"
  public static let basque: Language = "eu"
  public static let icelandic: Language = "is"
  public static let armenian: Language = "hy"
  public static let nepali: Language = "ne"
  public static let mongolian: Language = "mn"
  public static let bosnian: Language = "bs"
  public static let kazakh: Language = "kk"
  public static let albanian: Language = "sq"
  public static let swahili: Language = "sw"
  public static let galician: Language = "gl"
  public static let marathi: Language = "mr"
  public static let punjabi: Language = "pa"
  public static let sinhala: Language = "si"
  public static let khmer: Language = "km"
  public static let shona: Language = "sn"
  public static let yoruba: Language = "yo"
  public static let somali: Language = "so"
  public static let afrikaans: Language = "af"
  public static let occitan: Language = "oc"
  public static let georgian: Language = "ka"
  public static let belarusian: Language = "be"
  public static let tajik: Language = "tg"
  public static let sindhi: Language = "sd"
  public static let gujarati: Language = "gu"
  public static let amharic: Language = "am"
  public static let yiddish: Language = "yi"
  public static let lao: Language = "lo"
  public static let uzbek: Language = "uz"
  public static let faroese: Language = "fo"
  public static let haitianCreole: Language = "ht"
  public static let pashto: Language = "ps"
  public static let turkmen: Language = "tk"
  public static let nynorsk: Language = "nn"
  public static let maltese: Language = "mt"
  public static let sanskrit: Language = "sa"
  public static let luxembourgish: Language = "lb"
  public static let myanmar: Language = "my"
  public static let tibetan: Language = "bo"
  public static let tagalog: Language = "tl"
  public static let malagasy: Language = "mg"
  public static let assamese: Language = "as"
  public static let tatar: Language = "tt"
  public static let hawaiian: Language = "haw"
  public static let lingala: Language = "ln"
  public static let hausa: Language = "ha"
  public static let bashkir: Language = "ba"
  public static let javanese: Language = "jw"
  public static let sundanese: Language = "su"
}

// MARK: Common language aliases

extension Language {
  public static let burmese: Language = .myanmar
  public static let valencian: Language = .catalan
  public static let flemish: Language = .dutch
  public static let haitian: Language = .haitianCreole
  public static let letzeburgesch: Language = .luxembourgish
  public static let pushto: Language = .pashto
  public static let panjabi: Language = .punjabi
  public static let moldavian: Language = .romanian
  public static let moldovan: Language = .romanian
  public static let sinhalese: Language = .sinhala
  public static let castilian: Language = .spanish
}
