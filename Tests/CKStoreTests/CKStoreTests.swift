import XCTest
@testable import CKStore

final class CKStoreTests: XCTestCase {
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        try KeychainService.saveSecretObject(secret: "Test", for: "charlesku915@gmail.com", on: "http://localhost:3000")
        
        guard let credential: String = KeychainService.retriveSecretObject(for: "charlesku915@gmail.com", on: "http://localhost:3000") else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(credential == "Test")
    }
}
