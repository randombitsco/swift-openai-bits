import Foundation
import MultipartForm

// MARK: Audio namespace

/// The OpenAI API's Audio namespace.
///
/// ## Calls
///
/// - ``Audio/Transcriptions``
/// - ``Audio/Translations``
///
/// ## See Also
///
/// - [OpenAI API](https://beta.openai.com/docs/api-reference/audio)
/// - [Speech to text](https://beta.openai.com/docs/guides/speech-to-text)
public enum Audio {}

// MARK: Audio.Transcriptions

extension Audio {
    /// Transcribes audio into the input language.
    ///
    /// ## See Also
    ///
    /// - [OpenAI API](https://beta.openai.com/docs/api-reference/audio/transcriptions)
    /// - [Speech to text](https://beta.openai.com/docs/guides/speech-to-text)
    /// - [Supported Languages](https://github.com/openai/whisper#available-models-and-languages)
    public struct Transcriptions: MultipartPostCall {
        /// Responds with ``Transcription``.
        public typealias Response = Transcription

        var path: String { "audio/transcriptions" }

        /// The Multipart boundary ID.
        let boundary: String = UUID().uuidString

        /// The audio file to transcribe, in one of these formats: `mp3`, `mp4`, `mpeg`, `mpga`, `m4a`, `wav`, or `webm`.
        public var file: Data

        /// ID of the model to use. Only `whisper-1` is currently available.
        public var model: Model.ID

        /// An optional text to guide the model's style or continue a previous audio segment. The [prompt](https://platform.openai.com/docs/guides/speech-to-text/prompting) should match the audio language.
        public var prompt: String?

        /// The format of the transcript output, in one of these options: `json`, `text`, `srt`, `verbose_json`, or `vtt`.
        /// Defaults to `json`.
        public var responseFormat: ResponseFormat?

        /// The sampling temperature, between `0` and `1`. Higher values like `0.8` will make the output more random, while lower values like `0.2` will make it more focused and deterministic. If set to `0`, the model will use [log probability](https://en.wikipedia.org/wiki/Log_probability) to automatically increase the temperature until certain thresholds are hit.
        public var temperature: Percentage?

        /// The language of the input audio. Supplying the input language in [ISO-639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) format will improve accuracy and latency.
        public var language: Language?

        /// Creates a new ``Audio/Transcriptions`` call.
        ///
        /// - Parameters:
        ///   - file: The audio file to transcribe, in one of these formats: `mp3`, `mp4`, `mpeg`, `mpga`, `m4a`, `wav`, or `webm`.
        ///   - model: ID of the model to use. Only `whisper-1` is currently available.
        ///   - prompt: An optional text to guide the model's style or continue a previous audio segment. The [prompt](https://platform.openai.com/docs/guides/speech-to-text/prompting) should match the audio language.
        ///   - responseFormat: The format of the transcript output, in one of these options: `json`, `text`, `srt`, `verbose_json`, or `vtt`. Defaults to `json`.
        ///   - temperature: The sampling temperature, between `0` and `1`. Higher values like `0.8` will make the output more random, while lower values like `0.2` will make it more focused and deterministic. If set to `0`, the model will use [log probability](https://en.wikipedia.org/wiki/Log_probability) to automatically increase the temperature until certain thresholds are hit.
        ///   - language: The language of the input audio. Supplying the input language in [ISO-639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) format will improve accuracy and latency.
        public init(
            file: Data,
            model: Model.ID,
            prompt: String? = nil,
            responseFormat: ResponseFormat? = nil,
            temperature: Percentage? = nil,
            language: Language? = nil
        ) {
            self.file = file
            self.model = model
            self.prompt = prompt
            self.responseFormat = responseFormat
            self.temperature = temperature
            self.language = language
        }

        /// Returns a `MultipartForm` for this call.
        ///
        /// - Returns: The form.
        public func getForm() throws -> MultipartForm {
            var parts: [MultipartForm.Part] = [
                .init(name: "file", data: file, filename: "file", contentType: "application/octet-stream"),
                .init(name: "model", value: model.value),
            ]

            if let prompt = prompt {
                parts.append(.init(name: "prompt", value: prompt))
            }

            if let responseFormat = responseFormat {
                parts.append(.init(name: "response_format", value: responseFormat.rawValue))
            }

            if let temperature = temperature {
                parts.append(.init(name: "temperature", value: temperature.value.description))
            }

            if let language = language {
                parts.append(.init(name: "language", value: language.code))
            }

            return MultipartForm(
                parts: parts,
                boundary: boundary
            )
        }
    }
}

