// Byte pair encoding utilities
// Ported from https://github.com/openai/gpt-2/blob/master/src/encoder.py
// (initially translated by GPT-3 Codex)

import Foundation

/// Returns list of utf-8 byte and a corresponding list of unicode strings.
/// The reversible bpe codes work on unicode strings.
/// This means you need a large # of unicode characters in your vocab if you want to avoid UNKs.
/// When you're at something like a 10B token dataset you end up needing around 5K for decent coverage.
/// This is a signficant percentage of your normal, say, 32K bpe vocab.
/// To avoid that, we want lookup tables between utf-8 bytes and unicode strings.
/// And avoids mapping to whitespace/control characters the bpe code barfs on.
///
/// - Returns a dictionary mapping ``UInt8`` values to the ``String`` equivalent.
func bytesToUnicode() -> [UInt8: UnicodeScalar] {
  var bs = [UInt8]()
  var cs = [UInt8]()
  var n = 0
  for b in 33...126 {
    bs.append(UInt8(b))
    cs.append(UInt8(b))
  }
  for b in 161...172 {
    bs.append(UInt8(b))
    cs.append(UInt8(b))
  }
  for b in 174...255 {
    bs.append(UInt8(b))
    cs.append(UInt8(b))
  }
  for b in 0..<256 {
    if !bs.contains(UInt8(b)) {
      bs.append(UInt8(b))
      cs.append(UInt8(256 + n))
      n += 1
    }
  }
  var dict = [UInt8: UnicodeScalar]()
  for i in 0..<cs.count {
    dict[bs[i]] = UnicodeScalar(cs[i])
  }
  return dict
}

struct SymbolPair: Hashable {
  let left: String
  let right: String

  @inlinable
  init(_ left: String, _ right: String) {
    self.left = left
    self.right = right
  }
}

/// Return set of symbol pairs in a word.
/// Word is represented as tuple of symbols (symbols being variable-length strings).
func getPairs(word: [String]) -> Set<SymbolPair> {
  var pairs = Set<SymbolPair>()
  var prevChar = word[0]
  for char in word[1..<word.count] {
    pairs.insert(.init(prevChar, char))
    prevChar = char
  }
  return pairs
}

class Encoder {
  var encoder: [String: Int]
  var decoder: [Int: String]
  var errors: String
  var byteEncoder: [UInt8: UnicodeScalar]
  var byteDecoder: [UnicodeScalar: UInt8]
  var bpeRanks: [String: Int]
  var cache: [String: String]
  var pat: NSRegularExpression

  init(encoder: [String: Int], bpeMerges: [String], errors: String = "replace") {
    self.encoder = encoder
    self.decoder = [Int: String]()
    for (k, v) in encoder {
      self.decoder[v] = k
    }
    self.errors = errors
    self.byteEncoder = bytesToUnicode()
    self.byteDecoder = [UnicodeScalar: UInt8]()
    for (k, v) in self.byteEncoder {
      self.byteDecoder[v] = k
    }
    self.bpeRanks = [String: Int]()
    for i in 0..<bpeMerges.count {
      self.bpeRanks[bpeMerges[i]] = i
    }
    self.cache = [String: String]()
    self.pat = try! NSRegularExpression(pattern: "'s|'t|'re|'ve|'m|'ll|'d| ?\\p{L}+| ?\\p{N}+| ?[^\\s\\p{L}\\p{N}]+|\\s+(?!\\S)|\\s+", options: [])
  }

  func bpe(token: String) -> String {
    if let cached = self.cache[token] {
      return cached
    }
    var word = [token]
    var pairs = getPairs(word: word)
    if pairs.count == 0 {
      return token
    }
    while true {
      let bigram = pairs.min { (a, b) -> Bool in
        if let aRank = self.bpeRanks[a.left + a.right], let bRank = self.bpeRanks[b.left + b.right] {
          return aRank < bRank
        }
      }
      
      guard let bigram = bigram else { break }
      
      guard self.bpeRanks[bigram.left + bigram.right] != nil else {
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
          newWord.append(contentsOf: word[i..<word.count])
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
    let matches = self.pat.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))
    for match in matches {
      let token = (text as NSString).substring(with: match.range)
      let token = token.map { self.byteEncoder[UInt8(ascii: $0)]! }.joined()
      let bpeToken = self.bpe(token: token).split(separator: " ").map { self.encoder[String($0)]! }
      bpeTokens.append(contentsOf: bpeToken)
    }
    return bpeTokens
  }

  func decode(tokens: [Int]) -> String {
    let text = tokens.map { self.decoder[$0]! }.joined()
    let text = text.map { self.byteDecoder[String($0)]! }.map { Character(UnicodeScalar(UInt32($0))!) }.joined()
    return String(text)
  }
}

func getEncoder(modelName: String, modelsDir: String) -> Encoder {
  let encoderPath = Bundle.module.url(forResource: "encoder", withExtension: "json")
  let bpePath = URL(fileURLWithPath: modelsDir).appendingPathComponent(modelName).appendingPathComponent("vocab.bpe").path
  let encoderData = try! Data(contentsOf: URL(fileURLWithPath: encoderPath))
  let bpeData = try! String(contentsOfFile: bpePath, encoding: .utf8)
  let encoder = try! JSONDecoder().decode([String: Int].self, from: encoderData)
  let bpeMerges = bpeData.split(separator: "\n").dropFirst().dropLast().map { $0.split(separator: " ").map { String($0) } }
  return Encoder(encoder: encoder, bpeMerges: bpeMerges)
}
