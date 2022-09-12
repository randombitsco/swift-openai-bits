import XCTest
import CustomDump
@testable import OpenAIGPT3

// 01-Jan-2000 00:00:00 UTC
let dateSeconds = 946684800
let date = Date(timeIntervalSince1970: .init(dateSeconds))

final class ModelTests: XCTestCase {
  
  func testEncodeToJSON() throws {
    let model = Model(id: "alpha", created: date, ownedBy: "beta", permission: [], root: "alpha", parent: nil)
    let json = try jsonEncode(model)
    let expected = """
    {"id":"alpha","object":"model","created":\(dateSeconds),"owned_by":"beta","permission":[],"root":"alpha"}
    """
    
    XCTAssertNoDifference(expected, json)
  }
  
  func testDecodeFromJSON() throws {
    let model: Model = try jsonDecode("""
    {"id":"alpha","object":"model","created":\(dateSeconds),"owned_by":"beta","permission":[],"root":"alpha"}
    """)
    
    XCTAssertNoDifference(
      Model(id: "alpha", created: date, ownedBy: "beta", permission: [], root: "alpha", parent: nil),
      model
    )
  }
  
  func testDecodeFromJSONWithPermissions() throws {
    let model: Model = try jsonDecode("""
    {"id":"alpha","object":"model","created":\(dateSeconds),"owned_by":"beta","permission":[
      {"id":"gamma","created":\(dateSeconds),"allow_create_engine":true,"allow_sampling":false,"allow_logprobs":true,"allow_search_indices":false,"allow_view":true,"allow_fine_tuning":false,"organization":"omega","group":null,"is_blocking":false},
    ],"root":"alpha"}
    """)
    
    XCTAssertNoDifference(
      Model(id: "alpha", created: date, ownedBy: "beta", permission: [
        .init(id: "gamma", created: date, allowCreateEngine: true, allowSampling: false, allowLogprobs: true, allowSearchIndices: false, allowView: true, allowFineTuning: false, organization: "omega", group: nil, isBlocking: false),
      ], root: "alpha", parent: nil),
      model
    )
  }
}
