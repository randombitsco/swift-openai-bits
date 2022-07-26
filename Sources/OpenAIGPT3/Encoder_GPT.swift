import Foundation

let encoder = try! JSONSerialization.jsonObject(with: Data(contentsOf: URL(fileURLWithPath: "encoder.json")), options: []) as! [String: Int]
let bpe_file = try! String(contentsOf: URL(fileURLWithPath: "vocab.bpe"), encoding: .utf8)

func range(x: UInt8, y: UInt8) -> [UInt8] {
  return Array(Array(0..<y).dropFirst(Int(x)))
}

func ord(_ x: Character) -> UInt8 {
  return UInt8(x.unicodeScalars.first!.value)
}

func chr(_ x: UInt8) -> Character {
  return Character(UnicodeScalar(x))
}

let textEncoder = String.Encoding.utf8.rawValue
let encodeStr = { (str: String) -> [String] in
  return Array(str.utf8).map { String($0) }
}

let textDecoder = String.Encoding.utf8
let decodeStr = { (arr: [String]) -> String in
  return String(bytes: arr.map { UInt8($0)! }, encoding: textDecoder)!
}

func dictZip<T, U>(_ x: [T], _ y: [U]) -> [T: U] {
  var result: [T: U] = [:]
  for (i, _) in x.enumerated() {
    result[x[i]] = y[i]
  }
  return result
}

let pat = try! NSRegularExpression(pattern: "'s|'t|'re|'ve|'m|'ll|'d| ?\\p{L}+| ?\\p{N}+| ?[^\\s\\p{L}\\p{N}]+|\\s+(?!\\S)|\\s+", options: [])

let decoder: [Int: String] = {
  var result: [Int: String] = [:]
  for (key, value) in encoder {
    result[value] = key
  }
  return result
}()

let lines = bpe_file.split(separator: "\n")

let bpe_merges = lines.dropFirst().dropLast().map { (line: Substring) -> [String] in
  return line.split(separator: " ").map { String($0) }
}

let byte_encoder: [UInt8: String] = {
  var bs = range(x: ord("!"), y: ord("~") + 1).map { String(chr($0)) } + range(x: ord("¡"), y: ord("¬") + 1).map { String(chr($0)) } + range(x: ord("®"), y: ord("ÿ") + 1).map { String(chr($0)) }

  var cs = bs
  var n = 0
  for b in 0..<UInt8(2 * 8) {
    if !bs.contains(String(chr(b))) {
      bs.append(String(chr(b)))
      cs.append(String(chr(UInt8(2 * 8 + n))))
      n = n + 1
    }
  }

  var result: [UInt8: String] = [:]
  for (i, _) in bs.enumerated() {
    result[ord(Character(bs[i]))] = cs[i]
  }
  return result
}()

let byte_decoder: [String: UInt8] = {
  var result: [String: UInt8] = [:]
  for (key, value) in byte_encoder {
    result[value] = key
  }
  return result
}()

let bpe_ranks = dictZip(bpe_merges, range(x: 0, y: UInt8(bpe_merges.count)))
var cache: [String: String] = [:]

func bpe(_ token: String) -> String {
  if let cached = cache[token] {
    return cached
  }

  var word = Array(token)

  var pairs = word.enumerated().map { (i, _) -> [String] in
    if i == 0 {
      return []
    }
    return [String(word[i - 1]), String(word[i])]
  }

  while true {
    var minPairs: [UInt8: [String]] = [:]
    for pair in pairs {
      let rank = bpe_ranks[pair] ?? 10^10
      minPairs[rank] = pair
    }

    let bigram = minPairs[minPairs.keys.min()!]!

    if bpe_ranks[bigram] == nil {
      break
    }

    let first = bigram[0]
    let second = bigram[1]
    var new_word: [Character] = []
    var i = 0

    while i < word.count {
      let j = word.firstIndex(of: Character(first)) ?? word.endIndex
      if j == word.endIndex {
        new_word.append(contentsOf: word.suffix(from: word.index(word.startIndex, offsetBy: i)))
        break
      }
      new_word.append(contentsOf: word.suffix(from: word.index(word.startIndex, offsetBy: i)).prefix(upTo: j))
      i = word.distance(from: word.startIndex, to: j)

      if word[i] == Character(first) && i < word.count - 1 && word[i + 1] == Character(second) {
        new_word.append(Character(first + second))
        i = i + 2
      } else {
        new_word.append(word[i])
        i = i + 1
      }
    }

    word = new_word
    if word.count == 1 {
      break
    } else {
      pairs = word.enumerated().map { (i, _) -> [String] in
        if i == 0 {
          return []
        }
        return [String(word[i - 1]), String(word[i])]
      }
    }
  }

  let wordStr = String(word)
  cache[token] = wordStr

  return wordStr
}

func encode(_ text: String) -> [Int] {
  var bpe_tokens: [Int] = []
  let matches = pat.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))
  for match in matches {
    let token = text[Range(match.range, in: text)!]
    let new_tokens = bpe(String(token)).split(separator: " ").map { encoder[String($0)]! }
    bpe_tokens.append(contentsOf: new_tokens)
  }
  return bpe_tokens
}

@available(macOS 13.0, *)
func decode(_ tokens: [Int]) -> String? {
  let text = tokens.map { decoder[$0]! }.joined()
  let textBytes: [UInt8] = text.split(separator: "").map { byte_decoder[String($0)]! }
  return String(bytes: textBytes, encoding: .utf8)
}
