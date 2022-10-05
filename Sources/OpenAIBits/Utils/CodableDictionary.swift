/// Allows a `Dictionary` with a non-`String` key to be `Codable`.
/// Solution found [here](https://www.fivestars.blog/articles/codable-swift-dictionaries/).
/// 
/// Usage:
/// ```swift
/// enum MyKey: Codable {
///   case alpha
///   case beta
/// }
/// @CodableDictionary var dictionary: [MyKey, String] = [:]()
/// ```
@propertyWrapper
public struct CodableDictionary<Key: Hashable & RawRepresentable, Value: Codable>: Codable where Key.RawValue: Codable & Hashable {
  public var wrappedValue: [Key: Value]?

  public init() {
    wrappedValue = nil
  }

  public init(wrappedValue: [Key: Value]? = nil) {
    self.wrappedValue = wrappedValue
  }
  
  public init(wrappedValue: [Key: Value]) {
    self.wrappedValue = wrappedValue
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let rawKeyedDictionary = try container.decode(Optional<[Key.RawValue: Value]>.self)

    guard let rawKeyedDictionary = rawKeyedDictionary else {
      wrappedValue = nil
      return
    }
    
    var wrappedValue: [Key: Value] = [:]
    for (rawKey, value) in rawKeyedDictionary {
      guard let key = Key(rawValue: rawKey) else {
        throw DecodingError.dataCorruptedError(
          in: container,
          debugDescription: "Invalid key: cannot initialize '\(Key.self)' from invalid '\(Key.RawValue.self)' value '\(rawKey)'")
      }
      wrappedValue[key] = value
    }
    self.wrappedValue = wrappedValue
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    if let wrappedValue = wrappedValue {
      let rawKeyedDictionary = Dictionary(uniqueKeysWithValues: wrappedValue.map { ($0.rawValue, $1) })
      try container.encode(rawKeyedDictionary)
    } else {
      try container.encodeNil()
    }
  }
}

extension CodableDictionary: Hashable where Key: Hashable, Value: Hashable {}
extension CodableDictionary: Equatable where Key: Equatable, Value: Equatable {}
