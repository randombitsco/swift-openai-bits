import Foundation

public struct Generations: JSONResponse, Equatable {
  /// The image data.
  public enum Image: Codable, Equatable {
    case url(URL)
    case data(Foundation.Data)
  }
  
  /// The `Date` the images were created.
  public let created: Date
  
  /// The list of images.
  public let images: [Image]
}

extension Generations {
  enum CodingKeys: String, CodingKey {
    case created
    case images = "data"
  }
}

extension Generations.Image {
  
  /// Loads the `Data` for the image, no matter which response type is nominated.
  /// If it is a ``Generations/Image/url(_:)``, the destination will be attempted to be read.
  /// If it is a ``Generations``
  /// - Returns: The `Data`.
  public func getData() throws -> Foundation.Data {
    switch self {
    case .url(let url):
      return try Data(contentsOf: url)
    case .data(let data):
      return data
    }
  }

  enum CodingKeys: String, CodingKey {
    case url
    case data = "b64Json"
  }

  /// Decodes an image from a response data. It will be either an object with a `url` field, containing a string with the URL, or a `b64_json` field, containing a string with the base64-encoded string value for the image data.
  public init(from decoder: Decoder) throws {
    // get a keyed container
    let container = try decoder.container(keyedBy: CodingKeys.self)
    // try to decode the url
    if let url = try container.decodeIfPresent(URL.self, forKey: .url) {
      self = .url(url)
      return
    }
    // try to decode the base64
    if let base64 = try container.decodeIfPresent(Data.self, forKey: .data) {
      self = .data(base64)
      return
    }
    // if we get here, we couldn't decode either
    throw OpenAI.Error.unexpectedResponse("Unknown response format for image.")
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    switch self {
    case .url(let url):
      try container.encode(url, forKey: .url)
    case .data(let data):
      try container.encode(data, forKey: .data)
    }
  }
}
