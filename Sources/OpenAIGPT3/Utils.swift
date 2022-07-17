import Foundation

/// Encodes the provided value to a JSON string
///
/// - Parameter value: The value to encode
/// - Returns The encoded value.
func jsonEncode(_ value: Encodable) throws -> String {
  let encoder = JSONEncoder()
  encoder.keyEncodingStrategy = .convertToSnakeCase
  encoder.dateEncodingStrategy = .custom({ date, encoder in
    let seconds = Int64(date.timeIntervalSince1970)
    var singleValueEnc = encoder.singleValueContainer()
    try singleValueEnc.encode(seconds)
  })
  return try String(decoding: encoder.encode(value), as: UTF8.self)
}

/// Attempts to decode the provided `String` value into the target type `T`.
///
/// - Parameters:
///   - value: The value to decode
///   - targetType: The type to decode to (optional)
func jsonDecode<T: Decodable>(_ value: String, as targetType: T.Type = T.self) throws -> T {
  let decoder = JSONDecoder()
  decoder.keyDecodingStrategy = .convertFromSnakeCase
  decoder.dateDecodingStrategy = .custom({ decoder in
    let seconds: Int64 = try decoder.singleValueContainer().decode(Int64.self)
    return Date(timeIntervalSince1970: TimeInterval(seconds))
  })
  return try decoder.decode(targetType, from: value.data(using: .utf8)!)
}
