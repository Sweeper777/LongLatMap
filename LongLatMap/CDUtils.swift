import CoreData
import UIKit

class CDUtils {
    static let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    static let markerEntity = NSEntityDescription.entity(forEntityName: "Marker", in: CDUtils.context)
    
    static func saveData() {
        _ = try? context.save()
    }
    
    static var allMarkers: [Marker] {
        let request = NSFetchRequest<Marker>()
        request.entity = CDUtils.markerEntity
        guard let anyObjs = try? context.fetch(request) else {
            return []
        }
        
        return anyObjs
    }
}
