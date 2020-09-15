import XCTest

class LongLatMapTests: XCTestCase {
    func testDDtoDMS() throws {
        let result = decimalToDMS(decimalDegrees: 25.931944)
        XCTAssertEqual(result.degrees, 25)
        XCTAssertEqual(result.minutes, 55)
        XCTAssertEqual(result.seconds, 55)
        XCTAssertEqual(result.positive, true)
    }
}
