import GoogleMaps

enum MapType: String, CustomStringConvertible {
    case Normal = "Normal"
    case Satellite = "Satellite"
    case Hybrid = "Hybrid"
    case Terrain = "Terrain"
    
    var description: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    static let mapTypeDict: [MapType: GMSMapViewType] = [
        .Normal: kGMSTypeNormal,
        .Satellite: kGMSTypeSatellite,
        .Hybrid: kGMSTypeHybrid,
        .Terrain: kGMSTypeTerrain
    ]
}
