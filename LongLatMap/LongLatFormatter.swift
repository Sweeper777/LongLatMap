import Foundation
import CoreLocation

class LongLatFormatter {
    
    static let sharedLongitudeFormatter = { () -> LongLatFormatter in
        let f = LongLatFormatter()
        f.mode = .longitude
        if UserSettings.longLatStyle == "DD" {
            f.longLatStyle = .dd
        } else {
            f.longLatStyle = .dms
        }
        return f
    }()
    
    static let sharedLatitudeFormatter = { () -> LongLatFormatter in
        let f = LongLatFormatter()
        f.mode = .latitude
        if UserSettings.longLatStyle == "DD" {
            f.longLatStyle = .dd
        } else {
            f.longLatStyle = .dms
        }
        return f
    }()
    
    enum LongLatStyle : CustomStringConvertible {
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
