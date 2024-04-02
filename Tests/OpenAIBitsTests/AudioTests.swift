import CustomDump
import XCTest

@testable import OpenAIBits

// ## json
// Content-Type: application/json
// Sample Output:
let jsonSample = """
  {"text":"You sure not to lock us on my way, huh? Ha ha! Pickly good thought. That's our home for the next couple of hours. We want to take good care of it. Finally, that one foot up in."}
  """

// ## verbose_json
// Content-Type: application/json
// Sample Output:
let verboseJsonSample = """
  {"task":"transcribe","language":"english","duration":14.63,"segments":[{"id":0,"seek":0,"start":0.0,"end":2.32,"text":" You sure not to lock us on my way, huh?","tokens":[509,988,406,281,4017,505,322,452,636,11,7020,30],"temperature":0.0,"avgLogprob":-0.6381065731956845,"compressionRatio":1.3175675675675675,"noSpeechProb":0.19806183874607086,"transient":false},{"id":1,"seek":0,"start":2.32,"end":3.3200000000000003,"text":" Ha ha!","tokens":[4064,324,0],"temperature":0.0,"avgLogprob":-0.6381065731956845,"compressionRatio":1.3175675675675675,"noSpeechProb":0.19806183874607086,"transient":false},{"id":2,"seek":0,"start":5.32,"end":6.5200000000000005,"text":" Pickly good thought.","tokens":[14129,356,665,1194,13],"temperature":0.0,"avgLogprob":-0.6381065731956845,"compressionRatio":1.3175675675675675,"noSpeechProb":0.19806183874607086,"transient":false},{"id":3,"seek":0,"start":8.52,"end":11.52,"text":" That's our home for the next couple of hours. We want to take good care of it.","tokens":[663,311,527,1280,337,264,958,1916,295,2496,13,492,528,281,747,665,1127,295,309,13],"temperature":0.0,"avgLogprob":-0.6381065731956845,"compressionRatio":1.3175675675675675,"noSpeechProb":0.19806183874607086,"transient":false},{"id":4,"seek":1152,"start":11.52,"end":29.04,"text":" Finally, that one foot up in.","tokens":[50364,6288,11,300,472,2671,493,294,13,51240],"temperature":0.0,"avgLogprob":-0.7234281626614657,"compressionRatio":0.7837837837837838,"noSpeechProb":0.011953424662351608,"transient":false}],"text":"You sure not to lock us on my way, huh? Ha ha! Pickly good thought. That's our home for the next couple of hours. We want to take good care of it. Finally, that one foot up in."}
  """

let verboseJsonInstance = VerboseJSONTranscription(
  task: "transcribe",
  language: "english",
  duration: 14.63,
  segments: [
    .init(
      id: 0,
      seek: 0,
      start: 0.0,
      end: 2.32,
      text: " You sure not to lock us on my way, huh?",
      tokens: [509, 988, 406, 281, 4017, 505, 322, 452, 636, 11, 7020, 30],
      temperature: 0.0,
      avgLogprob: -0.6381065731956845,
      compressionRatio: 1.3175675675675675,
      noSpeechProb: 0.19806183874607086,
      transient: false
    ),
    .init(
      id: 1,
      seek: 0,
      start: 2.32,
      end: 3.3200000000000003,
      text: " Ha ha!",
      tokens: [4064, 324, 0],
      temperature: 0.0,
      avgLogprob: -0.6381065731956845,
      compressionRatio: 1.3175675675675675,
      noSpeechProb: 0.19806183874607086,
      transient: false
    ),
    .init(
      id: 2,
      seek: 0,
      start: 5.32,
      end: 6.5200000000000005,
      text: " Pickly good thought.",
      tokens: [14129, 356, 665, 1194, 13],
      temperature: 0.0,
      avgLogprob: -0.6381065731956845,
      compressionRatio: 1.3175675675675675,
      noSpeechProb: 0.19806183874607086,
      transient: false
    ),
    .init(
      id: 3,
      seek: 0,
      start: 8.52,
      end: 11.52,
      text: " That's our home for the next couple of hours. We want to take good care of it.",
      tokens: [
        663, 311, 527, 1280, 337, 264, 958, 1916, 295, 2496, 13, 492, 528, 281, 747, 665, 1127, 295,
        309, 13,
      ],
      temperature: 0.0,
      avgLogprob: -0.6381065731956845,
      compressionRatio: 1.3175675675675675,
      noSpeechProb: 0.19806183874607086,
      transient: false
    ),
    .init(
      id: 4,
      seek: 1152,
      start: 11.52,
      end: 29.04,
      text: " Finally, that one foot up in.",
      tokens: [50364, 6288, 11, 300, 472, 2671, 493, 294, 13, 51240],
      temperature: 0.0,
      avgLogprob: -0.7234281626614657,
      compressionRatio: 0.7837837837837838,
      noSpeechProb: 0.011953424662351608,
      transient: false
    ),
  ],
  text: textSample
)

