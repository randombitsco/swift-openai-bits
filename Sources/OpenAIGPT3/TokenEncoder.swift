// Byte pair encoding utilities
// Ported from https://github.com/openai/gpt-2/blob/master/src/encoder.py

import Foundation

/// Represents a pair of symbols. Used during encoding.
fileprivate struct SymbolPair: Hashable {
  let left: String
  let right: String
  
  @inlinable
  init(_ left: String, _ right: String) {
    self.left = left
    self.right = right
  }
}

/// Returns list of utf-8 byte and a corresponding list of unicode strings.
/// The reversible bpe codes work on unicode strings.
/// This means you need a large # of unicode characters in your vocab if you want to avoid UNKs.
/// When you're at something like a 10B token dataset you end up needing around 5K for decent coverage.
/// This is a signficant percentage of your normal, say, 32K bpe vocab.
/// To avoid that, we want lookup tables between utf-8 bytes and unicode strings.
/// And avoids mapping to whitespace/control characters the bpe code barfs on.
///
/// - Returns a dictionary mapping ``UInt8`` values to the ``String`` equivalent.
fileprivate func bytesToUnicode() -> [UInt8: Character] {
  var dict = [UInt8: Character]()
  
  var n: UInt16 = 0
  for b: UInt8 in 0...255 {
    switch b {
    case 33...126, // '!' to '~'
         161...172, // '¡' to '¬'
         174...255: // '®' to 'ÿ'
      dict[b] = Character(UnicodeScalar(b))
    default: // prepare additional characters to fill in the gaps
      dict[b] = Character(UnicodeScalar(256+n)!)
      n += 1
    }
  }
  
  return dict
}

/// Return set of symbol pairs in a `word`.
/// Word is represented as tuple of symbols (symbols being variable-length strings).
///
/// - Parameter word: The list of symbols that make up the `word`.
/// - Returns The set of ``SymbolPair`` values in the word.
fileprivate func getPairs(word: [String]) -> Set<SymbolPair> {
  var pairs = Set<SymbolPair>()
  var prevChar = word[0]
  for char in word[1..<word.count] {
    pairs.insert(.init(prevChar, char))
    prevChar = char
  }
  return pairs
}

public struct TokenEncoder {
  // Should haved added re.IGNORECASE so BPE merges can happen for capitalized versions of contractions
  fileprivate static let pattern: Pattern = #"'s|'t|'re|'ve|'m|'ll|'d| ?\p{L}+| ?\p{N}+| ?[^\s\p{L}\p{N}]+|\s+(?!\S)|\s+"#
  
  /// The UTF-8 byte encoder. Maps
  fileprivate static let byteEncoder: [UInt8: Character] = bytesToUnicode()
  fileprivate static let byteDecoder: [Character: UInt8] = {
    TokenEncoder.byteEncoder.reduce(into: [Character: UInt8](), { result, item in
      result[item.value] = item.key
    })
  }()
  
  /// The `text` -> `token` encoder.
  let encoder: [String: Int]
  
  /// The `token` -> `text` decoder.
  let decoder: [Int: String]
  
  /// The BPE Rankings for given ``SymbolPair`` values.
  fileprivate let bpeRanks: [SymbolPair: Int]
  
  /// Creates a new encoder with an optional ``Model``.
  ///
  /// - Parameters model: The model to use (defaults to ``Model/gpt3``).
  /// - Throws errors if unable to load the required resources for the encoder.
  public init(model: Model = .gpt3) throws {
    encoder = try model.encoder()
    decoder = encoder.reduce(into: [Int: String]()) { result, item in
      result[item.value] = item.key
    }
    
    bpeRanks = try model.bpeRanks()
  }

  /// Perform Byte-Pair Encoding (BPE) of the `token`, making use of the model's BPE Ranks.
  ///
  /// - Parameter token: The token to encode.
  /// - Returns The encoded token.
  fileprivate func bpe(token: String) -> String {
    var word: [String] = Array(token).map { String($0) }
    var pairs: Set<SymbolPair> = getPairs(word: word)
    if pairs.isEmpty {
      return token
    }
    while true {
      let bigram = pairs.min { bpeRanks[$0] ?? Int.max < bpeRanks[$1] ?? Int.max }
      
      guard let bigram = bigram else { break }
      
      guard bpeRanks[.init(bigram.left, bigram.right)] != nil else {
        break
      }
      
      let first = bigram.left
      let second = bigram.right
      var newWord = [String]()
      var i = 0
      
      while i < word.count {
        if let j = word[i...].firstIndex(of: first) {
          newWord.append(contentsOf: word[i..<j])
          i = j
        } else {
          newWord.append(contentsOf: word[i...])
          break
        }
        if word[i] == first && i < word.count - 1 && word[i + 1] == second {
          newWord.append(first + second)
          i += 2
        } else {
          newWord.append(word[i])
          i += 1
        }
      }
      word = newWord
      if word.count == 1 {
        break
      } else {
        pairs = getPairs(word: word)
      }
    }
    let wordString = word.joined(separator: " ")
    return wordString
  }

