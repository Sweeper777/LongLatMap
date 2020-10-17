import CoreLocation

class CoordinateFormatter {
    var style: LongLatFormatter.LongLatStyle {
        didSet {
            longitudeFormatter.longLatStyle = style
            latitudeFormatter.longLatStyle = style
        }
    }
    private var longitudeFormatter: LongLatFormatter
    private var latitudeFormatter: LongLatFormatter
    
    init(style: LongLatFormatter.LongLatStyle = .dms) {
        self.style = style
        longitudeFormatter = LongLatFormatter()
        longitudeFormatter.mode = .longitude
        latitudeFormatter = LongLatFormatter()
        latitudeFormatter.mode = .latitude
        longitudeFormatter.longLatStyle = style
        latitudeFormatter.longLatStyle = style
    }
    
    func string(from coord: CLLocationCoordinate2D) -> String {
        let latitudeString = latitudeFormatter.string(for: coord.latitude)
        let longitudeString = longitudeFormatter.string(for: coord.longitude)
        return "\(latitudeString) \(longitudeString)"
    }
}
