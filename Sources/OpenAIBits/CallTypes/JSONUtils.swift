import Foundation

/// An implementation of CodingKey that's useful for combining and transforming keys as strings.
struct AnyKey: CodingKey {
  var stringValue: String
  var intValue: Int?

  init?(stringValue: String) {
    self.stringValue = stringValue
    self.intValue = nil
  }

  init?(intValue: Int) {
    self.stringValue = String(intValue)
    self.intValue = intValue
  }
}

/// Encodes the provided value to a JSON string
///
/// - Parameter value: The value to encode
/// - Parameter options: The output formatting options. Defaults to none.
/// - Returns The encoded value.
func jsonEncode<T: Encodable>(_ value: T, options:  JSONEncoder.OutputFormatting = []) throws -> String {
  return try String(decoding: jsonEncodeData(value, options: options), as: UTF8.self)
}

/// Encodes the provided value to a JSON ``Data`` value
///
/// - Parameter value: The value to encode
/// - Returns the encoded value.
func jsonEncodeData<T: Encodable>(_ value: T, options:  JSONEncoder.OutputFormatting = []) throws -> Data {
  let encoder = JSONEncoder()
  encoder.outputFormatting = options
  encoder.keyEncodingStrategy = .convertToSnakeCase
  encoder.dateEncodingStrategy = .custom({ date, encoder in
    let seconds = Int64(date.timeIntervalSince1970)
    var singleValueEnc = encoder.singleValueContainer()
    try singleValueEnc.encode(seconds)
  })
  return try encoder.encode(value)
}

/// Attempts to decode the provided `String` value into the target type `T`.
///
/// - Parameters:
///   - value: The value to decode
///   - targetType: The type to decode to (optional)
func jsonDecode<T: Decodable>(_ value: String, as targetType: T.Type = T.self) throws -> T {
  return try jsonDecodeData(value.data(using: .utf8)!)
}

func jsonDecodeData<T: Decodable>(_ value: Data, as targetType: T.Type = T.self) throws -> T {
  let decoder = JSONDecoder()
  decoder.keyDecodingStrategy = .convertFromSnakeCase
  decoder.dateDecodingStrategy = .custom({ decoder in
    let seconds: Int64 = try decoder.singleValueContainer().decode(Int64.self)
    return Date(timeIntervalSince1970: TimeInterval(seconds))
  })
  return try decoder.decode(targetType, from: value)
}

let CONTENT_TYPE = "Content-Type"
let APPLICATION_JSON = "application/json"


func isJSON(contentType: String) -> Bool {
  contentType.starts(with: APPLICATION_JSON)
}

/// Checks if the value in the provided ``HTTPURLResponse`` is ``JSON``.
///
/// - Parameter response: The ``HTTPURLResponse``.
func isJSON(response: HTTPURLResponse) -> Bool {
  guard let contentType = response.value(forHTTPHeaderField: CONTENT_TYPE) else { return false }
  return isJSON(contentType: contentType)
}
