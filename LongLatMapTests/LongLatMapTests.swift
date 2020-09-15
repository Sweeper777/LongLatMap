import XCTest

class LongLatMapTests: XCTestCase {
    func testDDtoDMS() {
        var result = decimalToDMS(decimalDegrees: 25.931944)
        XCTAssertEqual(result.degrees, 25)
        XCTAssertEqual(result.minutes, 55)
        XCTAssertEqual(result.seconds, 55)
        XCTAssertEqual(result.positive, true)
        
        result = decimalToDMS(decimalDegrees: 38.827866)
        XCTAssertEqual(result.degrees, 38)
        XCTAssertEqual(result.minutes, 49)
        XCTAssertEqual(result.seconds, 40)
        XCTAssertEqual(result.positive, true)
        
        result = decimalToDMS(decimalDegrees: 98.552419)
        XCTAssertEqual(result.degrees, 98)
        XCTAssertEqual(result.minutes, 33)
        XCTAssertEqual(result.seconds, 9)
        XCTAssertEqual(result.positive, true)
        
        result = decimalToDMS(decimalDegrees: -65.653738)
        XCTAssertEqual(result.degrees, 65)
        XCTAssertEqual(result.minutes, 39)
        XCTAssertEqual(result.seconds, 13)
        XCTAssertEqual(result.positive, false)
        
        result = decimalToDMS(decimalDegrees: -153.606058)
        XCTAssertEqual(result.degrees, 153)
        XCTAssertEqual(result.minutes, 36)
        XCTAssertEqual(result.seconds, 22)
        XCTAssertEqual(result.positive, false)
        
        result = decimalToDMS(decimalDegrees: -50.910949)
        XCTAssertEqual(result.degrees, 50)
        XCTAssertEqual(result.minutes, 54)
        XCTAssertEqual(result.seconds, 39)
        XCTAssertEqual(result.positive, false)
    }
}
