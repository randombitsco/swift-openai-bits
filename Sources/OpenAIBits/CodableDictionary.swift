/// Allows a ``Dictionary`` with a non-``String`` key to be ``Codable``.
/// Solution found [here](https://www.fivestars.blog/articles/codable-swift-dictionaries/).
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
  public var wrappedValue: [Key: Value]

  public init() {
    wrappedValue = [:]
  }

  public init(wrappedValue: [Key: Value]) {
    self.wrappedValue = wrappedValue
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let rawKeyedDictionary = try container.decode([Key.RawValue: Value].self)

    wrappedValue = [:]
    for (rawKey, value) in rawKeyedDictionary {
      guard let key = Key(rawValue: rawKey) else {
        throw DecodingError.dataCorruptedError(
          in: container,
          debugDescription: "Invalid key: cannot initialize '\(Key.self)' from invalid '\(Key.RawValue.self)' value '\(rawKey)'")
      }
      wrappedValue[key] = value
    }
  }

  public func encode(to encoder: Encoder) throws {
    let rawKeyedDictionary = Dictionary(uniqueKeysWithValues: wrappedValue.map { ($0.rawValue, $1) })
    var container = encoder.singleValueContainer()
    try container.encode(rawKeyedDictionary)
  }
}

extension CodableDictionary: Hashable where Key: Hashable, Value: Hashable {}
extension CodableDictionary: Equatable where Key: Equatable, Value: Equatable {}