// ## text
// Content-Type: text/plain; charset=utf-8
// Sample Output:
let textSample = """
  You sure not to lock us on my way, huh? Ha ha! Pickly good thought. That's our home for the next couple of hours. We want to take good care of it. Finally, that one foot up in.
  """

// ## srt
// Content-Type: text/plain; charset=utf-8
// Sample Output:
let srtSample = """
  1
  00:00:00,000 --> 00:00:02,320
  You sure not to lock us on my way, huh?

  2
  00:00:02,320 --> 00:00:03,320
  Ha ha!

  3
  00:00:05,320 --> 00:00:06,520
  Pickly good thought.

  4
  00:00:08,520 --> 00:00:11,520
  That's our home for the next couple of hours. We want to take good care of it.

  5
  00:00:11,520 --> 00:00:29,040
  Finally, that one foot up in.

  """

// ## vtt
// Content-Type: text/plain; charset=utf-8
// Sample Output:
let vttSample = """
  WEBVTT

  00:00:00.000 --> 00:00:02.320
  You sure not to lock us on my way, huh?

  00:00:02.320 --> 00:00:03.320
  Ha ha!

  00:00:05.320 --> 00:00:06.520
  Pickly good thought.

  00:00:08.520 --> 00:00:11.520
  That's our home for the next couple of hours. We want to take good care of it.

  00:00:11.520 --> 00:00:29.040
  Finally, that one foot up in.

  """

final class AudioTests: XCTestCase {

  func testAudioTranscriptionRequestToJSON() throws {
    let file = Data("audio data".utf8)
    let value = Audio.Transcriptions(
      file: file,
      fileName: "file.wav",
      model: .whisper_1,
      prompt: "prompt",
      responseFormat: .text,
      temperature: 0.5,
      language: .japanese
    )

    let form = try value.getForm()

    XCTAssertEqual(form.parts.count, 6)
    XCTAssertEqual(form.parts[0].data, file)
    XCTAssertEqual(form.parts[0].filename, "file.wav")
    XCTAssertEqual(form.parts[1].value, "whisper-1")
    XCTAssertEqual(form.parts[2].value, "prompt")
    XCTAssertEqual(form.parts[3].value, "text")
    XCTAssertEqual(form.parts[4].value, "0.5")
    XCTAssertEqual(form.parts[5].value, "ja")
  }

  func testJSONTranscriptionResponse() throws {
    XCTAssertNoDifference(
      JSONTranscription(text: textSample),
      try jsonDecode(jsonSample)
    )
  }

  func testJSONTranscriptionEnum() throws {
    XCTAssertNoDifference(
      Transcription.json(JSONTranscription(text: textSample)),
      try Transcription.init(data: Data(jsonSample.utf8), contentType: APPLICATION_JSON)
    )
  }

  func testVerboseJSONTranscriptionResponse() throws {
    XCTAssertNoDifference(
      verboseJsonInstance,
      try jsonDecode(verboseJsonSample)
    )
  }

  func testVerboseJSONTransactionEnum() throws {
    XCTAssertNoDifference(
      Transcription.verboseJson(verboseJsonInstance),
      try Transcription.init(data: Data(verboseJsonSample.utf8), contentType: APPLICATION_JSON)
    )
  }

  func testSRTTranscriptionEnum() throws {
    XCTAssertNoDifference(
      Transcription.srt(SRTTranscription(value: srtSample)),
      try Transcription.init(data: Data(srtSample.utf8), contentType: TEXT_PLAIN)
    )
  }
  
  func testVTTTranscriptionEnum() throws {
    XCTAssertNoDifference(
      Transcription.vtt(VTTTranscription(value: vttSample)),
      try Transcription.init(data: Data(vttSample.utf8), contentType: TEXT_PLAIN)
    )
  }

  func testTranscriptionText() throws {
    XCTAssertEqual(
      Transcription.text(TextTranscription(value: textSample)),
      try Transcription.init(data: Data(textSample.utf8), contentType: TEXT_PLAIN)
    )
  }
}
