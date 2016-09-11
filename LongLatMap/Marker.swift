import Foundation
import CoreData


class Marker: NSManagedObject {

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        longitude = 0
        latitude = 0
        desc = ""
        title = ""
    }

    convenience init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?, longitude: Double, latitude: Double, desc: String, title: String, color: Int?) {
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.longitude = longitude
        self.latitude = latitude
        self.desc = desc
        self.title = title
        self.color = color
    }
}
