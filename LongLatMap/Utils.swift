import Foundation
import CoreLocation

extension String {
    var localised: String {
        NSLocalizedString(self, comment: "")
    }
}

func dmsToDecimal(degrees: Int, minutes: Int, seconds: Int, positive: Bool) -> CLLocationDegrees {
    (Double(degrees) + Double(minutes) / 60 + Double(seconds) / 3600) * (positive ? 1 : -1)
}

func decimalToDMS(decimalDegrees: CLLocationDegrees) -> (degrees: Int, minutes: Int, seconds: Int, positive: Bool) {
    let positive = decimalDegrees >= 0
    let absVal = abs(decimalDegrees)
    var degrees = Int(absVal)
    var remainder = absVal - Double(degrees)
    var minutes = Int(remainder / (1.0 / 60.0))
    remainder -= Double(minutes) * (1.0 / 60.0)
    var seconds = Int(round(remainder / (1.0 / 3600.0)))
    
    if seconds >= 60 {
        seconds -= 60
        minutes += 1
    }
    if minutes >= 60 {
        minutes -= 60
        degrees += 1
    }
    
    return (degrees, minutes, seconds, positive)
}
