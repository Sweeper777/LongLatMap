import Eureka
import CoreLocation

final class LongitudeSelectorRow: SelectorRow<PushSelectorCell<CLLocationDegrees>> {
    required init(tag: String?, _ initializer: ((LongitudeSelectorRow) -> ())) {
        super.init(tag: tag)
        initializer(self)
        presentationMode = PresentationMode.segueName(segueName: "selectLongitude", onDismiss: nil)
        displayValueFor = {
            guard let longitude = $0 else { return "" }
            let (degrees, minutes, seconds) = decimalToDMS(longitude)
            let suffix = degrees < 0 ? "W" : "E"
            return "\(abs(degrees))° \(minutes)' \(seconds)\" \(suffix)"
        }
    }
    
    required convenience init(tag: String?) {
        self.init(tag: tag, {_ in})
    }
}
