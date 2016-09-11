import CoreData
import UIKit

class CDUtils {
    static let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    static let markerEntity = NSEntityDescription.entityForName("Marker", inManagedObjectContext: CDUtils.context)
    
    static func saveData() {
        _ = try? context.save()
    }
    
    static var allMarkers: [Marker] {
        let request = NSFetchRequest()
        request.entity = CDUtils.markerEntity
        guard let anyObjs = try? context.executeFetchRequest(request) else {
            return []
        }
        
        let mapped: [Marker?] = anyObjs.map { $0 as? Marker }
        return mapped.filter { $0 != nil }.map { $0! }
    }
}