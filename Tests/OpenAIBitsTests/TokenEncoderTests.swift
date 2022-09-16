//
//  EncoderTests.swift
//  
//
//  Created by David Peterson on 12/9/2022.
//

import XCTest
import CustomDump
@testable import OpenAIBits

final class TokenEncoderTests: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testGPT3SimpleText() throws {
    let text = "This is some text."
    let tokens = [1212, 318, 617, 2420, 13]
    
    let encoder = try TokenEncoder()
    
    XCTAssertNoDifference(try encoder.encode(text: text), tokens)
    XCTAssertNoDifference(try encoder.decode(tokens: tokens), text)
  }
  
  func testGPT3Lorem() throws {
    let input = "Lorem"
    let output = [43, 29625]
    
    let encoder = try TokenEncoder()
    
    XCTAssertNoDifference(try encoder.encode(text: input), output)
    XCTAssertNoDifference(try encoder.decode(tokens: output), input)
  }
  
  func testLongerText() throws {
    let text = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
    """
    let tokens = [43, 29625, 220, 2419, 388, 288, 45621, 1650, 716, 316, 11, 369, 8831, 316, 333, 31659, 271, 2259, 1288, 270, 11, 10081, 466, 304, 3754, 4666, 10042, 753, 312, 312, 2797, 3384, 2248, 382, 2123, 288, 349, 382, 2153, 2616, 435, 1557, 64, 13, 7273, 551, 320, 512, 10356, 8710, 1789, 11, 627, 271, 18216, 81, 463, 4208, 3780, 334, 297, 321, 1073, 4827, 271, 299, 23267, 3384, 435, 1557, 541, 409, 304, 64, 13088, 78, 4937, 265, 13, 10343, 271, 257, 1133, 4173, 495, 288, 45621, 287, 1128, 260, 258, 681, 270, 287, 2322, 37623, 378, 11555, 270, 1658, 325, 269, 359, 388, 288, 349, 382, 304, 84, 31497, 5375, 9242, 64, 1582, 72, 2541, 13, 18181, 23365, 264, 600, 1609, 64, 721, 265, 6508, 312, 265, 265, 1729, 386, 738, 11, 264, 2797, 287, 10845, 8957, 45567, 1163, 544, 748, 263, 2797, 285, 692, 270, 2355, 4686, 1556, 4827, 388, 13]
    
    let encoder = try TokenEncoder()
    XCTAssertNoDifference(try encoder.encode(text: text), tokens)
    XCTAssertNoDifference(try encoder.decode(tokens: tokens), text)
  }
  
  func testFailingDecode() throws {
    let tokens = [43, 150000] // 150000 is well above the token boundary for GPT-3 and will fail.
    
    let encoder = try TokenEncoder()
    XCTAssertThrowsError(try encoder.decode(tokens: tokens)) { err in
      XCTAssertEqual(err as! TokenEncoder.Error, TokenEncoder.Error.invalidToken(value: 150000))
    }
  }

}
