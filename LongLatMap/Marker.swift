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
    
    override var description: String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 5
        let longitudeStr: String
        let latitudeStr: String
        if self.longitude!.doubleValue < 0 {
            longitudeStr = "\(formatter.string(from: abs(self.longitude!.doubleValue) as NSNumber)!) W"
        } else if self.longitude!.doubleValue > 0 {
            longitudeStr = "\(formatter.string(from: self.longitude!)!) E"
        } else {
            longitudeStr = formatter.string(from: self.longitude!)!
        }
        
        if self.latitude!.doubleValue < 0 {
            latitudeStr = "\(formatter.string(from: abs(self.latitude!.doubleValue) as NSNumber)!) S"
        } else if self.latitude!.doubleValue > 0 {
            latitudeStr = "\(formatter.string(from: self.latitude!)!) N"
        } else {
            latitudeStr = formatter.string(from: self.latitude!)!
        }
        
        return "\(NSLocalizedString("Longitude:", comment: "")) \(longitudeStr)\n\(NSLocalizedString("Latitude:", comment: "")) \(latitudeStr)\n\(self.desc ?? "")"
    }
}
