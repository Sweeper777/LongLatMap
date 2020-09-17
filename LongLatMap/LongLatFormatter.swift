import Foundation
import CoreLocation

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