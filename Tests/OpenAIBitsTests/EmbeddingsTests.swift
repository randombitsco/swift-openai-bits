//
//  EmbeddingsTests.swift
//
//
//  Created by David Peterson on 19/7/2022.
//

import XCTest
import CustomDump
@testable import OpenAIBits

final class EmbeddingsTests: XCTestCase {

  func testEmbeddingsStringRequestToJSON() throws {
    let value = Embeddings(
      model: .text_davinci_002,
      input: "Input string."
    )
    XCTAssertNoDifference(
      #"{"model":"text-davinci-002","input":"Input string."}"#,
      try jsonEncode(value)
    )
  }

  func testEmbeddingsStringArrayRequestToJSON() throws {
    let value = Embeddings(
      model: .text_davinci_002,
      input: .strings(["One", "Two"])
    )
    XCTAssertNoDifference(
      #"{"model":"text-davinci-002","input":["One","Two"]}"#,
      try jsonEncode(value)
    )
  }
  
  func testEmbeddingsTokenArrayRequestToJSON() throws {
    let value = Embeddings(
      model: .text_davinci_002,
      input: .tokenArray([12,34,567])
    )
    XCTAssertNoDifference(
      #"{"model":"text-davinci-002","input":[12,34,567]}"#,
      try jsonEncode(value)
    )
  }

  func testEmbeddingsTokenArraysRequestToJSON() throws {
    let value = Embeddings(
      model: .text_davinci_002,
      input: .tokenArrays([[12,34,567],[987,65,432,1]])
    )
    XCTAssertNoDifference(
      #"{"model":"text-davinci-002","input":[[12,34,567],[987,65,432,1]]}"#,
      try jsonEncode(value)
    )
  }
  
  func testEmbeddingsWithUserRequestToJSON() throws {
    let value = Embeddings(
      model: .text_davinci_002,
      input: "Input string.",
      user: "foo"
    )
    XCTAssertNoDifference(
      #"{"model":"text-davinci-002","input":"Input string.","user":"foo"}"#,
      try jsonEncode(value)
    )
  }
}
