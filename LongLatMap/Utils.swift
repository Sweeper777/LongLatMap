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
    let degrees = Int(absVal)
    var remainder = absVal - Double(degrees)
    let minutes = Int(remainder / (1.0 / 60.0))
    remainder.formRemainder(dividingBy: 1.0 / 60.0)
    let seconds = Int(round(remainder / (1.0 / 3600.0)))
    return (degrees, minutes, seconds, positive)
}
