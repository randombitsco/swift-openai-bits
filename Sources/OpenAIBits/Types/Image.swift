import Foundation

public struct Image: JSONResponse, Equatable {
  public enum Data: Codable, Equatable {
    case link(URL)
    case bytes(Foundation.Data)
  }

  public let created: Date

  public let data: [Data]
}

extension Image.Data {
  
  public func getData() throws -> Foundation.Data {
    switch self {
    case .link(let url):
      return try Data(contentsOf: url)
    case .bytes(let data):
      return data
    }
  }

  enum CodingKeys: String, CodingKey {
    case link = "url"
    case bytes = "b64Json"
  }

  /// Decodes an image from a response data. It will be either an object with a `url` field, containing a string with the URL, or a `b64_json` field, containing a string with the base64-encoded string value for the image data.
  public init(from decoder: Decoder) throws {
    // get a keyed container
    let container = try decoder.container(keyedBy: CodingKeys.self)
    // try to decode the url
    if let url = try container.decodeIfPresent(URL.self, forKey: .link) {
      self = .link(url)
      return
    }
    // try to decode the base64
    if let base64 = try container.decodeIfPresent(Data.self, forKey: .bytes) {
      self = .bytes(base64)
      return
    }
    // if we get here, we couldn't decode either
    throw Client.Error.unexpectedResponse("Unknown response format for image.")
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    switch self {
    case .link(let url):
      try container.encode(url, forKey: .link)
    case .bytes(let data):
      try container.encode(data, forKey: .bytes)
    }
  }
}
