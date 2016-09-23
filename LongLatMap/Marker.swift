import Foundation
import CoreData
import GoogleMaps

class Marker: NSManagedObject {
    
//    var mapMarker: GMSMarker?

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        longitude = longitude ?? 0
        latitude = latitude ?? 0
        desc = desc ?? ""
        title = title ?? ""
        rotation = rotation ?? 0
    }

    convenience init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?, longitude: Double, latitude: Double, desc: String, title: String, color: String?, rotation: Float) {
        self.init(entity: entity, insertInto: context)
        self.longitude = longitude as NSNumber?
        self.latitude = latitude as NSNumber?
        self.desc = desc
        self.title = title
        self.color = color
        self.rotation = rotation as NSNumber
    }
}
