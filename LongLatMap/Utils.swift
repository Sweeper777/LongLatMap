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
    remainder -= Double(minutes) * (1.0 / 60.0)
    let seconds = Int(round(remainder / (1.0 / 3600.0)))
    return (degrees, minutes, seconds, positive)
}

class LongLatFormatter {
    enum LongLatStyle {
        case dms
        case dd
    }
    
    var mode: LongLatInputView.Mode = .latitude
    var longLatStyle: LongLatStyle = .dms
    private var ddNumberFormatter: NumberFormatter = {
        () -> NumberFormatter in
        let f = NumberFormatter()
        f.maximumFractionDigits = 7
        f.numberStyle = .decimal
        return f
    }()
    
    func string(for degrees: CLLocationDegrees) -> String {
        if longLatStyle == .dd {
            return ddNumberFormatter.string(from: NSNumber(value: degrees)) ?? "\(degrees)"
        } else {
            let dms = decimalToDMS(decimalDegrees: degrees)
            let direction: String
            if mode == .latitude {
                direction = dms.positive ? "N" : "S"
            } else {
                direction = dms.positive ? "E" : "W"
            }
            return "\(dms.degrees)° \(dms.minutes)′ \(dms.seconds)″ \(direction)"
        }
    }
}