// MARK: Audio.Translations

extension Audio {
    /// Translates an audio file into English.
    ///
    /// ## See Also
    ///
    /// - [OpenAI API](https://beta.openai.com/docs/api-reference/audio/translations)
    /// - [Speech to text](https://beta.openai.com/docs/guides/speech-to-text)
    /// - [Supported Languages](https://github.com/openai/whisper#available-models-and-languages)
    public struct Translations: MultipartPostCall {
        /// Response with ``Transcription``.
        public typealias Response = Transcription

        var path: String { "audio/translations" }

        /// The Multipart boundary ID.
        let boundary: String = UUID().uuidString

        /// The audio file to translate, in one of these formats: `mp3`, `mp4`, `mpeg`, `mpga`, `m4a`, `wav`, or `webm`.
        public var file: Data

        /// ID of the model to use. Only `whisper-1` is currently available.
        public var model: Model.ID

        /// An optional text to guide the model's style or continue a previous audio segment. The [prompt](https://platform.openai.com/docs/guides/speech-to-text/prompting) should be in English.
        public var prompt: String?

        /// The format of the transcript output, in one of these options: `json`, `text`, `srt`, `verbose_json`, or `vtt`. Defaults to `json`.
        public var responseFormat: ResponseFormat?

        /// The sampling temperature, between `0` and `1`. Higher values like `0.8` will make the output more random, while lower values like `0.2` will make it more focused and deterministic. If set to `0`, the model will use [log probability](https://en.wikipedia.org/wiki/Log_probability) to automatically increase the temperature until certain thresholds are hit.
        public var temperature: Percentage?

        /// Creates a new ``Audio.Translations`` call.
        ///
        /// - Parameters:
        ///   - file: The audio file to translate, in one of these formats: `mp3`, `mp4`, `mpeg`, `mpga`, `m4a`, `wav`, or `webm`.
        ///   - model: ID of the model to use. Only `whisper-1` is currently available.
        ///   - prompt: An optional text to guide the model's style or continue a previous audio segment. The [prompt](https://platform.openai.com/docs/guides/speech-to-text/prompting) should be in English.
        ///   - responseFormat: The format of the transcript output, in one of these options: `json`, `text`, `srt`, `verbose_json`, or `vtt`. Defaults to `json`.
        ///   - temperature: The sampling temperature, between `0` and `1`. Higher values like `0.8` will make the output more random, while lower values like `0.2` will make it more focused and deterministic. If set to `0`, the model will use [log probability](https://en.wikipedia.org/wiki/Log_probability) to automatically increase the temperature until certain thresholds are hit.
        public init(
            file: Data,
            model: Model.ID,
            prompt: String? = nil,
            responseFormat: ResponseFormat? = nil,
            temperature: Percentage? = nil
        ) {
            self.file = file
            self.model = model
            self.prompt = prompt
            self.responseFormat = responseFormat
            self.temperature = temperature
        }

        /// Returns a `MultipartForm` for this call.
        ///
        /// - Returns: The form.
        public func getForm() throws -> MultipartForm {
            var parts: [MultipartForm.Part] = [
                .init(name: "file", data: file, filename: "file", contentType: "application/octet-stream"),
                .init(name: "model", value: model.value),
            ]

            if let prompt = prompt {
                parts.append(.init(name: "prompt", value: prompt))
            }

            if let responseFormat = responseFormat {
                parts.append(.init(name: "response_format", value: responseFormat.rawValue))
            }

            if let temperature = temperature {
                parts.append(.init(name: "temperature", value: temperature.value.description))
            }

            return MultipartForm(
                parts: parts,
                boundary: boundary
            )
        }
    }
}

// MARK: ResponseFormat

extension Audio {

    /// The format of the transcript output, for ``Audio/Transcriptions`` and ``Audio/Translations``.
    public enum ResponseFormat: String, Codable {
        case json
        case text
        case srt
        case verboseJson = "verbose_json"
        case vtt
    }
}