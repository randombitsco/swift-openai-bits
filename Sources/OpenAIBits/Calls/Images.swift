import Foundation
import MultipartForm

/// Given a prompt and/or an input image, the model will generate a new image.
///
/// ## See Also
///
/// - [OpenAI API](https://beta.openai.com/docs/api-reference/images)
/// - [Image Generation Guide](https://beta.openai.com/docs/guides/images)
public enum Images { }

// MARK: Support Types

extension Images {
  /// The options for image size generated.
  public enum Size: String, Codable {
    case of256x256 = "256x256"
    case of512x512 = "512x512"
    case of1024x1024 = "1024x1024"
  }

  /// The options for the response format.
  public enum ResponseFormat: String, Codable {
    case url
    case base64
  }
}


// MARK: Generations

extension Images {
  /// A ``Call`` that creates an image given a prompt.
  ///
  /// ## Examples
  ///
  /// ### A simple image generation
  ///
  /// ```swift
  /// let client = Client(apiKey: "...")
  /// let image = try await client.call(Images.Generate(
  ///   prompt: "a white siamese cat",
  ///   n: 1,
  ///   size: .of1024x1024
  /// ))
  /// ```
  ///
  /// ## See Also
  ///
  /// - [OpenAI API](https://beta.openai.com/docs/api-reference/images/generations)
  public struct Generations: JSONPostCall {
    public typealias Response = Image

    public var path: String { "images/generations" }

    /// A text description of the desired image(s). The maximum length is 1000 characters.
    public let prompt: String

    /// The number of images to generate. Must be between 1 and 10. (defaults to `1`)
    public let n: Int?

    /// The size of the generated images. Must be one of ``Images/Size-swift.enum/of256x256``, ``Images/Size-swift.enum/of512x512``, or ``Images/Size-swift.enum/of1024x1024`` (the default).
    public let size: Size?

    /// The format in which the generated images are returned. Must be one of ``Images/ResponseFormat-swift.enum/url`` or ``Images/ResponseFormat-swift.enum/base64``.
    public let responseFormat: ResponseFormat?

    /// A unique identifier representing your end-user, which will help OpenAI to monitor and detect abuse.
    public let user: String?
    
    /// Creates a call to generate images based on a prompt.
    ///
    /// - Parameters:
    ///   - prompt: The prompt.
    ///   - n: The number of images. (defaults to `1`)
    ///   - size: The size of the image (defaults to ``Images/Size-swift.enum/of1024x1024``)
    ///   - responseFormat: The ``Images/ResponseFormat``
    ///   - user: A unique identifier representing your end-user.
    public init(prompt: String, n: Int? = nil, size: Size? = nil, responseFormat: ResponseFormat? = nil, user: String? = nil) {
      self.prompt = prompt
      self.n = n
      self.size = size
      self.responseFormat = responseFormat
      self.user = user
    }
  }
}

// MARK: Edits

extension Images {
  public struct Edits: MultipartPostCall {
    /// Responds with an ``Image``.
    public typealias Response = Image
    
    var path: String { "images/edits" }
    
    let boundary: String = UUID().uuidString
    
    /// The image to edit. Must be a valid PNG file, less than 4MB, and square.
    public let image: URL
    
    /// An additional image whose fully transparent areas (e.g. where alpha is zero) indicate where image should be edited. Must be a valid PNG file, less than 4MB, and have the same dimensions as image.
    public let mask: URL
    
    /// A text description of the desired image(s). The maximum length is 1000 characters.
    public let prompt: String
    
    /// The number of images to generate. Must be between 1 and 10. (defaults to `1`)
    public let n: Int?

    /// The size of the generated images. Must be one of ``Images/Size-swift.enum/of256x256``, ``Images/Size-swift.enum/of512x512``, or ``Images/Size-swift.enum/of1024x1024`` (the default).
    public let size: Size?

    /// The format in which the generated images are returned. Must be one of ``Images/ResponseFormat-swift.enum/url`` or ``Images/ResponseFormat-swift.enum/base64``.
    public let responseFormat: ResponseFormat?

    /// A unique identifier representing your end-user, which will help OpenAI to monitor and detect abuse.
    public let user: String?
    
    public init(
      image: URL,
      mask: URL,
      prompt: String,
      n: Int? = nil,
      size: Size? = nil,
      responseFormat: ResponseFormat? = nil,
      user: String? = nil
    ) {
      self.image = image
      self.mask = mask
      self.prompt = prompt
      self.n = n
      self.size = size
      self.responseFormat = responseFormat
      self.user = user
    }
    
    /// Returns a `MultipartForm`  based on the parameters.
    ///
    /// - Returns: The form.
    public func getForm() throws -> MultipartForm {
      let imageData = try Data(contentsOf: image)
      let maskData = try Data(contentsOf: mask)
      
      var parts: [MultipartForm.Part] = [
        .init(name: "image", data: imageData),
        .init(name: "mask", data: maskData),
        .init(name: "prompt", value: prompt),
      ]
      
      if let n = n {
        parts.append(.init(name: "n", value: String(describing: n)))
      }
      
      if let size = size {
        parts.append(.init(name: "size", value: size.rawValue))
      }
      
      if let responseFormat = responseFormat {
        parts.append(.init(name: "response_format", value: responseFormat.rawValue))
      }
      
      if let user = user {
        parts.append(.init(name: "user", value: user))
      }
      
      return MultipartForm(
        parts: parts,
        boundary: boundary
      )
    }
  }
}
