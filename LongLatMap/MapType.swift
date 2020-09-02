import GoogleMaps

enum MapType: String, CustomStringConvertible {
    case normal = "Normal"
    case satellite = "Satellite"
    case hybrid = "Hybrid"
    case terrain = "Terrain"
    
    var description: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    static let mapTypeDict: [MapType: GMSMapViewType] = [
        .normal: kGMSTypeNormal,
        .satellite: kGMSTypeSatellite,
        .hybrid: kGMSTypeHybrid,
        .terrain: kGMSTypeTerrain
    ]
}