  /// Encodes the provided `text` into an array of tokens.
  ///
  /// - Parameter text: The text to encode.
  /// - Returns the list of tokens.
  public func encode(text: String) throws -> [Int] {
    var bpeTokens: [Int] = []
    var cache = [String: String]()
    
    // split the text into chunks
    for result in TokenEncoder.pattern.findAll(in: text) {
      // get the chunk as a UTF-8 UInt8 array
      let utf8View = result.value.utf8
      // use the byte encoder to convert the bytes back into characters
      let token = String(utf8View.map { TokenEncoder.byteEncoder[$0]! })
      // run bpe on the token and split it where there are spaces
      let word = cache[token] ?? bpe(token: token)
      cache[token] = word
      
      let splitBpe = word.split(separator: " ")
      // encode the BPE result
      let encodedResult = try splitBpe.map {
        guard let value = encoder[String($0)] else {
          throw TokenEncoder.Error.invalidEncoding(value: String($0))
        }
        return value
      }
      // add the results to the list of bpe tokens
      bpeTokens.append(contentsOf: encodedResult)
    }
    return bpeTokens
  }

  /// Decodes the provided `tokens` into the original text string.
  ///
  /// - Parameter tokens: The tokens to decode.
  /// - Returns the decoded text
  /// - Throws an error if invalid tokens are provided.
  public func decode(tokens: [Int]) throws -> String {
    let text = try tokens.map {
      guard let value = decoder[$0] else {
        throw TokenEncoder.Error.invalidToken(value: $0)
      }
      return value
    }.joined()
    let decoded = text.map { TokenEncoder.byteDecoder[$0] }.map { Character(UnicodeScalar($0!)) }
    return String(decoded)
  }
}

extension TokenEncoder {
  public enum Error: Swift.Error, Equatable {
    case missingResource(name: String)
    case invalidBytePair(value: String)
    case invalidEncoding(value: String)
    case invalidToken(value: Int)
  }
}

extension TokenEncoder {
  /// The model for the encoder. Currently just supports GPT-3 (same as GPT-2).
  public enum Model: String {
    /// Uses the standard GPT-2/GPT-3 encoding model.
    case gpt3
    // case codex // [[ TODO: Figure out if there are actually different values for Codex. ]]
    
    /// Loads the encoder array, mapping between token strings and their integer representation.
    func encoder() throws -> [String: Int] {
      guard let encoderPath = Bundle.module.url(forResource: "Resources/\(rawValue)/encoder", withExtension: "json") else {
        throw TokenEncoder.Error.missingResource(name: "Resources/\(rawValue)/encoder.json")
      }
      let encoderData = try Data(contentsOf: encoderPath)
      return try JSONDecoder().decode([String: Int].self, from: encoderData)
    }
    
    fileprivate func bpeRanks() throws -> [SymbolPair: Int] {
      guard let bpePath = Bundle.module.url(forResource: "Resources/\(rawValue)/vocab", withExtension: "bpe") else {
        throw TokenEncoder.Error.missingResource(name: "Resources/\(rawValue)/vocab.bpe")
      }
      let bpeData = try String(contentsOf: bpePath, encoding: .utf8)
      
      let bpeMerges = try bpeData
        .split(separator: "\n")
        .dropFirst().dropLast()
        .map {
          let split = $0.split(separator: " ")
          guard split.count == 2,
                let left = split.first, let right = split.last else {
            throw TokenEncoder.Error.invalidBytePair(value: String($0))
          }
          return SymbolPair(String(left), String(right))
        }
      
      return bpeMerges.enumerated().reduce(into: [SymbolPair: Int]()) {result, item in
        result[item.element] = item.offset
      }
    }
  }
}
