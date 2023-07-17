import XCTest
@testable import TechTalk_Library

@available(iOS 13.0, *)
final class TechTalk_LibraryTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(TechTalk_Library().text, "Hello, World!")
    }
}
