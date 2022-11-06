import Foundation
import MultipartForm

/// Given a prompt and/or an input image, the model will create ``Generations`` of images.
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
    /// The response will be a `URL` link to the image.
    case url
    /// The response will be binary `Data` for the image.
    case data = "b64_json"
  }
}


// MARK: Create

extension Images {
  /// A ``Call`` that creates an image given a prompt.
  ///
  /// ## Examples
  ///
  /// ### A simple image generation
  ///
  /// ```swift
  /// let client = Client(apiKey: "...")
  /// let image = try await client.call(Images.Create(
  ///   prompt: "a white siamese cat",
  ///   n: 1,
  ///   size: .of1024x1024
  ///   responseFormat: .link
  /// ))
  /// ```
  ///
  /// ## See Also
  ///
  /// - [OpenAI API](https://beta.openai.com/docs/api-reference/images/create)
  /// - [Image Creation Guide](https://beta.openai.com/docs/guides/images/generations)
  public struct Create: JSONPostCall {
    /// Responds with ``Generations``.
    public typealias Response = Generations

    var path: String { "images/generations" }

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
    public init(
      prompt: String,
      n: Int? = nil,
      size: Size? = nil,
      responseFormat: ResponseFormat? = nil,
      user: String? = nil
    ) {
      self.prompt = prompt
      self.n = n
      self.size = size
      self.responseFormat = responseFormat
      self.user = user
    }
  }
}

// MARK: Edit

extension Images {
  /// Creates an edited or extended image given an original image and a prompt.
  ///
  /// ## See Also
  ///
  /// - [OpenAI API](https://beta.openai.com/docs/api-reference/images/create-edit)
  /// - [Image Edit Guid](https://beta.openai.com/docs/guides/images/edits)
  public struct Edit: MultipartPostCall {
    /// Responds with ``Generations``.
    public typealias Response = Generations
    
    var path: String { "images/edits" }
    
    /// The Multipart boundary ID.
    let boundary: String = UUID().uuidString
    
    /// The image to edit. Must be a valid PNG file, less than 4MB, and square.
    public let image: Data
    
    /// An additional image whose fully transparent areas (e.g. where alpha is zero) indicate where image should be edited. Must be a valid PNG file, less than 4MB, and have the same dimensions as image.
    public let mask: Data
    
    /// A text description of the desired image(s). The maximum length is 1000 characters.
    public let prompt: String
    
    /// The number of images to generate. Must be between `1` and `10`. (defaults to `1`)
    public let n: Int?

    /// The size of the generated images. Must be one of ``Images/Size-swift.enum/of256x256``, ``Images/Size-swift.enum/of512x512``, or ``Images/Size-swift.enum/of1024x1024`` (the default).
    public let size: Size?

    /// The format in which the generated images are returned. Must be one of ``Images/ResponseFormat-swift.enum/url`` or ``Images/ResponseFormat-swift.enum/base64``.
    public let responseFormat: ResponseFormat?

    /// A unique identifier representing your end-user, which will help OpenAI to monitor and detect abuse.
    public let user: String?
    
    /// Constructs an `Edit` call.
    ///
    /// - Parameters:
    ///   - image: The ``image`` `Data`.
    ///   - mask: The ``mask`` `Data`.
    ///   - prompt: The ``prompt``.
    ///   - n: The number of images to generate. Must be between `1` and `10`. (defaults to `1`)
    ///   - size: The ``size``.
    ///   - responseFormat: The ``responseFormat``.
    ///   - user: The ``user``.
    public init(
      image: Data,
      mask: Data,
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
    
    /// Creates an edit call.
    ///
    /// - Parameters:
    ///   - imageSource: The `URL`  pointing at the image being edited.
    ///   - maskSource: The `URL` pointing at the mask image.
    ///   - prompt: The ``prompt``.
    ///   - n: The number of images to generate from the edit.
    ///   - size: The ``size``.
    ///   - responseFormat: The ``responseFormat``.
    ///   - user: The ``user``.
    public init(
      imageSource: URL,
      maskSource: URL,
      prompt: String,
      n: Int? = nil,
      size: Size? = nil,
      responseFormat: ResponseFormat? = nil,
      user: String? = nil
    ) throws {
      self.image = try Data(contentsOf: imageSource)
      self.mask = try Data(contentsOf: maskSource)
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
      var parts: [MultipartForm.Part] = [
        .init(name: "image", data: image, contentType: "image/png"),
        .init(name: "mask", data: mask, contentType: "image/png"),
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

// MARK: Variation

extension Images {
  public struct Variation: MultipartPostCall {
    /// Responds with ``Generations``.
    public typealias Response = Generations
    
    var path: String { "images/variations" }
    
    let boundary: String = UUID().uuidString
    
    /// The image to edit. Must be a valid PNG file, less than 4MB, and square.
    public let image: Data
    
    /// The number of images to generate. Must be between `1` and `10`. (defaults to `1`)
    public let n: Int?

    /// The size of the generated images. Must be one of ``Images/Size-swift.enum/of256x256``, ``Images/Size-swift.enum/of512x512``, or ``Images/Size-swift.enum/of1024x1024`` (the default).
    public let size: Size?

    /// The format in which the generated images are returned. Must be one of ``Images/ResponseFormat-swift.enum/url`` or ``Images/ResponseFormat-swift.enum/base64``.
    public let responseFormat: ResponseFormat?

    /// A unique identifier representing your end-user, which will help OpenAI to monitor and detect abuse.
    public let user: String?
    
    /// Creates a variations call.
    ///
    /// - Parameters:
    ///   - image: The ``image`` `Data`.
    ///   - n: The number of variations to generate. Must be between `1` and `10`. (defaults to `1`)
    ///   - size: <#size description#>
    ///   - responseFormat: <#responseFormat description#>
    ///   - user: <#user description#>
    public init(
      image: Data,
      n: Int?,
      size: Size?,
      responseFormat: ResponseFormat?,
      user: String?
    ) {
      self.image = image
      self.n = n
      self.size = size
      self.responseFormat = responseFormat
      self.user = user
    }
    
    /// Creates a variation call.
    ///
    /// - Parameters:
    ///   - imageSource: The `URL`  pointing at the image being varied.
    ///   - n: The number of images to generate from the edit.
    ///   - size: The ``size``.
    ///   - responseFormat: The ``responseFormat``.
    ///   - user: The ``user``.
    public init(
      imageSource: URL,
      n: Int? = nil,
      size: Size? = nil,
      responseFormat: ResponseFormat? = nil,
      user: String? = nil
    ) throws {
      self.image = try Data(contentsOf: imageSource)
      self.n = n
      self.size = size
      self.responseFormat = responseFormat
      self.user = user
    }

    /// Returns a `MultipartForm`  based on the parameters.
    ///
    /// - Returns: The form.
    public func getForm() throws -> MultipartForm {
      var parts: [MultipartForm.Part] = [
        .init(name: "image", data: image, contentType: "image/png"),
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
