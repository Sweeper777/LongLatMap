import Foundation
import CoreLocation

class LongLatFormatter {
    
    enum LongLatStyle: Int, CustomStringConvertible {
        case dms
        case dd
        
        var description: String {
            switch self {
            case .dms:
                return "DMS"
            case .dd:
                return "DD"
            }
        }
    }
    
    var mode: LongLatInputView.Mode
    var longLatStyle: LongLatStyle
    
    init(mode: LongLatInputView.Mode = .latitude, style: LongLatStyle = .dms) {
        self.mode = mode
        self.longLatStyle = style
    }
    
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
                direction = dms.positive ? "N".localised : "S".localised
            } else {
                direction = dms.positive ? "E".localised : "W".localised
            }
            return String(format: "longLatFormat".localised, dms.degrees, dms.minutes, dms.seconds, direction)
        }
    }
}
