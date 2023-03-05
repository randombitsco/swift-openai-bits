import Foundation

/// A ``Audio/Transcription`` or ``Audio/Translation`` `Call` response.
public enum Transcription: HTTPResponse, Equatable {
  
  
  case json(JSONTranscription)
  case srt(SRTTranscription)
  case text(TextTranscription)
  case verboseJson(VerboseJSONTranscription)
  case vtt(VTTTranscription)

  init(data: Data, contentType: String) throws {
    if isJSON(contentType: contentType) {
      // try decode as VerboseJSONTranscription first, then JSONTranscription
      do {
        let VerboseJSONTranscription = try JSONDecoder().decode(
          VerboseJSONTranscription.self, from: data)
        self = .verboseJson(VerboseJSONTranscription)
        return
      } catch {
        print("Error decoding VerboseJSONTranscription: \(error)")
        
        let jsonTranscription = try JSONDecoder().decode(JSONTranscription.self, from: data)
        self = .json(jsonTranscription)
        return
      }
    }

    if isText(contentType: contentType) {
      let body = String(data: data, encoding: .utf8) ?? ""

      // Try VTT, SRT, then Text
      if body.hasPrefix("WEBVTT\n") {
        self = .vtt(VTTTranscription(value: body))
        return
      } else if body.hasPrefix("1\n") {
        self = .srt(SRTTranscription(value: body))
        return
      } else {
        self = .text(TextTranscription(value: body))
        return
      }
    }

    throw OpenAI.Error.unexpectedResponse("Unexpected Content-Type: \(contentType)")
  }

  init(data: Data, response: HTTPURLResponse) throws {
    guard response.statusCode == 200 else {
      throw OpenAI.Error.unexpectedResponse("Unexpected status code: \(response.statusCode)")
    }

    guard let contentType = response.value(forHTTPHeaderField: CONTENT_TYPE) else {
      throw OpenAI.Error.unexpectedResponse("No Content-Type header in response")
    }

    self = try Self.init(data: data, contentType: contentType)
  }

  public func textValue() throws -> String {
    switch self {
    case .json(let transcription):
      return try jsonEncode(transcription, options: [.prettyPrinted])
    case .srt(let transcription):
      return transcription.value
    case .text(let transcription):
      return transcription.value
    case .verboseJson(let transcription):
      return try jsonEncode(transcription, options: [.prettyPrinted])
    case .vtt(let transcription):
      return transcription.value
    }
  }
}

// MARK: JSON Transcription

public struct JSONTranscription: Codable, Equatable {
  public let text: String
}

// MARK: Verbose JSON Transcription

public struct VerboseJSONTranscription: Codable, Equatable {
  public typealias Seconds = Double

  public let task: String
  public let language: String
  public let duration: Seconds
  public let segments: [Segment]
  public let text: String
}

extension VerboseJSONTranscription {
  public struct Segment: Codable, Equatable {
    public let id: Int
    public let seek: Int
    public let start: Seconds
    public let end: Seconds
    public let text: String
    public let tokens: [Token]
    public let temperature: Double?
    public let avgLogprob: Double?
    public let compressionRatio: Double?
    public let noSpeechProb: Double?
    public let transient: Bool?
  }
}

// MARK: Text Transcription

public struct TextTranscription: Codable, Equatable {
  public let value: String
}

// MARK: SRT Transcription

public struct SRTTranscription: Codable, Equatable {
  public let value: String
}

// MARK: VTT Transcription

public struct VTTTranscription: Codable, Equatable {
  public let value: String
}
