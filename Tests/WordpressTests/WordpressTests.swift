import XCTest
@testable import Wordpress

final class WordpressTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Wordpress().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
