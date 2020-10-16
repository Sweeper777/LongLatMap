import Foundation

class CoordinateFormatter {
    var style = LongLatFormatter.LongLatStyle.dms {
        didSet {
            longitudeFormatter.longLatStyle = style
            latitudeFormatter.longLatStyle = style
        }
    }
    private var longitudeFormatter: LongLatFormatter
    private var latitudeFormatter: LongLatFormatter
    
    init() {
        longitudeFormatter = LongLatFormatter()
        longitudeFormatter.mode = .longitude
        latitudeFormatter = LongLatFormatter()
        latitudeFormatter.mode = .latitude
        longitudeFormatter.longLatStyle = style
        latitudeFormatter.longLatStyle = style
    }
}
