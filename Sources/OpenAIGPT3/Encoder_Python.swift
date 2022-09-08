// Byte pair encoding utilities
// Ported from https://github.com/openai/gpt-2/blob/master/src/encoder.py
// (initially translated by GPT-3 Codex)

import Foundation

struct TokenPair: Hashable {
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
func bytesToUnicode() -> [Int: Character] {
  var bs = [Int]()
  var cs = [Int]()
  var n = 0
  for b in 33...126 { // '!' to '~'
    bs.append(b)
    cs.append(b)
  }
  for b in 161...172 { // '¡' to '¬'
    bs.append(b)
    cs.append(b)
  }
  for b in 174...255 { // '®' to 'ÿ'
    bs.append(b)
    cs.append(b)
  }
  for b in 0..<256 {
    if !bs.contains(b) {
      bs.append(b)
      cs.append(256 + n)
      n += 1
    }
  }
  var dict = [Int: Character]()
  for i in 0..<cs.count {
    if let scalar = UnicodeScalar(cs[i]) {
      dict[bs[i]] = Character(scalar)
    }
  }
  return dict
}

/// Return set of symbol pairs in a word.
/// Word is represented as tuple of symbols (symbols being variable-length strings).
func getPairs(word: [String]) -> Set<TokenPair> {
  var pairs = Set<TokenPair>()
  var prevChar = word[0]
  for char in word[1..<word.count] {
    pairs.insert(.init(prevChar, char))
    prevChar = char
  }
  return pairs
}

class TokenEncoder {
  var encoder: [String: Int]
  var decoder: [Int: String]
  var errors: String
  var byteEncoder: [Int: Character]
  var byteDecoder: [Character: Int]
  var bpeRanks: [TokenPair: Int]
  var cache: [String: String]
  var pat: Pattern

  init(encoder: [String: Int], bpeMerges: [TokenPair], errors: String = "replace") {
    self.encoder = encoder
    self.decoder = [Int: String]()
    for (k, v) in encoder {
      self.decoder[v] = k
    }
    self.errors = errors
    self.byteEncoder = bytesToUnicode()
    self.byteDecoder = [Character: Int]()
    for (k, v) in self.byteEncoder {
      self.byteDecoder[v] = k
    }
    self.bpeRanks = [TokenPair: Int]()
    for i in 0..<bpeMerges.count {
      self.bpeRanks[bpeMerges[i]] = i
    }
    self.cache = [String: String]()
    self.pat = Pattern(#"'s|'t|'re|'ve|'m|'ll|'d| ?\p{L}+| ?\p{N}+| ?[^\s\p{L}\p{N}]+|\s+(?!\S)|\s+"#)
  }

  func bpe(token: String) -> String {
    if let cached = self.cache[token] {
      return cached
    }
    var word: [String] = [token]
    var pairs: Set<TokenPair> = getPairs(word: word)
    if pairs.isEmpty {
      return token
    }
    while true {
      let bigram = pairs.min { (a, b) -> Bool in
        if let aRank = self.bpeRanks[a], let bRank = self.bpeRanks[b] {
          return aRank < bRank
        }
      }
      
      guard let bigram = bigram else { break }
      
      guard self.bpeRanks[.init(bigram.left, bigram.right)] != nil else {
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
    self.cache[token] = wordString
    return wordString
  }

  func encode(text: String) -> [Int] {
    var bpeTokens = [Int]()
    guard let matches = self.pat.matchGroups(in: text) else {
      return bpeTokens
    }
    
    for match in matches {
      let token: Array<Character> = Array((text as NSString).substring(with: match.range))
      let token = token.map { self.byteEncoder[Int($0.unicodeScalars.first!.value)] }.joined()
      let bpeToken = self.bpe(token: token).split(separator: " ").map { self.encoder[String($0)]! }
      bpeTokens.append(contentsOf: bpeToken)
    }
    return bpeTokens
  }

  func encode(_ text: String) -> [Int] {
    var bpeTokens: [Int] = []
    let matches = self.pat.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))
    for match in matches {
      let token = match.
        let utf8 = token.data(using: .utf8)
        var token = ""
        for byte in utf8! {
            token += self.byteEncoder[Int(byte)]
        }
        let bpeToken = self.bpe(token)
        let bpeTokensArray = bpeToken.components(separatedBy: " ")
        for bpeToken in bpeTokensArray {
            bpeTokens.append(self.encoder[bpeToken]!)
        }
    }
    return bpeTokens
  }

  func decode(tokens: [Int]) -> String {
    let text = tokens.map { self.decoder[$0]! }.joined()
    let text = text.map { self.byteDecoder[$0] }.map { Character(UnicodeScalar(UInt32($0))!) }.joined()
    return String(text)
  }
}

extension TokenEncoder {
  public enum Error: Swift.Error {
    case missingResource(name: String)
    case invalidTokenPair(value: String)
  }
}

func getEncoder(modelName: String, modelsDir: String) throws -> TokenEncoder {
  guard let encoderPath = Bundle.module.url(forResource: "encoder", withExtension: "json") else {
    throw TokenEncoder.Error.missingResource(name: "encoder.json")
  }
  guard let bpePath = Bundle.module.url(forResource: "vocab", withExtension: "bpe") else {
    throw TokenEncoder.Error.missingResource(name: "vocab.bpe")
  }
  
  let encoderData = try Data(contentsOf: encoderPath)
  let bpeData = try String(contentsOf: bpePath, encoding: .utf8)
  
  let encoder = try JSONDecoder().decode([String: Int].self, from: encoderData)
  let bpeMerges = try bpeData
    .split(separator: "\n")
    .dropFirst().dropLast()
    .map {
      let split = $0.split(separator: " ")
      guard split.count == 2,
            let left = split.first, let right = split.last else {
        throw TokenEncoder.Error.invalidTokenPair(value: String($0))
      }
      return TokenPair(String(left), String(right))
    }
  return TokenEncoder(encoder: encoder, bpeMerges: bpeMerges)
}
