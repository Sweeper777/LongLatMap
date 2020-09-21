import RealmSwift
import CoreLocation

class Marker: Object {
    @objc dynamic var longitude = 0.0
    @objc dynamic var latitude = 0.0
    @objc dynamic var rotation = 0
    @objc dynamic var color = Color.red.hexString
    @objc dynamic var title = "Unnamed"
    @objc dynamic var desc = ""
    @objc dynamic var id = 0
    
    override class func primaryKey() -> String? {
        "id"
    }
    
    var location: CLLocationCoordinate2D {
        get { .init(latitude: latitude, longitude: longitude) }
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
}
