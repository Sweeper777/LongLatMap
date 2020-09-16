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
    
    func testDMStoDD() {
        var result = dmsToDecimal(degrees: 25, minutes: 55, seconds: 55, positive: true)
        XCTAssertEqual(result, 25.931944, accuracy: 1/7200.0)
        result = dmsToDecimal(degrees: 38, minutes: 49, seconds: 40, positive: true)
        XCTAssertEqual(result, 38.827866, accuracy: 1/7200.0)
        result = dmsToDecimal(degrees: 98, minutes: 33, seconds: 9, positive: true)
        XCTAssertEqual(result, 98.552419, accuracy: 1/7200.0)
        
        result = dmsToDecimal(degrees: 65, minutes: 39, seconds: 13, positive: false)
        XCTAssertEqual(result, -65.653738, accuracy: 1/7200.0)
        result = dmsToDecimal(degrees: 153, minutes: 36, seconds: 22, positive: false)
        XCTAssertEqual(result, -153.606058, accuracy: 1/7200.0)
        result = dmsToDecimal(degrees: 50, minutes: 54, seconds: 39, positive: false)
        XCTAssertEqual(result, -50.910949, accuracy: 1/7200.0)
    }
    
    func testToDMSRounding() {
        var result = decimalToDMS(decimalDegrees: 123.5666666)
        XCTAssertEqual(result.degrees, 123)
        XCTAssertEqual(result.minutes, 34)
        XCTAssertEqual(result.seconds, 0)
        XCTAssertEqual(result.positive, true)
        
        result = decimalToDMS(decimalDegrees: 81.999972)
        XCTAssertEqual(result.degrees, 82)
        XCTAssertEqual(result.minutes, 0)
        XCTAssertEqual(result.seconds, 0)
        XCTAssertEqual(result.positive, true)
    }
}
